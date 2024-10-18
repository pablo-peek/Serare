import 'package:flutter/material.dart';
import 'package:serare/home.dart';
import 'package:serare/register.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const  Color.fromARGB(255, 75, 155, 88),
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/register': (context) => const Register(),
      },
    );
  }
}