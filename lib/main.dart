import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp/pages/chat_view/chat_view.dart';

import 'package:whatsapp/pages/create_account_view/create_account_view.dart';
import 'package:whatsapp/pages/home_view/home_view.dart';
import 'package:whatsapp/pages/login_view/login_view.dart';

import 'core/theme/applicationTheme.dart';
import 'firebase_options.dart';
SharedPreferences? prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
   prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DisRoom",
      debugShowCheckedModeBanner: false,
      theme: ApplicationTheme.lightTheme,
      initialRoute: LoginView.routeName,
      routes: {
        LoginView.routeName: (context) => LoginView(),
        CreateAccount.routeName: (context) => CreateAccount(),
        HomeView.routeName: (context) => HomeView(),

      },
      builder: EasyLoading.init(builder: BotToastInit()),
    );
  }
}
