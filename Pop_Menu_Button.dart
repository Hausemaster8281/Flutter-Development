import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? val;
  List Formula=[{'Kilometer:1 }, {'Meter':1000}, {'Centimeter':100000},
  {'Meter':{'Kilometer'] //Formulae of unit conversion - TO-DO
  @override
  return MaterialApp(
      home:Scafflod(
  body:Center(
  child:PopupMenuButton(
  onSelect:(){},
  itemBuilder:(){
    return [
      PopupMenuItem(
    value:0,
    child:Text('Kilometer')
    ),
    PopupMenuItem(
  value:1,
  item:Text('Meter')
  ),
  PopupMenuItem(
  value:2,
  child:Text('Centimeter')
  )
    ]
  }
  )
  )
  )
      )
}