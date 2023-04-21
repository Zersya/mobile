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

    if (auth.currentUser == null) {
      GetIt.I<NavigationHelper>().goToLogin();
    } else {
      Future<void>.delayed(const Duration(seconds: 2), () {
        GetIt.I<NavigationHelper>().goToProfile();
      });
    }
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
