import 'package:flutter/material.dart';
import 'package:kesehatan/helpers/user_info.dart';
import 'package:kesehatan/ui/login_page.dart';
import 'package:kesehatan/ui/nutrisi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const NutrisiPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kesehatan - Nutrisi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Georgia', // Mengatur font default
      ),
      home: page,
    );
  }
}
