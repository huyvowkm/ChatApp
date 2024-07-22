
import 'package:chat_app/views/home/home_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/home': (_) => const HomeView(),
    };
    return _route;
  }
}