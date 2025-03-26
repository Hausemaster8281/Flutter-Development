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
  List<int> amount = List.filled(7, 0); // Initialize amount list with zeros

  void addToCart(int index) {
    setState(() {
      cart[food[index]] = (cart[food[index]] ?? 0) + 1;
      amount[index] += price[index]; // Update the amount for the item
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (cart[food[index]] != null && cart[food[index]]! > 0) {
        cart[food[index]] = cart[food[index]]! - 1;
        amount[index] -= price[index]; // Decrease the amount
        if (cart[food[index]] == 0) {
          cart.remove(food[index]);
        }
      }
    });
  }

  int getTotalPrice() {
    return cart.entries.fold(0, (sum, entry) => sum + (price[food.indexOf(entry.key)] * entry.value));
  }

  void navigateToConfirmation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfirmationPage(
          cart: Map.from(cart),
          priceList: price,
          foodList: food,
          images: images,
          updateCart: updateCart,
        ),
      ),
    );
  }

  void updateCart(Map<String, int> updatedCart) {
    setState(() {
      cart = Map.from(updatedCart);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('My Kitchen')),
        body: ListView.builder(
          itemCount: food.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Image.network(images[index], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(food[index]),
                subtitle: Text("₹${price[index]}"),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Qty: ${cart[food[index]] ?? 0}"),
                        SizedBox(width: 10),
                        Text("₹${amount[index]}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.orangeAccent),
                          onPressed: () => addToCart(index),
                        ),
                        SizedBox(width: 10),
                        Text("₹${amount[index]}"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: ₹${getTotalPrice()}"),
                ElevatedButton(
                  onPressed: cart.isNotEmpty ? () => navigateToConfirmation(context) : null,
                  child: Text("Proceed to Confirmation"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Confirmation Page
class ConfirmationPage extends StatefulWidget {
  final Map<String, int> cart;
  final List<int> priceList;
  final List<String> foodList;
  final List<String> images;
  final Function(Map<String, int>) updateCart;

  ConfirmationPage({
    required this.cart,
    required this.priceList,
    required this.foodList,
    required this.images,
    required this.updateCart,
  });

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late Map<String, int> cart;

  @override
  void initState() {
    super.initState();
    cart = Map.from(widget.cart);
  }

  void removeFromCart(String item) {
    setState(() {
      if (cart[item] != null && cart[item]! > 0) {
        cart[item] = cart[item]! - 1;
        if (cart[item] == 0) {
          cart.remove(item);
        }
      }
    });
    widget.updateCart(cart);
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = cart.entries.fold(0, (sum, entry) => sum + (widget.priceList[widget.foodList.indexOf(entry.key)] * entry.value));

    return Scaffold(
      appBar: AppBar(title: Text("Confirmation")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: cart.entries.map((entry) {
                  int index = widget.foodList.indexOf(entry.key);
                  return Card(
                    child: ListTile(
                      leading: Image.network(widget.images[index], width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(entry.key),
                      subtitle: Text("Quantity: ${entry.value}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("₹${widget.priceList[index] * entry.value}"),
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => removeFromCart(entry.key),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Text("Total Price: ₹$totalPrice", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Proceed to Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
