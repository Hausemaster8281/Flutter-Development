import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mydb.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      password TEXT
    )
    ''');
  }

  Future<int> insertUser(String name, String password) async {
    final db = await instance.database;
    final data = {
      'name': name,
      'password': password,
    };

    // Print credentials to console
    print('Inserting user: $data');

    return await db.insert('users', data);
  }
}

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
  var nameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> myValidator() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final password = passwordController.text;

      try {
        await DBHelper.instance.insertUser(name, password);
        setState(() {
          message = 'Login successful and data saved';
        });
      } catch (e) {
        setState(() {
          message = 'Error saving data: $e';
        });
      }
    } else {
      setState(() {
        message = 'Kindly fill all details';
      });
    }

    nameController.clear();
    passwordController.clear();
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: nameController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                    suffixIcon: Icon(Icons.visibility_off, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: passwordController,
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