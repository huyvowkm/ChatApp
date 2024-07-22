
import 'package:chat_app/views/home/home_view.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/register/register_view.dart';
import 'package:chat_app/views/splash/splash_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/splash': (_) => const SplashView(),
      '/home': (_) => const HomeView(),
      '/login': (_) => const LoginView(),
      '/register': (_) => const RegisterView(),
    };
    return _route;
  }
}