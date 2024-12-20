import 'package:flutter/material.dart';
import 'package:flutter_app_users/presentation/screens/screens.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class LoadConfigScreen extends StatefulWidget {
  static String routeName = '/';

  const LoadConfigScreen({super.key});

  @override
  State<LoadConfigScreen> createState() => _LoadConfigScreenState();
}

class _LoadConfigScreenState extends State<LoadConfigScreen> {
  bool _statusLogin = false;

  @override
  void initState() {
    super.initState();
    initiliaze();
  }

  Future<void> initiliaze() async {
    // Initialize the app
    final prefLoginStatus = await SharedPreferences.getInstance();
    _statusLogin = prefLoginStatus.getBool('StatusLogin') ?? false;

    developer.log('Login Status: $_statusLogin', name: 'my.app.developer');

    FlutterNativeSplash.remove();

    // Verifica si el widget aún está en el árbol de widgets
    if (!mounted) return;

    // Después de completar las configuraciones, navega a la pantalla de login
    Navigator.pushReplacementNamed(
      context,
      _statusLogin ? MainScreen.routeName : LoginScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1976D2),
          ),
        ),
      ),
    );
  }
}
