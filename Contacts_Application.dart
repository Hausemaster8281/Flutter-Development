import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import FFI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MaskeContactsApp());
}

class MaskeContactsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQL Contacts Application',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: ContactListPage(),
    );
  }
}

class Contact {
  final int? id;
  final String name;
  final String phone;

  Contact({this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone};
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late Database _database;
  List<Contact> _contacts = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'contacts.db');

    _database = await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            phone TEXT
          )
        ''');
      },
      version: 1,
    );
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    final List<Map<String, dynamic>> maps = await _database.query('contacts');
    setState(() {
      _contacts = List.generate(maps.length, (i) {
        return Contact(
          id: maps[i]['id'],
          name: maps[i]['name'],
          phone: maps[i]['phone'],
        );
      });
    });
  }

  Future<void> _addContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameController.text,
        phone: _phoneController.text,
      );

      await _database.insert('contacts', contact.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      _nameController.clear();
      _phoneController.clear();
      _fetchContacts();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maske Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Form
            Expanded(
              flex: 4,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                      value == null || value.isEmpty ? 'Enter a name' : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a phone number';
                        }
                        final phoneExp = RegExp(r'^\d+$');
                        if (!phoneExp.hasMatch(value)) {
                          return 'Numbers only';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _addContact,
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            // Right side: Contact List
            Expanded(
              flex: 6,
              child: _contacts.isEmpty
                  ? Center(child: Text('No contacts yet.'))
                  : ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}