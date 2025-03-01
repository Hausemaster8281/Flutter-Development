import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  @override
  createState() => CounterState();
}
class CounterState extends State{
  List items=['burger,'sandwitch','idly','dosa','uttapam','butter roll'];
  List Qty=[0,0,0,0,0,0];
  @override
  Widget build(BuildContext context{
    return Scaffold(
    Drawer:Drawer(),
    appBar:AppBar(
  title:Text('MyKitched')),
  body:ListView.builder(
  itemCount: items.length,
  itemBuilder:(
  BuildContext context
  ){
    return Container(child:ListTitle(
    title:Text('${
  items[index]
  }'),
  trailing:Column(Children:[Text('Qty: ${
  Qty[index]
  }')])
    ))
  }
  )
    )
  })
}