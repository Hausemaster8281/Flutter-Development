import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<MyApp> {
  List<String> items = ['Burger', 'Sandwich', 'Idly', 'Dosa', 'Uttapam', 'Butter Roll'];
  List<int> Qty = [0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(title: Text('MyKitchen')),
        body: Padding(
          padding: const EdgeInsets.all(10.0), // Padding around the ListView
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0), // Padding between list items
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow direction
                      ),
                    ],
                    border: Border.all(color: Colors.blueAccent, width: 1), // Border color
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15.0), // Padding inside the ListTile
                    title: Text(
                      '${items[index]}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Qty: ${Qty[index]}',
                          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
