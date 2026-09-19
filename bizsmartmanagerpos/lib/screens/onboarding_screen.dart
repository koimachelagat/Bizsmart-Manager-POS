// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../core/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  // Tracks which step the user is on (0, 1, 2)
  int _currentStep = 0;

  // Page controller — animates between steps
  final PageController _pageController = PageController();

  // ── STEP 1: Business Info ──
  final _businessNameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _kraPinController = TextEditingController();
  final _mpesaController = TextEditingController();

  // ── STEP 2: Admin Account ──
  final _adminNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form keys — one per step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _isLoading = false;

  // Selected business type
  String _selectedBusinessType = 'Retail Shop';
  final List<String> _businessTypes = [
    'Retail Shop',
    'Supermarket',
    'Wholesale',
    'Restaurant / Café',
    'Pharmacy',
    'Electronics',
    'Clothing & Fashion',
    'Hardware',
    'Other',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _kraPinController.dispose();
    _mpesaController.dispose();
    _adminNameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Move to next step
  void _nextStep() {
    if (_currentStep == 0 && !_step1Key.currentState!.validate()) return;
    if (_currentStep == 1 && !_step2Key.currentState!.validate()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Move to previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Final submit — called on step 3
Future<void> _completeSetup() async {
    setState(() => _isLoading = true);

    // Simulate setup — will connect to Django later
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Save flag so splash never shows onboarding again
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setup_complete', true);

    // Also save business info locally for now
    await prefs.setString('business_name', _businessNameController.text);
    await prefs.setString('business_type', _selectedBusinessType);
    await prefs.setString('kra_pin', _kraPinController.text);
    await prefs.setString('mpesa_number', _mpesaController.text);

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Go to login after setup complete
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── TOP HEADER ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BizSmart Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Business Setup Wizard',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── STEP INDICATOR ──
                  Row(
                    children: [
                      _StepIndicator(
                        number: 1,
                        label: 'Business',
                        isActive: _currentStep == 0,
                        isCompleted: _currentStep > 0,
                      ),
                      _StepDivider(isCompleted: _currentStep > 0),
                      _StepIndicator(
                        number: 2,
                        label: 'Admin',
                        isActive: _currentStep == 1,
                        isCompleted: _currentStep > 1,
                      ),
                      _StepDivider(isCompleted: _currentStep > 1),
                      _StepIndicator(
                        number: 3,
                        label: 'Confirm',
                        isActive: _currentStep == 2,
                        isCompleted: false,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── PAGE CONTENT ──
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),  // Business Info
                  _buildStep2(),  // Admin Account
                  _buildStep3(),  // Confirmation
                ],
              ),
            ),

            // ── BOTTOM NAVIGATION ──
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceWhite,
                border: Border(
                  top: BorderSide(color: AppTheme.dividerGrey),
                ),
              ),
              child: Row(
                children: [
                  // Back button — hidden on step 1
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0)
                    const SizedBox(width: 16),

                  // Next / Finish button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _currentStep < 2
                              ? _nextStep
                              : _completeSetup,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _currentStep < 2
                                  ? 'Continue'
                                  : 'Complete Setup',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // STEP 1 — Business Information
  // ══════════════════════════════════════
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Tell us about your business',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This information will appear on your receipts and tax documents.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Business Name
            _FieldLabel('Business Name *'),
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Koima General Store',
                prefixIcon: Icon(Icons.store),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Business name is required' : null,
            ),
            const SizedBox(height: 20),

            // Business Type dropdown
            _FieldLabel('Business Type *'),
            DropdownButtonFormField<String>(
              value: _selectedBusinessType,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
              ),
              items: _businessTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedBusinessType = value!);
              },
            ),
            const SizedBox(height: 20),

            // KRA PIN
            _FieldLabel('KRA PIN *'),
            TextFormField(
              controller: _kraPinController,
              decoration: const InputDecoration(
                hintText: 'e.g. A012345678Z',
                prefixIcon: Icon(Icons.account_balance),
                helperText: 'Your KRA Personal Identification Number',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'KRA PIN is required';
                if (v.length < 11) return 'Enter a valid KRA PIN';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // M-Pesa Paybill / Till Number
            _FieldLabel('M-Pesa Paybill / Till Number'),
            TextFormField(
              controller: _mpesaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 174379',
                prefixIcon: Icon(Icons.phone_android),
                helperText: 'Optional — used for M-Pesa payments',
              ),
            ),
            const SizedBox(height: 24),

            // KRA note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppTheme.primaryBlue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your KRA PIN is used to generate ETR-compliant receipts and iTax reports.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // STEP 2 — Admin Account
  // ══════════════════════════════════════
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Create your admin account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This is the master account for your business. Keep your password safe.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Full Name
            _FieldLabel('Full Name *'),
            TextFormField(
              controller: _adminNameController,
              decoration: const InputDecoration(
                hintText: 'e.g. Koima Precious',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Full name is required' : null,
            ),
            const SizedBox(height: 20),

            // Email
            _FieldLabel('Email Address *'),
            TextFormField(
              controller: _adminEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'e.g. admin@mybusiness.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email is required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Password
            _FieldLabel('Password *'),
            TextFormField(
              controller: _adminPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                hintText: 'Minimum 8 characters',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Confirm Password
            _FieldLabel('Confirm Password *'),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Re-enter your password',
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Please confirm your password';
                }
                if (v != _adminPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Security note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accentGreen.withOpacity(0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security,
                      color: AppTheme.accentGreen, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Only admins can create cashier accounts. Cashiers cannot register themselves.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.accentGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // STEP 3 — Confirmation
  // ══════════════════════════════════════
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Confirm your details',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Please review everything before completing setup.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),

          // Business Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.store,
                          color: AppTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Text('Business Information',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const Divider(height: 24),
                  _ConfirmRow('Business Name',
                      _businessNameController.text.isEmpty
                          ? '—'
                          : _businessNameController.text),
                  _ConfirmRow('Business Type', _selectedBusinessType),
                  _ConfirmRow('KRA PIN',
                      _kraPinController.text.isEmpty
                          ? '—'
                          : _kraPinController.text),
                  _ConfirmRow(
                      'M-Pesa Number',
                      _mpesaController.text.isEmpty
                          ? 'Not provided'
                          : _mpesaController.text),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Admin Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.admin_panel_settings,
                          color: AppTheme.accentGreen),
                      const SizedBox(width: 8),
                      Text('Admin Account',
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const Divider(height: 24),
                  _ConfirmRow('Full Name',
                      _adminNameController.text.isEmpty
                          ? '—'
                          : _adminNameController.text),
                  _ConfirmRow('Email',
                      _adminEmailController.text.isEmpty
                          ? '—'
                          : _adminEmailController.text),
                  _ConfirmRow('Password', '••••••••'),
                  _ConfirmRow('Role', 'Administrator'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Final warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningAmber.withOpacity(0.3),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: AppTheme.warningAmber, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This setup runs only once. Make sure your KRA PIN and admin email are correct before proceeding.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════
// HELPER WIDGETS
// ══════════════════════════════════════

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.darkText,
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  const _ConfirmRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.greyText, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkText,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppTheme.successGreen
                : isActive
                    ? Colors.white
                    : Colors.white24,
            border: Border.all(
              color: isActive ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive
                          ? AppTheme.primaryBlue
                          : Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 11,
            fontWeight:
                isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  final bool isCompleted;
  const _StepDivider({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
        color: isCompleted ? AppTheme.successGreen : Colors.white24,
      ),
    );
  }
}