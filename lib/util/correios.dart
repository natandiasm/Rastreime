import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Correios {
  final Dio _dio = Dio();
  final String _user = "teste";
  final String _token =
      "1abcd00b2731640e886fb41a8a9671ad1434c599dbaa0a0de9a5aa619f29a83f";

  Future<dynamic> rastrear({@required String codigo}) async {
    Response response = await _dio.get(
        "https://api.linketrack.com/track/json?user=${_user}&token=${_token}&codigo=${codigo}");
    return response.data;
  }
}
