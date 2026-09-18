// lib/screens/sales_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../core/app_constants.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // Cart items list
  final List<Map<String, dynamic>> _cartItems = [];
  double get _subtotal => _cartItems.fold(0, (sum, item) =>
      sum + (item['price'] * item['qty']));
  double get _vat => _subtotal * AppConstants.vatRate;
  double get _total => _subtotal + _vat;

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      final existing = _cartItems.indexWhere(
          (i) => i['id'] == product['id']);
      if (existing >= 0) {
        _cartItems[existing]['qty']++;
      } else {
        _cartItems.add({...product, 'qty': 1});
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() => _cartItems.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
      ),
      body: Row(
        children: [
          // ── LEFT: Product Grid ──
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: 0, // Will be populated from database
                    itemBuilder: (context, index) =>
                        const SizedBox(), // placeholder
                  ),
                ),
              ],
            ),
          ),

          // ── RIGHT: Cart ──
          Expanded(
            flex: 2,
            child: Container(
              color: AppTheme.surfaceWhite,
              child: Column(
                children: [
                  // Cart header
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: AppTheme.primaryBlue,
                    child: const Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Cart items
                  Expanded(
                    child: _cartItems.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: 48, color: AppTheme.greyText),
                                SizedBox(height: 8),
                                Text('Cart is empty',
                                    style:
                                        TextStyle(color: AppTheme.greyText)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final item = _cartItems[index];
                              return ListTile(
                                title: Text(item['name']),
                                subtitle: Text(
                                    'KSh ${item['price']} x ${item['qty']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: AppTheme.errorRed),
                                  onPressed: () => _removeFromCart(index),
                                ),
                              );
                            },
                          ),
                  ),

                  // Cart totals
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: AppTheme.dividerGrey)),
                    ),
                    child: Column(
                      children: [
                        _TotalRow('Subtotal',
                            'KSh ${_subtotal.toStringAsFixed(2)}'),
                        _TotalRow(
                            'VAT (16%)', 'KSh ${_vat.toStringAsFixed(2)}'),
                        const Divider(),
                        _TotalRow(
                          'TOTAL',
                          'KSh ${_total.toStringAsFixed(2)}',
                          bold: true,
                          color: AppTheme.primaryBlue,
                        ),
                        const SizedBox(height: 16),
                        // Checkout buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _cartItems.isEmpty ? null : () {},
                            icon: const Icon(Icons.phone_android),
                            label: const Text('Pay via M-Pesa'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.mpesaGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _cartItems.isEmpty ? null : () {},
                            icon: const Icon(Icons.money),
                            label: const Text('Pay Cash'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color color;

  const _TotalRow(this.label, this.value,
      {this.bold = false, this.color = AppTheme.darkText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
          Text(value,
              style: TextStyle(
                  fontWeight:
                      bold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
      ),
    );
  }
}