import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  CounterState createState() => CounterState();
}

class CounterState extends State<MyApp> {
  List<String> items = ['burger', 'sandwich', 'idly', 'dosa', 'uttapam', 'butter roll'];
  List<int> Qty = [0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(title: Text('MyKitchen')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                title: Text('${items[index]}'),
                trailing: Column(
                  children: [
                    Text('Qty: ${Qty[index]}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
