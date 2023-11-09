import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/database/db.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/localization/main.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/connectivity_provider.dart';
import 'package:story_app/provider/localization_provider.dart';
import 'package:story_app/provider/map_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes/route_information_parser.dart';
import 'package:story_app/routes/router_delegate.dart';
import 'package:timezone/data/latest.dart' as tz;

main() async {
  tz.initializeTimeZones();
  FlavorConfig(
    flavor: FlavorType.dev,
    color: Colors.orange,
    values: const FlavorValues(
      titleApp: "Story App Dev",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MapProvider(),
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
      title: FlavorConfig.instance.values.titleApp,
      theme: ThemeData(
        primarySwatch: FlavorConfig.instance.color,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: context.watch<LocalizationProvider>().locale,
      home: Router(
        routerDelegate: _routeDelegate,
        routeInformationParser: myRouteInformationParser,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
