import 'package:community_profiles/user_interfaces/login_form.dart';
import 'package:community_profiles/user_interfaces/registration_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const UserAuth(),
    routes: {
      '/register': (context) => const RegisterUser(),
    },
  ));
}



