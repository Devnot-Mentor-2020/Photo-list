import 'package:flutter/material.dart';
import 'dart:convert';
import 'model/photo.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PhotoListPage extends StatefulWidget {
  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  String _url = "https://jsonplaceholder.typicode.com/photos";

  Future<List<Photo>> _fetchPhotos() async {
    var response = await http.get(_url);
    if(response.statusCode==HttpStatus.ok){
      var decodedJson= jsonDecode(response.body) as List;
      List<Photo> photoList = decodedJson.map((jsonMap) => Photo.fromJson(jsonMap)).toList();
      return photoList;
    }
    else{
      throw Exception("Connection Problem ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fetched Photos"),),
    body: buildFutureBuilder(),
    );
  }

  FutureBuilder<List<Photo>> buildFutureBuilder() {
    return FutureBuilder(future: _fetchPhotos(),//whatever returs from this function, will be avaliable inside snapshot paremeter.
        builder: (context, AsyncSnapshot<List<Photo>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:{
               return Center(child: CircularProgressIndicator(),) ;
            }
            case ConnectionState.done:{
              if(snapshot.hasData){
                return photoListView(snapshot);
              }
              break;
            }
            default:{
              break;
            }
          }
        });
  }

  ListView photoListView(AsyncSnapshot<List<Photo>> snapshot) {
    return ListView.builder(itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data[index].url),),
              title: Text(snapshot.data[index].title,style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          );
        });
  }
}
