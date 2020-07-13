import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/util/correios.dart';

class OrderModel {
  static Firestore _database = Firestore.instance;

  static addOrder(
      {@required Map<String, dynamic> orderData,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    Correios correio = Correios();
    correio.rastrear(codigo: orderData["shippingcode"]).then((value) {
      Firestore database = Firestore.instance;
      database
          .collection('orders')
          .document()
          .setData(orderData)
          .catchError((e) {
        onFail();
      });
      onSucess();
    }).catchError((e) {
      onFail();
    });
  }

  static updateOrder(
      {@required DocumentSnapshot order,
      @required Map<String, dynamic> orderData,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    _database
        .collection('orders')
        .document(order.documentID)
        .updateData(orderData)
        .catchError((e) {
      onFail();
    });
    onSucess();
  }

  static removeOrder(
      {@required DocumentSnapshot order,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    _database
        .collection('orders')
        .document(order.documentID)
        .delete()
        .catchError((e) {
      onFail();
    });
    onSucess();
  }

  static VoidCallback removeOrderUI(
      {@required DocumentSnapshot order}) {
    Widget cancelaButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continuaButton = FlatButton(
      child: Text(
        "Continuar",
        style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        removeOrder(
            order: order,
            onSucess: () {
              Get.back();
            },
            onFail: () {
              Get.snackbar('Não foi excluido.', 'Não foi possivel fazer a exclusão da encomenda.');
            });
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        "Exclusão da encomenda",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content:
      Text("A sua encomenda será excluida da sua conta, deseja continuar?"),
      actions: [
        cancelaButton,
        continuaButton,
      ],
    );
    Get.dialog(alert);
  }

  static listOrder(
      {@required UserModel user,
      @required VoidCallback onFail,
      @required bool delivered}) {
    Stream<QuerySnapshot> snapshots;
    if (delivered == null) {
      snapshots = _database
          .collection('orders')
          .where("user", isEqualTo: user.firebaseUser.uid)
          .snapshots();
    } else {
      snapshots = _database
          .collection('orders')
          .where("user", isEqualTo: user.firebaseUser.uid)
          .where("delivered", isEqualTo: delivered)
          .snapshots();
    }
    return snapshots;
  }

  static Future<DocumentSnapshot> getOrderById(
      {@required String id, @required VoidCallback onFail}) {
    Future<DocumentSnapshot> snapshots;
    snapshots = _database.collection('orders').document(id).get();
    return snapshots;
  }

  static iconTrackingOrder({@required String status}) {
    switch (status.toLowerCase()) {
      case "objeto postado":
        return [LineAwesomeIcons.cube, Colors.grey];
        break;
      case "objeto encaminhado":
        return [LineAwesomeIcons.truck, Get.theme.primaryColor];
        break;
      case "objeto recebido na unidade de exportação no país de origem":
        return [LineAwesomeIcons.plane, Colors.green];
        break;
      case "objeto recebido pelos Correios do Brasil":
        return [LineAwesomeIcons.globe, Colors.green];
        break;
      case "fiscalização aduaneira finalizada":
        return [LineAwesomeIcons.frown_o, Colors.orange];
        break;
      case "objeto aguardando retirada no endereço indicado":
        return [LineAwesomeIcons.street_view, Colors.amber];
        break;
      case "objeto ainda não chegou à unidade":
        return [LineAwesomeIcons.exclamation, Colors.deepOrangeAccent];
        break;
      case "objeto entregue ao destinatário":
        return [LineAwesomeIcons.smile_o, Colors.lightGreen];
        break;
      default:
        return [LineAwesomeIcons.truck, Get.theme.primaryColor];
        break;
    }
  }
}
