import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/add_order_screen.dart';
import 'package:rastreimy/screens/login_screen.dart';
import 'package:rastreimy/screens/order_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => SafeArea(
          child: Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                offset: Offset(0, 1),
                                color: Color.fromARGB(255, 46, 46, 46)
                                    .withOpacity(0.1))
                          ],
                          color: Theme.of(context).cardColor,
                        ),
                        child: FutureBuilder(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 10),
                                      child: Container(
                                        child: Get.isDarkMode
                                            ? Image.asset(
                                                'assets/images/title-dark.png',
                                                fit: BoxFit.contain,
                                              )
                                            : Image.asset(
                                                'assets/images/title.png',
                                                fit: BoxFit.contain,
                                              ),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.appName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Versão do aplicativo ${snapshot.data.version}",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 10, right: 10),
                                      child: Text(
                                        "Aplicativo de rastreio de encomendas correios. Simples e Rápido. ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Desenvolvido por undatus ",
                                            textAlign: TextAlign.center,
                                          ),
                                          FlatButton.icon(
                                              onPressed: () async {
                                                const url =
                                                    'https://undatus.tech';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  Get.snackbar(
                                                      "Não foi possivel abrir",
                                                      "Não foi possivel abrir o site da undatus.");
                                                }
                                              },
                                              icon:
                                                  Icon(LineAwesomeIcons.globe),
                                              label: Text("Site"))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                    child: Shimmer.fromColors(
                                        baseColor: Colors.black12,
                                        highlightColor: Colors.black26,
                                        child: Container(
                                          width: 150,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )));
                              }
                            }))),
              ],
            ),
          ),
        );
    return SafeArea(
      child: Stack(
        children: <Widget>[
          CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Get.isDarkMode
                        ? Image.asset(
                            'assets/images/title-dark.png',
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/title.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  centerTitle: true,
                ),
                iconTheme:
                    IconThemeData(color: Get.theme.primaryColor),
              ),
            ],
          ),
          _buildBodyBack(),
        ],
      ),
    );
  }
}
