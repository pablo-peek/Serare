import 'package:flutter/material.dart';
import 'package:serare/app.dart';
import 'package:serare/db/mongodb.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MongoDatabase.connect();
  runApp(const App());
}
