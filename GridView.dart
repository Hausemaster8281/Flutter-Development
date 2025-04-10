import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid_View_Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List to track the color state of each button
  List<Color> buttonColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  // Function to change color when a button is tapped
  void changeColor(int index) {
    setState(() {
      // Cycle through some colors when tapped
      if (buttonColors[index] == Colors.red) {
        buttonColors[index] = Colors.redAccent;
      } else if (buttonColors[index] == Colors.redAccent) {
        buttonColors[index] = Colors.red;
      } else if (buttonColors[index] == Colors.green) {
        buttonColors[index] = Colors.greenAccent;
      } else if (buttonColors[index] == Colors.greenAccent) {
        buttonColors[index] = Colors.green;
      } else if (buttonColors[index] == Colors.blue) {
        buttonColors[index] = Colors.blueAccent;
      } else if (buttonColors[index] == Colors.blueAccent) {
        buttonColors[index] = Colors.blue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('MyKitchen'),
      ),
      body: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.all(20.0),
        children: List.generate(3, (index) {
          return InkWell(
            onTap: () => changeColor(index),
            child: Card(
              color: buttonColors[index],
              elevation: 5.0,
              child: Center(
                child: Text(
                  'Button ${index + 1}',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}