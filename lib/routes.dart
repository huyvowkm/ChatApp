
import 'package:chat_app/views/account/account_view.dart';
import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/views/home/home_view.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/register/register_view.dart';
import 'package:chat_app/views/search/search_view.dart';
import 'package:chat_app/views/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static late Map<String, Widget Function(BuildContext)> _route;

  static Map<String, Widget Function(BuildContext)> init(BuildContext context) {
    _route = {
      '/splash': (_) => const SplashView(),
      '/home': (_) => const HomeView(),
      '/login': (_) => const LoginView(),
      '/register': (_) => const RegisterView(),
      '/account': (_) => const AccountView(),
      '/chat': (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return ChatView(
          idChat: args['id_chat'] ?? '',
          name: args['name'] ?? '',
          avatar: args['avatar'] ?? '',
          users: args['users'] ?? [],
        );
      },
      '/search': (_) => const SearchView(),
    };
    return _route;
  }
}

class RoutingService {
  static final routeConfig = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashView()
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeView()
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginView()
      ),
      GoRoute(
        path: '/register', 
        builder: (_, __) => const RegisterView()
      ),
      GoRoute(
        path: '/account',
        builder: (_, __) => const AccountView()
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ChatView(
            idChat: args['id_chat'] ?? '',
            name: args['name'] ?? '',
            avatar: args['avatar'] ?? '',
            users: args['users'] ?? [],
          );
        }
      ),
      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchView()
      ),
    ]
  );
}