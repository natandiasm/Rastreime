import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/add_order_screen.dart';
import 'package:rastreimy/tabs/about_tab.dart';
import 'package:rastreimy/tabs/delivered_tab.dart';
import 'package:rastreimy/tabs/home_tab.dart';
import 'package:rastreimy/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:statusbar/statusbar.dart';

import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    StatusBar.color(Get.theme.primaryColor);
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 62.0,
    ));
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      void _pressAddButton() {
        if (!model.isLoggedIn()) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddOrderScreen()),
          );
        }
      }

      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: HomeTab(),
            drawer: CustomDrawer(_pageController),
            persistentFooterButtons: fakeBottomButtons,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add,
                  color: Get.isDarkMode
                      ? Theme.of(context).textTheme.bodyText1.color
                      : Colors.white),
              onPressed: () {
                _pressAddButton();
              },
            ),
          ),
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: DeliveredTab(),
            drawer: CustomDrawer(_pageController),
            persistentFooterButtons: fakeBottomButtons,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Get.isDarkMode
                    ? Get.textTheme.bodyText1.color
                    : Colors.white,
              ),
              onPressed: () {
                _pressAddButton();
              },
            ),
          ),
          Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: AboutTab(),
            drawer: CustomDrawer(_pageController),
            persistentFooterButtons: fakeBottomButtons,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
              onPressed: () {
                _pressAddButton();
              },
            ),
          ),
        ],
      );
    });
  }
}
