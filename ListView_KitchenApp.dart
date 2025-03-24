import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  createState() => MyState();
}

class MyState extends State<MyApp> {
  List food = ['Burger', 'Samosa', 'Sandwich', 'Kachori', 'Momos', 'Idly', 'Dosa'];
  List price = [120, 25, 120, 25, 80, 60, 85];
  Map<String, int> cart = {};

  void addToCart(int index) {
    setState(() {
      cart[food[index]] = (cart[food[index]] ?? 0) + 1;
    });
  }

  int getTotalPrice() {
    int total = 0;
    cart.forEach((key, value) {
      total += (price[food.indexOf(key)] * value);
    });
    return total;
  }

  void navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutPage(cart: cart, priceList: price, foodList: food)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Arial'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Kitchen', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: food.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.fastfood, color: Colors.white),
                  ),
                  title: Text(
                    food[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "₹${price[index]}",
                    style: TextStyle(fontSize: 16, color: Colors.green[700]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.orangeAccent, size: 30),
                    onPressed: () => addToCart(index),
                  ),
                  tileColor: Colors.orange[50],
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(15),
          color: Colors.orange[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: ₹${getTotalPrice()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: cart.isNotEmpty ? navigateToCheckout : null,
                child: Text("Checkout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<int> priceList;
  final List<String> foodList;

  CheckoutPage({required this.cart, required this.priceList, required this.foodList});

  @override
  Widget build(BuildContext context) {
    int totalPrice = cart.entries.fold(0, (sum, entry) => sum + (priceList[foodList.indexOf(entry.key)] * entry.value));

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cart.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("Quantity: ${entry.value}"),
                    trailing: Text("₹${priceList[foodList.indexOf(entry.key)] * entry.value}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Text("Total Price: ₹$totalPrice", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Confirm Order"),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            )
          ],
        ),
      ),
    );
  }
}