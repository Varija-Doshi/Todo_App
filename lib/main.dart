import 'package:flutter/material.dart';
import 'package:Todo_App/ui/Todo_ui.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: ' Tasks ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          accentColor: Colors.purple,
        ),
        home: TodoUi(),
      ); 
  }
}
