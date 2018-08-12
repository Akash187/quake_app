import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async{
  Map _data = await getJson();
  List _features = _data['features'];
  String quakeTime(int timestamp){
    return new DateFormat.yMMMMd("en_US").add_jm().format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Quakes"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: new Center(
          child: new ListView.builder(
            itemCount: _features.length,
            //padding: const EdgeInsets.symmetric(horizontal: 24.5),
            itemBuilder: (BuildContext context, int index) {

              int timeStamp = _features[index]['properties']['time'];
              String place = _features[index]['properties']['place'];
              double magnitude = _features[index]['properties']['mag'] + 0.0;

              Color magColor(double mag){
                if(mag < 2.5) {
                  return Colors.lightBlueAccent;
                }else if(mag < 5.5){
                  return Colors.greenAccent;
                }else if(mag < 6.1){
                  return Colors.yellow;
                }else if(mag < 7.0){
                  return Colors.orangeAccent;
                }else if(mag < 8.0){
                  return Colors.redAccent;
                }else{
                  return Colors.red;
                }
              }

              return new Column(
                children: <Widget>[
                  new Divider(
                    height: 5.5,
                  ),
                  new Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: new ListTile(
                      title: Text(
                        "${quakeTime(timeStamp)}",
                        style: TextStyle(fontSize: 17.9),
                      ),
                      subtitle: Text(
                        "$place",
                        style: TextStyle(
                            fontSize: 13.9,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                      leading: new CircleAvatar(
                        backgroundColor: magColor(magnitude),
                        child: Text("$magnitude".toUpperCase()),
                      ),
                      onTap: () => showTapMessage(context, [magnitude, place]),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

void showTapMessage(BuildContext context, List message){
  var alert = new AlertDialog(
    title: Text("My App"),
    content: Text("M ${message[0]} - ${message[1]}"),
    actions: <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: (){
          Navigator.pop(context);
        },
      )
    ],
  );
  // showDialog(context: context, child: alert);
  showDialog(
      context: context,
      builder: (context) => alert
  );
}

Future<Map> getJson() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}

