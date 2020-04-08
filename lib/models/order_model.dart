import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class orderModel {
  static addOrder({@required idUser, @required Map<String, dynamic> orderData}) {
    Firestore database = Firestore.instance;

    database.collection('orders').document(idUser).setData(orderData);
  }
}
