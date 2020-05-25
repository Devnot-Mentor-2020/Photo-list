import 'dart:convert';
import 'package:http/http.dart' as http;

class ConnectionOperation{
  String url;
  ConnectionOperation({this.url});

  Future<List> _fetchPhotos() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body) as List;
      //List<Object> photoList = decodedJson.map((j) => Object.fromJson(j)).toList();
      return null;
    }
    else {
      throw Exception("Connection Problem ${response.statusCode}");
    }
  }
}
