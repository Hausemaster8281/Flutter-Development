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
  bool isDarkMode = false;

  void addToCart(int index) {
    setState(() {
      cart[food[index]] = (cart[food[index]] ?? 0) + 1;
    });
  }

  int getTotalPrice() {
    int total = 0;
    cart.forEach((key, value) {
      total += price[food.indexOf(key)] * value;
    });
    return total;
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
          decoration: BoxDecoration(
            color: Colors.orange[100],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: ₹${getTotalPrice()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: cart.isNotEmpty ? () => navigateToConfirmation(context) : null,
                child: Text("Proceed to Confirmation"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          widget.images[index],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      subtitle: Text("Quantity: ${entry.value}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹${widget.priceList[index] * entry.value}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
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
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
