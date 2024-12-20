import 'package:flutter/material.dart';
import 'package:flutter_app_users/blocs/internet_connection/bloc/internet_bloc.dart';
import 'package:flutter_app_users/presentation/screens/screens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InternetBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Sales Mobility',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('es', ''),
        ],
        initialRoute: LoadConfigScreen.routeName,
        //initialRoute: HomeScreen.routeName,
        routes: {
          LoadConfigScreen.routeName: (_) => const LoadConfigScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          PrecioScreen.routeName: (_) => const PrecioScreen(),
          MainScreen.routeName: (_) => const MainScreen(),
          ChannelMapScreen.routeName: (_) => const ChannelMapScreen(),
          VisitaScreen.routeName: (_) => const VisitaScreen()
        },
      ),
    );
  }
}
