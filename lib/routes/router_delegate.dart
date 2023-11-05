import 'package:flutter/material.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/main.dart';
import 'package:story_app/model/page_configuration.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/register_screen.dart';
import 'package:story_app/screens/splash_screen.dart';
import 'package:story_app/screens/story_screen.dart';
import 'package:story_app/screens/unknown_screen.dart';

class MyRouteDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final DatabaseRepository database;
  final AuthProvider authProvider = AuthProvider();

  MyRouteDelegate(
    this.database,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  void _init() async {
    isLoggedIn = await database.isLoggedIn();
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool? isUnknown;
  bool? isLoggedIn;
  bool isRegister = false;

  List<Page> historyStack = [];

  @override
  Widget build(BuildContext context) {
    if (isUnknown == true) {
      historyStack = _unknownStack;
    } else if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        isRegister = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.splash();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (isLoggedIn == true) {
      return PageConfiguration.story();
    } else {
      return PageConfiguration.unknown();
    }
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isLoginPage || configuration.isSplashPage) {
      isUnknown = false;
      isRegister = false;
    } else if (configuration.isStoryPage) {
      isUnknown = false;
      isRegister = false;
      isLoggedIn = true;
    } else if (configuration.isAddStoryPage) {
      isRegister = false;
      isLoggedIn = true;
    } else {
      print('Unknown route');
    }

    notifyListeners();
  }

  List<Page> get _unknownStack => const [
        MaterialPage(
          key: ValueKey('UnknownPage'),
          child: UnknownScreen(),
        ),
      ];

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey('SplashPage'),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey('LoginPage'),
          child: LoginScreen(
            onLogin: (String email, String password) async {
              authProvider.setIsFetching(true);
              await authProvider.login(email, password);
              isLoggedIn = authProvider.userToken != null;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey('RegisterPage'),
            child: RegisterScreen(
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
              onRegister: (name, email, password) {
                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  // throw alert error
                  showMyDialog(
                    'Error',
                    'Name, email and password cannot be empty',
                  );
                  return;
                }
                authProvider.register(name, email, password);
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey('StoryPage'),
          child: StoryScreen(
            logoutButtonOnPressed: () async {
              await authProvider.logout();
              isLoggedIn = false;
              notifyListeners();
            },
          ),
        ),
      ];
}
