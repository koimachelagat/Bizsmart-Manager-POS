// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../core/app_routes.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // User info + logout
          PopupMenuButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.userName ?? 'User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkText,
                      ),
                    ),
                    Text(
                      auth.userRole ?? '',
                      style: const TextStyle(
                        color: AppTheme.greyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: AppTheme.errorRed, size: 18),
                    SizedBox(width: 8),
                    Text('Logout',
                        style: TextStyle(color: AppTheme.errorRed)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── GREETING ──
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              auth.userName ?? 'User',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // ── SUMMARY CARDS ──
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: "Today's Sales",
                    value: 'KSh 0.00',
                    icon: Icons.trending_up,
                    color: AppTheme.accentGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: 'Transactions',
                    value: '0',
                    icon: Icons.receipt_long,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Low Stock',
                    value: '0 items',
                    icon: Icons.warning_amber_rounded,
                    color: AppTheme.warningAmber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    title: "Today's VAT",
                    value: 'KSh 0.00',
                    icon: Icons.account_balance,
                    color: AppTheme.errorRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── MENU GRID ──
            Text(
              'Quick Access',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _MenuCard(
                  title: 'Sales',
                  icon: Icons.point_of_sale,
                  color: AppTheme.primaryBlue,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.sales),
                ),
                _MenuCard(
                  title: 'Inventory',
                  icon: Icons.inventory_2,
                  color: AppTheme.accentGreen,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.inventory),
                ),
                _MenuCard(
                  title: 'Reports',
                  icon: Icons.bar_chart,
                  color: AppTheme.lightBlue,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.reports),
                ),
                _MenuCard(
                  title: 'Expenses',
                  icon: Icons.money_off,
                  color: AppTheme.warningAmber,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.expenses),
                ),
                _MenuCard(
                  title: 'Receipts',
                  icon: Icons.receipt,
                  color: AppTheme.successGreen,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.receipts),
                ),
                _MenuCard(
                  title: 'Tax / KRA',
                  icon: Icons.account_balance_outlined,
                  color: AppTheme.errorRed,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.tax),
                ),
                _MenuCard(
                  title: 'AI Insights',
                  icon: Icons.auto_graph,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.insights),
                ),
                // Admin only
                if (auth.isAdmin)
                  _MenuCard(
                    title: 'Settings',
                    icon: Icons.settings,
                    color: AppTheme.greyText,
                    onTap: () {},
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── SUMMARY CARD WIDGET ──
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
            Text(title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.greyText,
                )),
          ],
        ),
      ),
    );
  }
}

// ── MENU CARD WIDGET ──
class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}