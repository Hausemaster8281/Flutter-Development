import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  createState() => MyState();
}

class MyState extends State<MyApp> {
  List<String> food = ['Burger', 'Samosa', 'Sandwich', 'Kachori', 'Momos', 'Idly', 'Dosa'];
  List<int> price = [120, 25, 120, 25, 80, 60, 85];
  List<int> amount = List.filled(7, 0); // Initializing amount for each item as 0
  List<String> images = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Cheeseburger.jpg/640px-Cheeseburger.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Samosa-and-Chatni.jpg/280px-Samosa-and-Chatni.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Bologna_sandwich.jpg/250px-Bologna_sandwich.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Rajasthani_Raj_Kachori.jpg/250px-Rajasthani_Raj_Kachori.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Momo_nepal.jpg/220px-Momo_nepal.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Idli_Sambar.JPG/220px-Idli_Sambar.JPG",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9f/Dosa_at_Sri_Ganesha_Restauran%2C_Bangkok_%2844570742744%29.jpg/250px-Dosa_at_Sri_Ganesha_Restauran%2C_Bangkok_%2844570742744%29.jpg"
  ];

  Map<String, int> cart = {};
  bool isDarkMode = false;

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  void addToCart(int index) {
    setState(() {
      cart[food[index]] = (cart[food[index]] ?? 0) + 1;
      amount[index] += price[index]; // Updating the amount for each item
    });
  }

  int getTotalPrice() {
    return cart.entries.fold(0, (sum, entry) => sum + (price[food.indexOf(entry.key)] * entry.value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.orange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Kitchen', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.orange),
                child: Center(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: toggleDarkMode,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: food.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      images[index],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    food[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "₹${price[index]}",
                    style: TextStyle(fontSize: 16, color: Colors.green[700]),
                  ),
                  trailing: SizedBox(
                    width: 100, // Fixed width to avoid overflow
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // First Row: Headers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Qty", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text("Amt", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 5), // Spacing
                        // Second Row: Button & Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.add_circle, color: Colors.orangeAccent, size: 24),
                              onPressed: () => addToCart(index),
                            ),
                            Text("₹${amount[index]}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  tileColor: Colors.orange[50],
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: ₹${getTotalPrice()}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: cart.isNotEmpty ? () {} : null,
                  child: Text("Proceed to Checkout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
