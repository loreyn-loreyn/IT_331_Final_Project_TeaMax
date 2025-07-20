// === Import Statements ===
import 'package:flutter/material.dart';
import 'package:TeaMax/Final_Project_IT_331/Bottom_Nav/cart.dart';
import 'package:TeaMax/Final_Project_IT_331/colors.dart';

// === Shop Tab ===
class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final List<Map<String, String>> pastriesItems = const [
    {'name': 'Pie', 'image': 'assets/pie.jpg', 'price': '50'},
    {'name': 'Croissant', 'image': 'assets/croissant.jpg', 'price': '40'},
    {'name': 'Tart', 'image': 'assets/tart.jpg', 'price': '40'},
  ];

  final List<Map<String, String>> drinksItems = const [
    {'name': 'Mango Milkshake', 'image': 'assets/coffee1.jpeg', 'price': '100'},
    {'name': 'Kitkat Milkshake', 'image': 'assets/coffee2.jpeg', 'price': '70'},
    {'name': 'Nutella', 'image': 'assets/coffee3.jpeg', 'price': '60'},
    {'name': 'Oreo in a Cup', 'image': 'assets/coffee4.jpeg', 'price': '100'},
    {'name': 'Coffee 5', 'image': 'assets/coffee5.jpeg', 'price': '70'},
    {'name': 'Coffee 6', 'image': 'assets/coffee6.jpeg', 'price': '60'},
    {'name': 'Coffee 7', 'image': 'assets/coffee7.jpeg', 'price': '100'},
    {'name': 'Coffee 8', 'image': 'assets/coffee8.jpeg', 'price': '70'},
    {'name': 'Coffee 9', 'image': 'assets/coffee9.jpeg', 'price': '60'},
    {'name': 'Coffee 10', 'image': 'assets/coffee10.jpeg', 'price': '100'},
  ];

  static final Map<String, Map<String, dynamic>> cart = {};

  void _addToCart(Map<String, String> item) {
    setState(() {
      if (cart.containsKey(item['name'])) {
        cart[item['name']]!['quantity']++;
      } else {
        cart[item['name']!] = {
          'image': item['image'],
          'price': item['price'],
          'quantity': 1,
        };
      }
    });
  }

  void _navigateToDetail(BuildContext context, Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MenuItemDetailScreen(item: item, onAdd: _addToCart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: mutedTerracotta,
            tabs: [
              Tab(icon: Icon(Icons.local_drink), text: 'Drinks'),
              Tab(icon: Icon(Icons.shopping_basket), text: 'Pastries'),
              Tab(icon: Icon(Icons.shopping_cart), text: 'Cart'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList(drinksItems),
                _buildList(pastriesItems),
                CartTab(cart: cart),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<Map<String, String>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMenuItemCard(items[index]),
    );
  }

  Widget _buildMenuItemCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildImageWithPlaceholder(item['image']!),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name']!,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown)),
                  const SizedBox(height: 8.0),
                  Text('\₱${item['price']}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.green)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _navigateToDetail(context, item),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithPlaceholder(String imagePath) {
    return Image.asset(
      imagePath,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }
}

class MenuItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  final void Function(Map<String, String>) onAdd;

  const MenuItemDetailScreen({
    super.key,
    required this.item,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['name']!), backgroundColor: teaMaxBrown),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(child: Image.asset(item['image']!, width: 200, height: 200)),
            const SizedBox(height: 16.0),
            Text(item['name']!,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text('₱${item['price']}',
                style: const TextStyle(fontSize: 20, color: Colors.green)),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                onAdd({
                  'name': item['name']!,
                  'image': item['image']!,
                  'price': item['price']!,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item['name']} added to cart!'),
                    backgroundColor: teaMaxBrown,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
