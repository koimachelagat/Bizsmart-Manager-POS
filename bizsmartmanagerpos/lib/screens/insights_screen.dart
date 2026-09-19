import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Insights',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Powered by AI & Machine Learning',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            _InsightCard(
              title: 'Sales Forecast',
              subtitle: 'Predicted sales for next 7 days',
              icon: Icons.trending_up,
              color: AppTheme.primaryBlue,
            ),
            _InsightCard(
              title: 'Stock Prediction',
              subtitle: 'Items likely to run out this week',
              icon: Icons.inventory,
              color: AppTheme.warningAmber,
            ),
            _InsightCard(
              title: 'Profit Trends',
              subtitle: 'Your profit pattern over time',
              icon: Icons.auto_graph,
              color: AppTheme.accentGreen,
            ),
            _InsightCard(
              title: 'Best Sellers',
              subtitle: 'Top performing products this month',
              icon: Icons.star,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _InsightCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: AppTheme.greyText),
        onTap: () {},
      ),
    );
  }
}