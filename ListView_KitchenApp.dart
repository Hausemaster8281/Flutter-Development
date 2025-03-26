import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
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
      home: FoodOrderingApp(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class FoodOrderingApp extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const FoodOrderingApp({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode
  }) : super(key: key);

  @override
  _FoodOrderingAppState createState() => _FoodOrderingAppState();
}

class _FoodOrderingAppState extends State<FoodOrderingApp> {
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

  List<int> amount = [];
  Map<String, int> cart = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    amount = List.filled(food.length, 0);
  }

  void addToCart(int index) {
    setState(() {
      cart[food[index]] = (cart[food[index]] ?? 0) + 1;
      amount[index] += price[index];
    });
  }

  int getTotalPrice() {
    return cart.entries.fold(0, (sum, entry) =>
    sum + (price[food.indexOf(entry.key)] * entry.value));
  }

  void updateCart(Map<String, int> updatedCart) {
    setState(() {
      cart = Map.from(updatedCart);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define pages for bottom navigation
    final List<Widget> _pages = [
      // Home Page (Menu)
      HomePage(
        food: food,
        price: price,
        images: images,
        cart: cart,
        addToCart: addToCart,
        getTotalPrice: getTotalPrice,
      ),

      // Cart Page
      CartPage(
        cart: cart,
        food: food,
        price: price,
        images: images,
        updateCart: updateCart,
      ),

      // Checkout Page
      CheckoutPage(
        cart: cart,
        food: food,
        price: price,
        images: images,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Kitchen', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                'My Kitchen',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Mode'),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (_) => widget.toggleTheme(),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('${cart.length}'),
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.payment),
            label: 'Checkout',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> food;
  final List<int> price;
  final List<String> images;
  final Map<String, int> cart;
  final Function(int) addToCart;
  final Function getTotalPrice;

  const HomePage({
    Key? key,
    required this.food,
    required this.price,
    required this.images,
    required this.cart,
    required this.addToCart,
    required this.getTotalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: food.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                trailing: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Amount: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]
                                    ),
                                  ),
                                  Text(
                                    "₹${(cart[food[index]] ?? 0) * price[index]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800]
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Quantity: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]
                                    ),
                                  ),
                                  Text(
                                    "${cart[food[index]] ?? 0}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.orangeAccent, size: 35),
                        onPressed: () => addToCart(index),
                      ),
                    ],
                  ),
                ),
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            );
          },
        );
      },
    );
  }
}

class CartPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<String> food;
  final List<int> price;
  final List<String> images;
  final Function(Map<String, int>) updateCart;

  const CartPage({
    Key? key,
    required this.cart,
    required this.food,
    required this.price,
    required this.images,
    required this.updateCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPrice = cart.entries.fold(0, (sum, entry) =>
    sum + (price[food.indexOf(entry.key)] * entry.value));

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('Your cart is empty', style: TextStyle(fontSize: 18)))
                : ListView(
              children: cart.entries.map((entry) {
                int index = food.indexOf(entry.key);
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    title: Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text("Quantity: ${entry.value}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "₹${price[index] * entry.value}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            Map<String, int> updatedCart = Map.from(cart);
                            if (updatedCart[entry.key]! > 1) {
                              updatedCart[entry.key] = updatedCart[entry.key]! - 1;
                            } else {
                              updatedCart.remove(entry.key);
                            }
                            updateCart(updatedCart);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Text(
              "Total Price: ₹$totalPrice",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary
              )
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final Map<String, int> cart;
  final List<String> food;
  final List<int> price;
  final List<String> images;

  const CheckoutPage({
    Key? key,
    required this.cart,
    required this.food,
    required this.price,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPrice = cart.entries.fold(0, (sum, entry) =>
    sum + (price[food.indexOf(entry.key)] * entry.value));

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Checkout',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('No items to checkout', style: TextStyle(fontSize: 18)))
                : ListView(
              children: cart.entries.map((entry) {
                int index = food.indexOf(entry.key);
                return Card(
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text('Quantity: ${entry.value}'),
                    trailing: Text(
                      '₹${price[index] * entry.value}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Text(
            'Total: ₹$totalPrice',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: cart.isNotEmpty ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order Placed Successfully!')),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Place Order',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}