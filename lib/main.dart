import 'package:flare_splash_screen/flare_splash_screen.dart';
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
            backgroundColor: Colors.white,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                color: Color.fromARGB(255, 30, 30, 30)
              )
            )
            ),
            
        home: SplashScreen.navigate(
          name: 'assets/flare/splash-screen.flr',
          next: (_) => HomeScreen(),
          backgroundColor: Colors.white,
          fit: BoxFit.cover,
          until: () => Future.delayed(Duration(seconds: 0)),
          startAnimation: 'play',
        ),
      ),
    );
  }
}
