import 'package:flutter/material.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/database/preferences.dart';
import 'package:story_app/localization/main.dart';
import 'package:story_app/model/page_configuration.dart';
import 'package:story_app/model/response/error_response.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/connectivity_provider.dart';
import 'package:story_app/provider/localization_provider.dart';
import 'package:story_app/provider/map_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/screens/add_story_screen.dart';
import 'package:story_app/screens/detail_story_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/my_dialog.dart';
import 'package:story_app/screens/register_screen.dart';
import 'package:story_app/screens/splash_screen.dart';
import 'package:story_app/screens/story_screen.dart';
import 'package:story_app/screens/unknown_screen.dart';

class MyRouteDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final DatabaseRepository database;
  final AuthProvider authProvider = AuthProvider();
  final Preferences preferences = Preferences();
  final LocalizationProvider localizationProvider = LocalizationProvider();
  final ConnectivityProvider connectivityProvider = ConnectivityProvider();
  final StoryProvider storyProvider = StoryProvider();
  final MapProvider mapProvider = MapProvider();

  MyRouteDelegate(
    this.database,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  void _init() async {
    isLoggedIn = await preferences.getUserToken() != null;
    await connectivityProvider.initConnectivity();
    var connectionStatus = connectivityProvider.connectionStatus.toString();
    if (connectionStatus == 'ConnectivityResult.none') {
      networkStatus = AppLocalizations.of(navigatorKey.currentContext!)!
          .networkErrorMessage;
      noConnection = true;
      notifyListeners();
    }
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  bool? isUnknown;
  bool? isLoggedIn;
  bool? addStory;
  bool? addStoryError;
  bool? noConnection;
  bool isRegister = false;
  String? selectedStoryId;
  String? notificationTitle;
  String? notificationMessage;
  String? networkStatus;
  String? locationStatus;

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

        if (networkStatus != null && noConnection == true) {
          connectivityProvider.initConnectivity();
          var newConnectionStatus =
              connectivityProvider.connectionStatus.toString();
          if (newConnectionStatus != 'ConnectivityResult.none') {
            networkStatus = null;
            noConnection = false;
            notificationMessage = null;
            notificationTitle = null;
            notifyListeners();
          }
          notifyListeners();
          return true;
        }

        if (notificationMessage != null &&
            notificationTitle != null &&
            locationStatus != null) {
          notificationMessage = null;
          notificationTitle = null;
          locationStatus = null;
          notifyListeners();
          return true;
        }

        if (notificationMessage != null &&
            notificationTitle != null &&
            addStory == true &&
            addStoryError == true) {
          notificationMessage = null;
          notificationTitle = null;
          notifyListeners();
          return true;
        }

        if (notificationMessage != null &&
            notificationTitle != null &&
            addStory == true) {
          notificationMessage = null;
          notificationTitle = null;
          addStory = false;
          notifyListeners();
          return true;
        }

        if (notificationMessage != null &&
            notificationTitle != null &&
            isRegister == true) {
          notificationMessage = null;
          notificationTitle = null;
          isRegister = false;
          notifyListeners();
          return true;
        }

        if (notificationMessage != null && notificationTitle != null) {
          notificationMessage = null;
          notificationTitle = null;
          notifyListeners();
          return true;
        }

        if (selectedStoryId != null) {
          selectedStoryId = null;
          mapProvider.clearMarkerAndPlacemark();
          notifyListeners();
          return true;
        }

        selectedStoryId = null;
        isRegister = false;
        addStory = false;
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
    } else if (addStory == true) {
      return PageConfiguration.addStory();
    } else if (selectedStoryId != null) {
      return PageConfiguration.storyDetail(selectedStoryId!);
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
      addStory = true;
    } else if (configuration.isStoryDetailPage) {
      isRegister = false;
      isUnknown = false;
      selectedStoryId = configuration.storyId.toString();
    } else {
      throw Exception('Unknown route');
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
              var response = await authProvider.login(email, password);
              if (response.error == true) {
                notificationTitle =
                    AppLocalizations.of(navigatorKey.currentContext!)!
                        .loginFailed;
                notificationMessage = response.message;
                notifyListeners();
                return;
              } else if (response.error == false) {
                notificationTitle =
                    AppLocalizations.of(navigatorKey.currentContext!)!.success;
                notificationMessage =
                    AppLocalizations.of(navigatorKey.currentContext!)!
                        .loginSuccess;
              }
              storyProvider.initDetailStory();
              await storyProvider.getAllStories();
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
              onRegister: (name, email, password) async {
                var response =
                    await authProvider.register(name, email, password);

                if (response.error == true) {
                  notificationTitle =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .registerFailed;
                  notificationMessage = response.message;
                  notifyListeners();
                  return;
                } else if (response.error == false) {
                  notificationTitle =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .success;
                  notificationMessage =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .registerSuccess;
                }
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
        if (notificationTitle != null && notificationMessage != null)
          MyDialog(
            title: notificationTitle!,
            message: notificationMessage!,
            onOk: () {
              notificationMessage = null;
              notificationTitle = null;
              notifyListeners();
            },
          ),
        if (networkStatus != null && noConnection == true)
          MyDialog(
            title:
                AppLocalizations.of(navigatorKey.currentContext!)!.networkError,
            message: AppLocalizations.of(navigatorKey.currentContext!)!
                .networkErrorMessage,
            onOk: () {
              notificationMessage = null;
              notificationTitle = null;
              notifyListeners();
            },
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey('StoryPage'),
          child: StoryScreen(
            logoutButtonOnPressed: () async {
              var response = await authProvider.logout();
              if (response.error == true) {
                notificationTitle =
                    AppLocalizations.of(navigatorKey.currentContext!)!
                        .logoutFailed;
                notificationMessage = response.message;
                locationStatus = response.message;
                notifyListeners();
                return;
              } else if (response.error == false) {
                notificationTitle =
                    AppLocalizations.of(navigatorKey.currentContext!)!.success;
                notificationMessage =
                    AppLocalizations.of(navigatorKey.currentContext!)!
                        .logoutSuccess;
              }
              isLoggedIn = false;
              notifyListeners();
            },
            onTapped: (String id, ErrorResponse response) async {
              if (response.error == true) {
                notificationTitle =
                    AppLocalizations.of(navigatorKey.currentContext!)!
                        .locationError;
                notificationMessage = response.message;
                selectedStoryId = id;
                notifyListeners();
                return;
              } else if (response.error == false) {
                selectedStoryId = id;
                notifyListeners();
              }
            },
            onAddStoryButtonPressed: () async {
              addStory = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedStoryId != null)
          MaterialPage(
            key: const ValueKey('StoryDetailPage'),
            child: DetailStoryScreen(
              storyId: selectedStoryId!,
            ),
          ),
        if (addStory == true)
          MaterialPage(
            key: const ValueKey('AddStoryPage'),
            child: AddStoryScreen(
              addStoryButtonOnPressed: (bool error, String message) {
                if (error == true) {
                  notificationTitle =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .addStoryFailed;
                  notificationMessage = message;
                  addStoryError = true;
                  notifyListeners();
                  return;
                } else if (error == false) {
                  notificationTitle =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .success;
                  notificationMessage =
                      AppLocalizations.of(navigatorKey.currentContext!)!
                          .addStorySuccess;
                  addStoryError = false;
                  notifyListeners();
                }
              },
            ),
          ),
        if (notificationTitle != null && notificationMessage != null)
          MyDialog(
            title: notificationTitle!,
            message: notificationMessage!,
            onOk: () {
              notificationMessage = null;
              notificationTitle = null;
              if (addStoryError != true) {
                addStory = false;
              }
              notifyListeners();
            },
          ),
        if (networkStatus != null && noConnection == true)
          MyDialog(
            title:
                AppLocalizations.of(navigatorKey.currentContext!)!.networkError,
            message: AppLocalizations.of(navigatorKey.currentContext!)!
                .networkErrorMessage,
            onOk: () {
              notificationMessage = null;
              notificationTitle = null;
              notifyListeners();
            },
          ),
      ];
}
