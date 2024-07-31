import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/views/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      splash: 'assets/images/chat_app_icon.png',
      backgroundColor: Colors.black54, 
      animationDuration: Durations.extralong4,
      splashTransition: SplashTransition.fadeTransition,
      screenRouteFunction: () async => ref.watch(splashViewModel).checkAuthUser() == null ? '/login' : '/home',
    );
  }
}