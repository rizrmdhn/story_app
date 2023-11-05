import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/route_information_parser.dart';
import 'package:story_app/routes/router_delegate.dart';

final navigatorKey = GlobalKey<NavigatorState>();
main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouteInformationParser myRouteInformationParser;
  late MyRouteDelegate _routeDelegate;

  @override
  void initState() {
    final database = DatabaseRepository();
    super.initState();
    _routeDelegate = MyRouteDelegate(database);

    myRouteInformationParser = MyRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: Router(
        routerDelegate: _routeDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}

void showMyDialog(String title, String content) {
  showDialog(
    context: navigatorKey.currentState!.overlay!.context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
