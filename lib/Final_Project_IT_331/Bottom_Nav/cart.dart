import 'package:flutter/material.dart';
import 'package:TeaMax/Final_Project_IT_331/colors.dart';

class CartTab extends StatefulWidget {
  final Map<String, Map<String, dynamic>> cart;

  const CartTab({super.key, required this.cart});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  void _increment(String name) {
    setState(() {
      widget.cart[name]!['quantity']++;
    });
  }

  void _decrement(String name) {
    setState(() {
      if (widget.cart[name]!['quantity'] > 1) {
        widget.cart[name]!['quantity']--;
      } else {
        widget.cart.remove(name);
      }
    });
  }

  int _calculateTotal() {
    return widget.cart.values.fold(0, (sum, item) {
      final price = int.tryParse(item['price'].toString()) ?? 0;
      return sum + price * (item['quantity'] as int);
    });
  }

  Widget _buildImageWithPlaceholder(dynamic image) {
    return image is String
        ? Image.asset(image, width: 50, height: 50, fit: BoxFit.cover)
        : const Icon(Icons.image, size: 50);
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final total = _calculateTotal();

    if (cart.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: cart.entries.map((entry) {
              final name = entry.key;
              final item = entry.value;
              return Dismissible(
                key: Key(name),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => setState(() => cart.remove(name)),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: _buildImageWithPlaceholder(item['image']),
                  title: Text(name),
                  subtitle: Text('₱${item['price']} x ${item['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrement(name),
                      ),
                      Text('${item['quantity']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _increment(name),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: ₱$total',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  final method = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text('Select Payment Method'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, 'Cash'),
                            child: const Text('Through Cash Payment'),
                          ),
                          SimpleDialogOption(
                            onPressed: () => Navigator.pop(context, 'Online'),
                            child: const Text('Through Online Payment'),
                          ),
                        ],
                      );
                    },
                  );

                  if (method != null) {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Payment'),
                          content: Text('Proceed with $method payment?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Confirm'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed ?? false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(method == 'Cash'
                              ? 'Please pay at the counter.'
                              : 'Payment successful!'),
                          backgroundColor: teaMaxBrown,
                        ),
                      );
                      setState(() => cart.clear());
                    }
                  }
                },
                child: const Text('Pay'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
