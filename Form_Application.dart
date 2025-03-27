import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget
{
  @override
  createState()=>MyAppState();
}

class MyAppState extends State
{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
        appBar:AppBar(
          title:Text(
            'Login Form'
          )
        ),
        body:Form(
          child:ListView(
            children:[
              Container(
                  margin:EdgeInsets.all(25.0),
                child:TextFormField(
                  decoration:
                    InputDecoration(
                      labelText:'Username',
                      hintText:'Enter your full name'
                    )
                )
              ),
              Container(
                  margin:EdgeInsets.all(25.0),
                  child:TextFormField(
                      decoration:
                      InputDecoration(
                          labelText:'Passowrd',
                          hintText:'Enter your passowrd'
                      )
                  )
              ),
          Container(
              margin:EdgeInsets.all(25.0),
              child: ElevatedButton(
                child:Text('Login'),
                onPressed:() {}
              )
              )
            ]
          )
        )
      )
    );
  }
}