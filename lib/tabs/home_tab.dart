import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/order_model.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/order_detail.dart';
import 'package:rastreimy/util/correios.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Correios correio = Correios();
    Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 1, color: Colors.black12, offset: Offset(0, 2))
            ],
            color: Colors.white,
          ),
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Editar',
                color: Colors.transparent,
                foregroundColor: Color.fromARGB(255, 22, 98, 187),
                icon: LineAwesomeIcons.pencil,
                onTap: () => {},
              ),
              IconSlideAction(
                caption: 'Excluir',
                color: Colors.transparent,
                foregroundColor: Colors.deepOrange,
                icon: LineAwesomeIcons.trash,
                onTap: () => {},
              ),
            ],
            child: ListTile(
              title: Text(document['name']),
              subtitle: FutureBuilder(
                  future: correio.rastrear(codigo: document['shippingcode']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return 
                          Container(
                            child: Text(
                              snapshot.data["eventos"][0]["local"],
                              style: TextStyle(fontSize: 13.0),
                            ));
                  
                    } else {
                      return Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.black26,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)
                            ),
                          ));
                    }
                  }),
              leading: Icon(
                OrderModel.iconOrder(category: document['category']),
                size: 35,
              ),
              onTap: () {
                Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => OrderDetailScreen(orderData: document,)),
                    );
              },
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
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: StreamBuilder<QuerySnapshot>(
                  stream: OrderModel.listOrder(user: model, onFail: () {}),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("Carregando..."),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, item) {
                          return _buildListTile(
                              context, snapshot.data.documents[item]);
                        });
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
          _buildBodyBack(),
        ],
      ),
    );
  }
}
