import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';
import 'package:location_tracker/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providers: providers,
      actions: [
        SignedOutAction((context) {
          GetIt.I<NavigationHelper>().goToLogin();
        }),
      ],
      children: [
        ElevatedButton(
          onPressed: () {
            GetIt.I<NavigationHelper>().goToMap();
          },
          child: const Text('Go to Map'),
        )
      ],
    );
  }
}
