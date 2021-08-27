import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Downloads extends StatelessWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5faff),
      body: DownloadsStful(),
    );
  }
}

class DownloadsStful extends StatefulWidget {
  const DownloadsStful({Key? key}) : super(key: key);

  @override
  _DownloadsStfulState createState() => _DownloadsStfulState();
}

Future getDownloadFiles() async {
  String _url = "http://192.168.100.100:222/download";

  String _items = "";
  await http.get(Uri.parse(_url)).then((value) {
    _items = value.body.toString();
  });

  return _items;
}

Future downloadThis(String name) async {
  String _url = "http://192.168.100.100:222/download/" + name;
  await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}

class _DownloadsStfulState extends State<DownloadsStful> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bool mobileDevice = height > width;
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                print('back button clicked!');
                Navigator.pop(context);
              },
              child: Container(
                width: height > width ? height * 0.11 : width * 0.06,
                height: height > width ? height * 0.11 : width * 0.06,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Image.asset(
                      'assets/back.png',
                      width: height > width ? height * 0.045 : width * 0.03,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(32))),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
              future: getDownloadFiles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List availableItems = snapshot.data
                      .toString()
                      .substring(1, snapshot.data.toString().length - 1)
                      .split(",");
                  return ListView.builder(
                    itemCount: availableItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          downloadThis(availableItems[index]
                              .toString()
                              .substring(1,
                                  availableItems[index].toString().length - 1));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          height: 71,
                          width: 50,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  height: 29,
                                  width: 77,
                                  child: Center(
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xff506CFF),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Image.asset(
                                    'assets/mkvIcon.png',
                                    width: 40,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Text(
                                      availableItems[index]
                                          .toString()
                                          .substring(
                                              1,
                                              availableItems[index]
                                                      .toString()
                                                      .length -
                                                  1),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'mkv',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                  color: Colors.black.withOpacity(0.02))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
    // return Container();
  }
}


// Text(availableItems[index].toString().substring(1, availableItems[index].toString().length - 1)),