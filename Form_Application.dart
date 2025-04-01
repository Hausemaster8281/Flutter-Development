import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String message = '';
  var namecontroller=TextEditingController();
  var emailcontroller=TextEditingController();
  String? email;
  String? name;

  void myValidator() {
    name=namecontroller.text.toString();
    email=emailcontroller.text.toString();
    if (_formKey.currentState!.validate()) {
      setState(() {
        message = 'Login successful';
      });
    } else {
      setState(() {
        message = 'Kindly fill all details';
      });
    }
    namecontroller.clear();
    emailcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Login Form')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your full name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: namecontroller
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: emailcontroller
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: myValidator,
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
