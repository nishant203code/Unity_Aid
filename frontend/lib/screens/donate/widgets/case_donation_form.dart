import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../services/razorpay_payment_service.dart';
import '../../../widgets/theme/app_colors.dart';
import '../../../widgets/theme/input_decoration.dart';

class CaseDonationForm extends StatefulWidget {
  final TextEditingController caseIdController;

  const CaseDonationForm({
    super.key,
    required this.caseIdController,
  });

  @override
  State<CaseDonationForm> createState() => _CaseDonationFormState();
}

class _CaseDonationFormState extends State<CaseDonationForm> {
  static const String _razorpayKey = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: '',
  );

  final RazorpayPaymentService _paymentService = RazorpayPaymentService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool _isOpeningCheckout = false;

  @override
  void initState() {
    super.initState();
    _paymentService.initialize(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onExternalWallet: _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  void _showMessage(String message, {Color? color}) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (mounted) {
      setState(() {
        _isOpeningCheckout = false;
      });
    }
    _showMessage(
      'Payment successful. ID: ${response.paymentId ?? 'N/A'}',
      color: Colors.green,
    );
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    if (mounted) {
      setState(() {
        _isOpeningCheckout = false;
      });
    }
    _showMessage(
      'Payment failed: ${response.message ?? 'Unknown error'}',
      color: Colors.red,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      setState(() {
        _isOpeningCheckout = false;
      });
    }
    _showMessage('External wallet selected: ${response.walletName ?? 'N/A'}');
  }

  Future<void> _startPayment() async {
    final caseId = widget.caseIdController.text.trim();
    if (caseId.isEmpty) {
      _showMessage('Please enter a case ID.', color: Colors.orange);
      return;
    }

    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid donation amount.',
          color: Colors.orange);
      return;
    }

    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();

    if (!RegExp(r'^\d{10}$').hasMatch(contact)) {
      _showMessage('Please enter a valid 10-digit phone number.',
          color: Colors.orange);
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Please enter a valid email address.', color: Colors.orange);
      return;
    }

    if (kIsWeb) {
      _showMessage(
        'Razorpay Flutter plugin is not supported on web in this setup.',
        color: Colors.orange,
      );
      return;
    }

    if (_razorpayKey.isEmpty) {
      _showMessage(
        'Razorpay key missing. Run with --dart-define=RAZORPAY_KEY_ID=your_test_key.',
        color: Colors.orange,
      );
      return;
    }

    if (mounted) {
      setState(() {
        _isOpeningCheckout = true;
      });
    }

    _paymentService.openCheckout(
      keyId: _razorpayKey,
      amountInPaise: amount * 100,
      title: 'UnityAid Case Donation',
      description: 'Donation for Case ID: $caseId',
      contact: contact,
      email: email,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.caseIdController,
          decoration: AppInputDecoration.style("Case ID", context: context),
        ),
        const SizedBox(height: 12),

        // Appears only if NGO is linked (mocked for now)
        const Text(
          "Handled by: Helping Hands NGO",
          style: TextStyle(color: AppColors.primary),
        ),

        const SizedBox(height: 16),

        const Text("Donation Progress",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),

        LinearProgressIndicator(
          value: 0.6,
          minHeight: 10,
          color: AppColors.primary,
          backgroundColor: Colors.grey.shade300,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration.style("Amount", context: context),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration:
              AppInputDecoration.style("Phone Number", context: context),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: AppInputDecoration.style("Email", context: context),
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).colorScheme.surface,
          ),
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(18),
            decoration: AppInputDecoration.style("Gateway", context: context),
            initialValue: 'Razorpay (Test Mode)',
            items: const [
              DropdownMenuItem(
                value: 'Razorpay (Test Mode)',
                child: Text('Razorpay (Test Mode)'),
              ),
            ],
            onChanged: (_) {},
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: 162,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            onPressed: _isOpeningCheckout ? null : _startPayment,
            child: Text(
              _isOpeningCheckout ? "Opening..." : "Donate",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
