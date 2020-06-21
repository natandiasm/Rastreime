import 'package:flutter/material.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/add_order_screen.dart';
import 'package:rastreimy/tabs/home_tab.dart';
import 'package:rastreimy/widgets/custom_drawer.dart';
import 'package:scoped_model/scoped_model.dart';

import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            body: HomeTab(),
            drawer: CustomDrawer(_pageController),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
              onPressed: () {
                if (!model.isLoggedIn()) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddOrderScreen()),
                  );
                }
              },
            ),
          ),
          Container(color: Colors.amber),
          Container(color: Colors.grey),
        ],
      );
    });
  }
}
