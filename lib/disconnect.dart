import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Disconnect extends StatelessWidget {
  const Disconnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DisconnectStful(),
    );
  }
}

class DisconnectStful extends StatefulWidget {
  const DisconnectStful({Key? key}) : super(key: key);

  @override
  _DisconnectStfulState createState() => _DisconnectStfulState();
}

bool _isLoading = false;

class _DisconnectStfulState extends State<DisconnectStful> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                http
                    .get(Uri.parse('http://192.168.100.100:222/closeMeet'))
                    .then((value) => Navigator.pop(context));
              },
              child: Text('Disconnect'),
            ),
    );
  }
}
