import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/category_model.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/dateWeekends.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final DocumentSnapshot orderData;

  @override
  _OrderDetailScreen createState() => _OrderDetailScreen();

  OrderDetailScreen({Key key, this.orderData}) : super(key: key);
}

class _OrderDetailScreen extends State<OrderDetailScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<TimelineModel> items = [];
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 68.0,
    ));
    return Scaffold(
        key: _scaffoldKey,
        persistentFooterButtons: fakeBottomButtons,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 30,
              width: 30,
              child: Get.isDarkMode
                  ? Image.asset(
                      'assets/images/title-dark.png',
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      'assets/images/title.png',
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          iconTheme: IconThemeData(color: Get.theme.primaryColor),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
            if (model.isLoading) return CircularProgressIndicator();
            DateTime dateStart;
            DateTime dateFinal;
            if (widget.orderData["events"] != 0) {
              List dateString = widget.orderData["tranckingEvents"]
                      [widget.orderData["events"] - 1]["data"]
                  .split("/");
              dateStart = DateTime(int.parse(dateString[2]),
                  int.parse(dateString[1]), int.parse(dateString[0]));
              if (widget.orderData["delivered"]) {
                List dateFinalString =
                    widget.orderData["tranckingEvents"][0]["data"].split("/");
                dateFinal = DateTime(
                    int.parse(dateFinalString[2]),
                    int.parse(dateFinalString[1]),
                    int.parse(dateFinalString[0]));
              } else
                dateFinal = DateTime.now();
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  child: Container(
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
                    child: ListTile(
                      title: Text(
                        widget.orderData['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.orderData["events"] != 0
                                ? Text(
                                    "${DateWeekends.getDifferenceWithoutWeekends(dateStart, dateFinal)}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text("0",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                            Text("Dias úteis"),
                          ],
                        ),
                      ),
                      subtitle: Text(widget.orderData['shippingcode']),
                      leading: Icon(
                        CategoryModel.getIconById(
                            name: widget.orderData['category']),
                        size: 35,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: OrderModel.getOrderById(
                        id: widget.orderData.documentID, onFail: () {}),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data["events"] != 0) {
                          for (dynamic evento
                              in snapshot.data["tranckingEvents"]) {
                            dynamic iconAndColor = OrderModel.iconTrackingOrder(
                                status: evento["status"]);
                            items.add(TimelineModel(
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 5,
                                            offset: Offset(0, 1),
                                            color:
                                                Color.fromARGB(255, 46, 46, 46)
                                                    .withOpacity(0.1))
                                      ],
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      child: ListTile(
                                        title: Text(evento["local"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(evento["status"]),
                                        trailing: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(evento["data"]),
                                            Text(evento["hora"])
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                position: TimelineItemPosition.random,
                                iconBackground: iconAndColor[1],
                                icon: Icon(
                                  iconAndColor[0],
                                  color: Colors.white,
                                )));
                          }
                        } else {
                          items.add(TimelineModel(
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 5,
                                          offset: Offset(0, 1),
                                          color: Color.fromARGB(255, 46, 46, 46)
                                              .withOpacity(0.1))
                                    ],
                                    color: Get.theme.cardColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: ListTile(
                                      title: Text("Sem informação",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                          "Ainda não tem informações disponiveis para esse código."),
                                    ),
                                  ),
                                ),
                              ),
                              position: TimelineItemPosition.random,
                              iconBackground: Colors.amber,
                              icon: Icon(
                                LineAwesomeIcons.exclamation,
                                color: Colors.white,
                              )));
                        }
                        return Timeline(
                            children: items,
                            shrinkWrap: true,
                            lineColor: Get.isDarkMode
                                ? Theme.of(context).cardColor
                                : Colors.black12,
                            position: TimelinePosition.Left);
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
                                    borderRadius: BorderRadius.circular(5)),
                              )),
                        );
                      }
                    }),
              ],
            );
          }),
        ));
  }
}
