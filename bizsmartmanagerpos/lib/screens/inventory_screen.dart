// lib/screens/inventory_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../core/app_constants.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {}, // barcode scanner
            tooltip: 'Scan Barcode',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatChip('Total Products', '0', AppTheme.primaryBlue),
                const SizedBox(width: 8),
                _StatChip('Low Stock', '0', AppTheme.warningAmber),
                const SizedBox(width: 8),
                _StatChip('Out of Stock', '0', AppTheme.errorRed),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Product list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 0, // populated from database
              itemBuilder: (context, index) => const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price (KSh)',
                prefixText: 'KSh ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save to database — wired up when database_service is ready
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 18)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppTheme.greyText)),
          ],
        ),
      ),
    );
  }
}