import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Correios {
  final Dio _dio = Dio();
  final String _user = "undatustech@gmail.com";
  final String _token =
      "5f203d17761c187eff9410f23492083b7a1bad4f983de4b23f652a57eda8bc67";
  final RegExp _regexShippingCode = RegExp(r'[A-Z]{2}[0-9]{9}[A-Z]{2}');

  Future<dynamic> rastrear({@required String codigo}) async {
    try {
      Response response = await _dio.get(
          "https://api.linketrack.com/track/json?user=$_user&token=$_token&codigo=$codigo");
      return response.data;
    } catch (e) {
      return rastrear(codigo: codigo);
    }
  }

  bool isValidOrderCode(String text) {
    return _regexShippingCode.hasMatch(text);
  }
}
