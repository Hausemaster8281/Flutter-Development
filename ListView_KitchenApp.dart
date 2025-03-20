import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  @override
  createState()=>MyState();
}
class MyState extends State{
  List food=['Burger','Saamosa','Sandwich','Kachori','Momos','Idly','Dosa'];
  List price=[120,25,120,25,80,60,85];
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
        appBar:AppBar(
          title:Text(
            'My Kitchen'
          )
        ),
        body:ListView.builder(
          itemCount:food.length,
          itemBuilder:(context,index){
            return Container(
              height:200,
              decoration:BoxDecoration(
                  border:Border.all(
                      width:3,
                      color:Colors.black
                  ),
                color:Colors.orange
              ),
              child:ListTile(
                leading:Icon(
                  Icons.fastfood
                ),
                title:Text(
                    '${food[index]}'
                ),
                subtitle:Text(
                    '${price[index]}'
                ),
                trailing:Icon(Icons.add)
              )
            );
          }
        )
      )
    );
  }
}