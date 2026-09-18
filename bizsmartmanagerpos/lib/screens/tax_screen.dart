import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../core/app_constants.dart';

class TaxScreen extends StatelessWidget {
  const TaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KRA Tax')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tax Summary',
                        style: Theme.of(context).textTheme.titleLarge),
                    const Divider(),
                    _TaxRow('VAT Rate',
                        '${(AppConstants.vatRate * 100).toInt()}%'),
                    _TaxRow('Total VAT Collected', 'KSh 0.00'),
                    _TaxRow('Taxable Sales', 'KSh 0.00'),
                    _TaxRow('Net Sales', 'KSh 0.00'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download),
                label: const Text('Export iTax Report (PDF)'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.receipt_long),
                label: const Text('Generate ETR Receipt'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxRow extends StatelessWidget {
  final String label;
  final String value;
  const _TaxRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.greyText)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText)),
        ],
      ),
    );
  }
}