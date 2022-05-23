import 'package:flutter/material.dart';
import 'package:flutter_money_calc/views/mainPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final String appName = '財布の中身計算機';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: appName),
    );
  }
}

