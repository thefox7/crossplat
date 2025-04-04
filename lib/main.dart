import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assignment',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
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
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              child: Text("About Page"),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopping List App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Shopping List App helps users easily create, manage, and organize their shopping lists. '
                  'With an intuitive interface, users can add, edit, and check off items, ensuring a smooth shopping experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Credits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by Maksat, Alan and Kuanysh in the scope of the course “Crossplatform Development” '
                  'at Astana IT University.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
