import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giphy_app/ui/gif_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import "dart:convert";
import 'dart:async';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api_key = "M8Bdnui1KM537i1W4Y1XKe1eT8dWQ6GX";
  String _search = "";
  int _offset = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise aqui!",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _searchGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                      break;
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGifTable(context, snapshot);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map> _searchGifs() async {
    String url = "";
    if (_search.isEmpty)
      url =
          "https://api.giphy.com/v1/gifs/trending?api_key=$_api_key&limit=25&rating=G";
    else
      url =
          "https://api.giphy.com/v1/gifs/search?api_key=$_api_key&q=$_search&limit=25&offset=$_offset&rating=G&lang=en";

    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  int _getCount(List data) {
    if (_search == "")
      return data.length;
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == "" || index < snapshot.data["data"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300.0,
                fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            },
            onLongPress: () {
              Share.share(
                  snapshot.data["data"][index]["images"]["original"]["url"]);
            },
          );

        return Container(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.white, size: 70.0),
                Text("Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0))
              ],
            ),
            onTap: () {
              setState(() {
                _offset += 19;
              });
            },
          ),
        );
      },
    );
  }
}
