import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';

import 'disconnect.dart';

class JoinMeet extends StatelessWidget {
  const JoinMeet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff5faff),
      body: JoinMeetStful(),
    );
  }
}

class JoinMeetStful extends StatefulWidget {
  const JoinMeetStful({Key? key}) : super(key: key);

  @override
  _JoinMeetStfulState createState() => _JoinMeetStfulState();
}

final nameText = TextEditingController();
final linkText = TextEditingController();
final platformText = TextEditingController();
bool recordingButton = false;
bool loadingMeet = false;

class _JoinMeetStfulState extends State<JoinMeetStful> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bool mobileDevice = height > width;
    return loadingMeet
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
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
                            width:
                                height > width ? height * 0.045 : width * 0.03,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(32))),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: mobileDevice
                      ? EdgeInsets.symmetric(horizontal: width * 0.07)
                      : EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: height > width ? height * 0.11 : width * 0.06,
                      ),
                      textInputBox(
                          textAction: TextInputAction.next,
                          name: 'Name',
                          height: height,
                          width: width,
                          mobileDevice: mobileDevice,
                          nameText: nameText),
                      textInputBox(
                          textAction: TextInputAction.next,
                          name: 'Link',
                          height: height,
                          width: width,
                          mobileDevice: mobileDevice,
                          nameText: linkText),
                      textInputBox(
                          textAction: TextInputAction.done,
                          name: 'Platform',
                          height: height,
                          width: width,
                          mobileDevice: mobileDevice,
                          nameText: platformText),
                      Container(
                        // margin: EdgeInsets.all(height > width ? 10 : 0),
                        width: height > width ? width * 1 : width * 0.8,
                        height: height > width ? height * 0.08 : height * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 30,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.02))
                          ],
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.all(height > width ? 10 : 0),
                        width: height > width ? width * 1 : width * 0.8,
                        height: height > width ? height * 0.08 : height * 0.08,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Recording',
                                style: TextStyle(
                                  fontSize: height > width ? 24 : 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      recordingButton = !recordingButton;
                                    });
                                  },
                                  child: Image.asset(
                                    recordingButton
                                        ? 'assets/switchOn.png'
                                        : 'assets/switchOff.png',
                                    width: 45,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 30,
                                spreadRadius: 0,
                                color: Colors.black.withOpacity(0.02))
                          ],
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (nameText.text.isNotEmpty &&
                                linkText.text.isNotEmpty &&
                                platformText.text.isNotEmpty) {
                              setState(() {
                                loadingMeet = true;
                              });
                              String response = await makePostRequest(
                                  nameText.text,
                                  linkText.text,
                                  platformText.text,
                                  recordingButton);
                              print("Response==" + response);
                              if (response.substring(1, response.length - 1) ==
                                  "Received Response") {
                                // Navigator.push(
                                //     context,
                                //     new MaterialPageRoute(
                                //         builder: (context) => Disconnect()));
                                // Navigator.popAndPushNamed(context, "");
                                Navigator.pushReplacement(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => Disconnect()));
                              }
                            } else {
                              //TODO: toast
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.TOPSLIDE,
                                title: 'Please fill all details',
                                width: mobileDevice ? 400 : 600,
                                dialogBorderRadius: BorderRadius.circular(30),
                                // btnCancelOnPress: () {},
                                btnOkOnPress: () async {},
                              )..show();
                            }
                          },
                          child: Container(
                            // margin: EdgeInsets.all(height > width ? 10 : 0),
                            width: height > width ? width * 0.5 : width * 0.35,
                            height:
                                height > width ? height * 0.09 : height * 0.09,
                            child: Center(
                              child: Text(
                                'Join',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffFFB774),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 30,
                                    spreadRadius: 0,
                                    color: Colors.black.withOpacity(0.02))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}

class textInputBox extends StatelessWidget {
  const textInputBox({
    Key? key,
    required this.height,
    required this.width,
    required this.mobileDevice,
    required this.nameText,
    required this.name,
    required this.textAction,
  }) : super(key: key);
  final String name;
  final double height;
  final double width;
  final bool mobileDevice;
  final TextEditingController nameText;
  final TextInputAction textAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(height > width ? 0 : 0),
      width: height > width ? width * 1 : width * 0.8,
      height: height > width ? height * 0.17 : height * 0.15,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: mobileDevice
                  ? EdgeInsets.only(left: 40.0, top: 5)
                  : EdgeInsets.only(left: 80, top: 10),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: height > width ? 24 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: mobileDevice
                  ? EdgeInsets.only(left: 40.0, right: 40, bottom: 20)
                  : EdgeInsets.only(left: 80.0, right: 80, bottom: 20),
              child: TextFormField(
                controller: nameText,
                textInputAction: textAction,
                onFieldSubmitted: (text) {},
                style: TextStyle(
                  fontSize: mobileDevice ? 21 : 27,
                ),
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                // validator: (value) {
                //   if (value == "") {
                //     return 'Please enter some text';
                //   }
                //   return null;
                // },
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 30,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.02))
        ],
      ),
    );
  }
}

makePostRequest(
    String name, String link, String platform, bool recording) async {
  final uri = Uri.parse('http://192.168.100.100:222/startMeet');
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> body = {
    "name": name,
    "platform": platform,
    "link": link,
    "recording": recording.toString()
  };
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
  // print(responseBody);
  return responseBody;
}
