import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    final auth = FirebaseAuth.instance;

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (auth.currentUser == null) {
        GetIt.I<NavigationHelper>().goToLogin();
      } else {
        GetIt.I<NavigationHelper>().goToMap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 29, 70),
      body: Center(
        child: Text('Splash Page'),
      ),
    );
  }
}
