import 'package:flutter/material.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:statusbar/statusbar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    StatusBar.color(Color.fromARGB(255, 22, 98, 187));
    return ScopedModel<UserModel>(
      model: UserModel(
        
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rastreimy',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 22, 98, 187),
            fontFamily: "Red Hat Display",
            textTheme: TextTheme(
              bodyText1: TextStyle(
                color: Color.fromARGB(255, 30, 30, 30)
              )
            )
            ),
            
        home: HomeScreen(),
      ),
    );
  }
}
