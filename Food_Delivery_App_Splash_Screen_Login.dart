import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth Preferences Helper
class AuthPreferences {
  static const _isLog2gedInKey = 'isLog2gedIn';

  static Future<bool> isLog2gedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLog2gedInKey) ?? false;
  }

  static Future<void> setLog2gedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLog2gedInKey, value);
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      _routeToNextScreen();
    });
  }

  _routeToNextScreen() async {
    final isLog2gedIn = await AuthPreferences.isLog2gedIn();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        isLog2gedIn ? MyHomePage() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'MyKitchenApp',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';

  void _validate() {
    if (_formKey.currentState!.validate()) {
      message = 'Login successful';
      AuthPreferences.setLog2gedIn(true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyHomePage()),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login successful')));
      nameController.clear();
      passwordController.clear();
    } else {
      message = 'Kindly fill all details';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your full name',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validate,
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main App
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
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> food = ['Burger', 'Samosa', 'Sandwich', 'Kachori', 'Momos', 'Idly', 'Dosa'];
  List<int> price = [120, 25, 120, 25, 80, 60, 85];
  List<String> images = [
    'asset/images/Cheeseburger.jpg',
    'asset/images/Samosa.jpg',
    'asset/images/Sandwich.jpg',
    'asset/images/Kachori.jpg',
    'asset/images/Momos.jpg',
    'asset/images/Idli.JPG',
    'asset/images/Dosa.jpg'
  ];

  List<int> amount = [];
  Map<String, int> cart = {};
  int _currentIndex = 0;
  bool isDarkMode = false;

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

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
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
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: toggleTheme,
          ),
        ],
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
                  child: Image.asset(
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
                      child: Image.asset(
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
      ]
    ),
    );
  }
}

// === Main Entry Point ===
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}