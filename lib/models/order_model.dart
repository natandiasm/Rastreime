import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel {
  static addOrder(
      {@required Map<String, dynamic> orderData,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    Firestore database = Firestore.instance;
    database.collection('orders').document()
    .setData(orderData)
    .catchError((e) {
      onFail();
    });
    onSucess();
  }
}
