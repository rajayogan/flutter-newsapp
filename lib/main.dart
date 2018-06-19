import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://newsapi.org/v2/top-headlines?' +
      'sources=bbc-news&' +
      'apiKey=497e5bbd0aa042b6806fd86063d1aba6';
  List PostData;

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('News'),
        ),
        body: RefreshIndicator(
          child: new ListView.builder(
              itemCount: PostData == null ? 0 : PostData.length,
              itemBuilder: (BuildContext context, i) {
                return new Column(children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: new Card(
                      elevation: 7.0,
                      
                      child: new Column(
                        
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                             
                                  new Flexible(
                                        child: new Container(
                                          padding: const EdgeInsets.all(15.0),
                                        child: new Text(
                                      PostData[i]["title"],
                                      style: new TextStyle(fontSize: 17.0),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                  ),
                                  
                                  
                            ],
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: new Text(PostData[i]["description"]),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Padding(
                                child: new FlatButton(
                                  child: new Text('Read More'),
                                  onPressed: () {
                                    showData(PostData[i]);
                                  },
                                  textColor: Colors.blue,
                                ),

                                padding: const EdgeInsets.only(
                                    right: 25.0, bottom: 15.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
              }),
          onRefresh: getData,
        ));
  }

  Future<Null> getData() async {
    var resp = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    var extracteddata = JSON.decode(resp.body);
    setState(() {
      PostData = extracteddata["articles"];
      print('Refresh Complete');
    });
    
    // PostData = extracteddata["articles"];
    return null;
  }

  Future showData(singlePost) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text(
            singlePost["title"],
            style: new TextStyle(fontSize: 17.0),
          ),
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Text(singlePost["description"]),
            ),
            new Padding(
              padding: const EdgeInsets.all(15.0),
              child: new Text('Source:  ' + singlePost["author"]),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new SimpleDialogOption(
                  child: new Text(
                    'Alright',
                    style: new TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
