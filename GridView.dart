import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(title: Text('MyKitchen')),
        body: GridView.Count(
          crossAxisCount:3,
          children: <Widget>[
            InkWell(
              onTapp:
              child:card(
            )
            )
    ]
    )
  }