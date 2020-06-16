import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/user_model.dart';

class OrderModel {
  static addOrder(
      {@required Map<String, dynamic> orderData,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    Firestore database = Firestore.instance;
    database.collection('orders').document().setData(orderData).catchError((e) {
      onFail();
    });
    onSucess();
  }

  static listOrder({@required UserModel user, @required VoidCallback onFail}) {
    Firestore database = Firestore.instance;
    Stream<QuerySnapshot> snapshots;
    snapshots = database
        .collection('orders')
        .where("user", isEqualTo: user.firebaseUser.uid)
        .snapshots();
    return snapshots;
  }

  static iconOrder({@required String category}) {
    switch (category) {
      case "eletronico":
        return LineAwesomeIcons.headphones;
        break;
      case "smartphone":
        return LineAwesomeIcons.mobile_phone;
        break;
      case "computador":
        return LineAwesomeIcons.laptop;
        break;
      case "jogo":
        return LineAwesomeIcons.gamepad;
        break;
      case "eletrodomestico":
        return LineAwesomeIcons.tv;
        break;
      case "livro":
        return LineAwesomeIcons.book;
        break;
      case "ferramenta":
        return LineAwesomeIcons.wrench;
        break;
      case "esporte":
        return LineAwesomeIcons.futbol_o;
        break;
      case "roupa":
        return LineAwesomeIcons.female;
        break;
      case "bolsa":
        return LineAwesomeIcons.briefcase;
        break;
      case "comida":
        return LineAwesomeIcons.coffee;
        break;
      default:
        return LineAwesomeIcons.plus;
        break;
    }
  }

  static iconTrackingOrder({@required String status}) {
    switch (status) {
      case "Objeto postado":
        return [LineAwesomeIcons.cube, Colors.grey];
        break;
      case "Objeto encaminhado":
        return [LineAwesomeIcons.truck, Color.fromARGB(255, 22, 98, 187)];
        break;
      case "Objeto recebido na unidade de exportação no país de origem":
        return [LineAwesomeIcons.plane, Colors.green];
        break;
      case "Objeto recebido pelos Correios do Brasil":
        return [LineAwesomeIcons.globe, Colors.green];
        break;
      case "Fiscalização aduaneira finalizada":
        return [LineAwesomeIcons.frown_o, Colors.orange];
        break;
      case "Objeto aguardando retirada no endereço indicado":
        return [LineAwesomeIcons.street_view, Colors.amber];
        break;
      case "Objeto entregue ao destinatário":
        return [LineAwesomeIcons.smile_o, Colors.lightGreen];
        break;
      default:
        return [LineAwesomeIcons.truck, Color.fromARGB(255, 22, 98, 187)];
        break;
    }
  }
}
