import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/category_model.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/add_order_screen.dart';
import 'package:rastreimy/screens/login_screen.dart';
import 'package:rastreimy/screens/order_detail.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 1),
                  color: Color.fromARGB(255, 46, 46, 46).withOpacity(0.1))
            ],
            color: Theme.of(context).cardColor,
          ),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Editar',
                color: Colors.transparent,
                foregroundColor: Theme.of(context).primaryColor,
                icon: LineAwesomeIcons.pencil,
                onTap: () {
                  Get.to(AddOrderScreen(order: document));
                },
              ),
              IconSlideAction(
                  caption: 'Excluir',
                  color: Colors.transparent,
                  foregroundColor: Colors.deepOrange,
                  icon: LineAwesomeIcons.trash,
                  onTap: () {
                    OrderModel.removeOrderUI(order: document);
                  }),
            ],
            child: Center(
              child: ListTile(
                title: Text(
                  document['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: document["events"] != 0
                    ? Container(
                        child: Text(
                        "${document["tranckingEvents"][0]["local"]} - ${document["tranckingEvents"][0]["status"]}",
                        style: TextStyle(fontSize: 13.0),
                      ))
                    : Container(
                        child: Text(
                        "Ainda não tem informações.",
                        style: TextStyle(fontSize: 13.0),
                      )),
                leading: Icon(
                    CategoryModel.getIconById(name: document['category']),
                    size: 35,
                    color: Theme.of(context).primaryColor),
                trailing: document["events"] != 0
                    ? Icon(
                        OrderModel.iconTrackingOrder(
                            status: document["tranckingEvents"][0]
                                ["status"])[0],
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )
                    : Icon(LineAwesomeIcons.question),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(
                              orderData: document,
                            )),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildBodyBack() =>
        ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (!model.isLoggedIn()) {
            return Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).backgroundColor),
              child: Center(
                child: Container(
                  height: 365,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 200,
                          child: Hero(
                              tag: "icon-login",
                              child: Get.isDarkMode
                                  ? Image.asset(
                                      'assets/images/login-dark.png',
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset('assets/images/login.png'))),
                      Text(
                        "Faça login ou crie uma conta \npara salvar suas encomendas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: SizedBox(
                          height: 60.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            textColor: Colors.white,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Get.to(LoginScreen());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: StreamBuilder<QuerySnapshot>(
                  stream: OrderModel.listOrder(
                      user: model, delivered: false, onFail: () {}),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.black26,
                            child: Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5)),
                            )),
                      );
                    }
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Container(
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Olá, ${model.userData["name"]}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      "Vamos ver como estão suas encomendas hoje."),
                                ],
                              ),
                            ),
                          ),
                        ),
                        snapshot.data.documents.length != 0
                            ? AnimationLimiter(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, item) {
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: item,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: _buildListTile(context,
                                                snapshot.data.documents[item]),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: 200,
                                        child: Get.isDarkMode
                                            ? Image.asset(
                                                'assets/images/empty-order-dark.png')
                                            : Image.asset(
                                                'assets/images/empty-order.png')),
                                    Text(
                                      "Você não tem encomendas cadastradas ou elas já foram todas entregues.",
                                      textAlign: TextAlign.center,
                                    ),
                                    Text("Para adicionar, toque no botão +")
                                  ],
                                ),
                              ),
                      ],
                    );
                  }),
            ),
          );
        });

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
                actionsIconTheme: IconThemeData(color: Get.theme.primaryColor),
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
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
              ),
            ],
          ),
          _buildBodyBack(),
        ],
      ),
    );
  }
}
