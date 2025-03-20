import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: FirstPage()));
}

class FirstPage extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<FirstPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$counter', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  counter++;
                });
              },
              child: Text('Increment Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
