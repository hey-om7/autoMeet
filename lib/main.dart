import 'package:auto_meet/disconnect.dart';
import 'package:auto_meet/downloads.dart';
import 'package:auto_meet/meetJoin.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff506CFF),
        body: AutoMeet(),
      ),
    );
  }
}

makePostRequest() async {
  final uri = Uri.parse('http://192.168.100.100:121/courses');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {'id': '21', 'name': 'bob'};
  String jsonBody = json.encode(body);
  final encoding = Encoding.getByName('utf-8');

  Response response = await post(
    uri,
    headers: headers,
    body: jsonBody,
    encoding: encoding,
  );
  int statusCode = response.statusCode;
  String responseBody = response.body;
  print(responseBody);
}

class AutoMeet extends StatefulWidget {
  const AutoMeet({Key? key}) : super(key: key);

  @override
  _AutoMeetState createState() => _AutoMeetState();
}

class _AutoMeetState extends State<AutoMeet> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                print('downloads clicked!');
                // String _url = "http://192.168.100.100:222/download/video.mkv";
                // await canLaunch(_url)
                //     ? await launch(_url)
                //     : throw 'Could not launch $_url';
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => Downloads(),
                  ),
                );
              },
              child: Container(
                width: height > width ? height * 0.11 : width * 0.07,
                height: height > width ? height * 0.11 : width * 0.07,
                child: Center(
                  child: Image.asset(
                    'assets/download.png',
                    width: height > width ? height * 0.065 : width * 0.04,
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(32))),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: height > width ? height * 0.1 : height * 0.05,
              ),
              Image.asset(
                'assets/vector.png',
                width: height > width ? width * 0.7 : height * 0.45,
                height: height > width ? width * 0.7 : height * 0.45,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(height > width ? 20 : 10),
            width: height > width ? width * 1 : width * 0.5,
            height: height * 0.40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(33),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Start a new',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height > width ? 32 : 50,
                      ),
                    ),
                    Text(
                      'meeting?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: height > width ? 32 : 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      print('get started pressed');
                      http
                          .get(Uri.parse(
                              'http://192.168.100.100:222/isMeetingAlive'))
                          .then((value) {
                        if (value.body.substring(1, value.body.length - 1) ==
                            "true") {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => Disconnect(),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => JoinMeet(),
                            ),
                          );
                        }
                      });
                    },
                    child: Container(
                      height: height > width ? height * 0.1 : height * 0.1,
                      width: height > width ? width * 0.5 : width * 0.2,
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height > width ? 23 : 30,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff68CFEC),
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
