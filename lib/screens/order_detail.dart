import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/correios.dart';
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
    Correios correio = Correios();
    List<TimelineModel> items = [];
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 22, 98, 187)),
          elevation: 0.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 30,
              width: 30,
              child: Image.asset(
                'assets/images/title.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
            if (model.isLoading) return CircularProgressIndicator();

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
                      color: Colors.white,
                    ),
                    child: ListTile(
                      title: Text(
                        widget.orderData['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(widget.orderData['shippingcode']),
                      leading: Icon(
                        OrderModel.iconOrder(
                            category: widget.orderData['category']),
                        size: 35,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                    future: correio.rastrear(
                        codigo: widget.orderData['shippingcode']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (dynamic evento in snapshot.data["eventos"]) {
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
                                          color: Color.fromARGB(255, 46, 46, 46)
                                              .withOpacity(0.1))
                                    ],
                                    color: Colors.white,
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
                        return Timeline(
                            children: items,
                            shrinkWrap: true,
                            lineColor: Colors.black12,
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
