import 'package:flutter/material.dart';
import 'dart:convert';
import 'model/photo.dart';
import 'package:http/http.dart' as http;
class PhotoListPage extends StatefulWidget {
  @override
  _PhotoListPageState createState() => _PhotoListPageState();
}

class _PhotoListPageState extends State<PhotoListPage> {
  String url = "https://jsonplaceholder.typicode.com/photos";

  Future<List<Photo>> _fetchPhotos() async {
    var response = await http.get(url);
    var decodedJson= jsonDecode(response.body) as List;
    List<Photo> photoList = decodedJson.map((j) => Photo.fromJson(j)).toList();
    return photoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Fetched Photos"),),
    body: FutureBuilder(future: _fetchPhotos(),//whatever returs from this function, will be avaliable inside photolist paremeter.
          builder: (context, AsyncSnapshot<List<Photo>> photoList) {
            if (photoList.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            }
            else{
              return ListView.builder(itemCount: photoList.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(photoList.data[index].url),),
                        title: Text(photoList.data[index].title,style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                    );
                  });
              /*return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: (context,index){
                return Text(photoList.data[index].title);
              });*/
            }
          }),

    );
  }
}
