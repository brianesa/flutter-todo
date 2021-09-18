import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todo/networking/custom_exceptions.dart';

class ApiProvider {
  final String _baseUrl = "https://api-nodejs-todolist.herokuapp.com";
  static const auth = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MDU5ZjNiMGVlMGJmNTAwMTczMzMxYjEiLCJpYXQiOjE2MTY1MDc4NjV9.1lK6qmdulGwJ6btFZ8bFqr2Zsb8N83x6Ce6DQPnRQHw'
  };
  final Object _headers = {...auth, 'Content-Type': 'application/json'};

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: _headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var responseJson;
    try {
      final response =
          await http.post(_baseUrl + url, headers: _headers, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, dynamic body) async {
    var responseJson;
    try {
      final response =
          await http.put(_baseUrl + url, headers: _headers, body: body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var responseJson;
    try {
      final response = await http.delete(
        _baseUrl + url,
        headers: {...auth},
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
