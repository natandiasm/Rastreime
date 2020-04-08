import 'package:flutter/material.dart';
import 'package:rastreimy/tabs/home_tab.dart';
import 'package:rastreimy/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){},
          ),
        ),
        Container(color: Colors.amber),
        Container(color: Colors.grey),
      ],
    );
  }
}
