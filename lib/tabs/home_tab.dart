import 'package:flutter/material.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() =>
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (!model.isLoggedIn()) {
            return Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 252, 252, 252)),
              child: Center(
                child: Container(
                  height: 550,
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/images/login.png'),
                      Text(
                        "Faça login ou crie uma conta \npara salvar suas encomendas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container(
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 252, 252, 252)),
          );
        });

    return SafeArea(
      child: Stack(
        children: <Widget>[
          _buildBodyBack(),
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      'assets/images/title.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  centerTitle: true,
                ),
                iconTheme:
                    IconThemeData(color: Color.fromARGB(255, 22, 98, 187)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
