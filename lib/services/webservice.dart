import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:montournoi_net_flutter/models/token.dart';

class Resource<T> {
  final String url;
  T Function(Response response) parse;
  Resource({required this.url, required this.parse});
}

class BodyResource<T> extends Resource<T>{
  final Object body;
  BodyResource({required url, required parse, required this.body}) : super(url: url, parse: parse);
}

class Webservice {

  Future<T> load<T>(Resource<T> resource) async {
    return loads(resource, null);
  }

  Future<T> loads<T>(Resource<T> resource, Token? token) async {
    var url = Uri.parse(resource.url);
    Map<String, String> headers = createHeaders(null);
    final response = await http.get(url, headers: headers);
    if(response.statusCode == 200) {
      return resource.parse(response);
    } else {
      throw Exception('Failed to load data!');
    }
  }
  Future<T> delete<T>(Resource<T> resource, Token? token) async {
    var url = Uri.parse(resource.url);
    Map<String, String> headers = createHeaders(token);
    final response = await http.delete(url, headers: headers,);
    if(validateResponse(response)) {
      return resource.parse(response);
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  Future<T> post<T>(BodyResource<T> resource, Token? token) async {
    var url = Uri.parse(resource.url);
    Map<String, String> headers = createHeaders(token);
    final response = await http.post(
        url,
        headers: headers,
        body: resource.body
    );
    if(validateResponse(response)) {
      return resource.parse(response);
    } else {
      throw Exception('Erreur ${response.statusCode}');
    }
  }

  bool validateResponse(http.Response response) => response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204 ;

  Map<String, String> createHeaders(Token? token) {
    var headers = null != token ? {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.token}',
    } : {
      "Content-Type": "application/json",
      'Accept': 'application/json',
    };
    return headers;
  }
}