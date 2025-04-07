import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "";
  Color backgroundColor = Colors.white;

  void addText() {
    setState(() {
      text = "Hello, Flutter!";
    });
  }

  void removeText() {
    setState(() {
      text = "";
    });
  }

  void changeBackground() {
    setState(() {
      backgroundColor = backgroundColor == Colors.white ? Colors.blueGrey : Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Assignment')),
        backgroundColor: backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              ElevatedButton(onPressed: addText, child: Text("Add Text")),
              ElevatedButton(onPressed: removeText, child: Text("Remove Text")),
              ElevatedButton(onPressed: changeBackground, child: Text("Change Background")),
            ],
          ),
        ),
      ),
    );
  }
}
