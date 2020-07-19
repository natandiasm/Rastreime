import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/login_screen.dart';
import 'package:rastreimy/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(
              left: 32.0,
              top: 20.0,
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: 8.0,
                ),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      child: IconButton(
                          icon: Icon(Get.isDarkMode
                              ? Icons.wb_sunny
                              : Icons.brightness_2),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            Get.isDarkMode
                                ? prefs.setBool("themeDark", false)
                                : prefs.setBool("themeDark", true);
                            Get.changeThemeMode(Get.isDarkMode
                                ? ThemeMode.light
                                : ThemeMode.dark);
                          }),
                    ),
                    Positioned(
                        top: 25.0,
                        left: 0.0,
                        child: Container(
                            width: 50,
                            height: 50,
                            child: Get.isDarkMode
                                ? Image.asset('assets/images/title-dark.png')
                                : Image.asset('assets/images/title.png'))),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          print(model.isLoggedIn());
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? "Entre ou cadastre-se > "
                                      : "Sair",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn())
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  else
                                    model.signOut();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(
                LineAwesomeIcons.home,
                "Inicio",
                pageController,
                0,
              ),
              DrawerTile(
                LineAwesomeIcons.check_circle,
                "Entregues",
                pageController,
                1,
              ),
              DrawerTile(
                LineAwesomeIcons.info,
                "Sobre",
                pageController,
                2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
