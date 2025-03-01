import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  Widget buils(BuildContext context){
    return MaterialApp(home:FirstPage()


    )
  }
}
class FirstPage extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(body:Center(
        child:ElevatedButton(onPressed:(){Navigator.push(
          context,MaterialPageRoute(
          builder:builder (context) => SecondPage()
        )
        )
        } ,child:Text('Go to next page')

        )
    ));
  }
}
class SecondPage extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold();
  }
}