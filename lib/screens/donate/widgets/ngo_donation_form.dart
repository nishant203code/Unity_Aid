import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../services/razorpay_payment_service.dart';
import '../../../widgets/theme/input_decoration.dart';
import '../../../widgets/theme/app_colors.dart';

class NGODonationForm extends StatefulWidget {
  const NGODonationForm({super.key});

  @override
  State<NGODonationForm> createState() => _NGODonationFormState();
}

class _NGODonationFormState extends State<NGODonationForm> {
  static const String _razorpayKey = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: '',
  );

  final RazorpayPaymentService _paymentService = RazorpayPaymentService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _selectedNgo;
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
    if (_selectedNgo == null || _selectedNgo!.isEmpty) {
      _showMessage('Please select an NGO first.', color: Colors.orange);
      return;
    }

    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showMessage('Please enter a valid donation amount.', color: Colors.orange);
      return;
    }

    final contact = _contactController.text.trim();
    final email = _emailController.text.trim();

    if (!RegExp(r'^\d{10}$').hasMatch(contact)) {
      _showMessage('Please enter a valid 10-digit phone number.', color: Colors.orange);
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
      title: 'UnityAid Donation',
      description: 'Donation to $_selectedNgo',
      contact: contact,
      email: email,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(18),
              decoration: AppInputDecoration.style("NGO Name"),
              initialValue: _selectedNgo,
              items: const [
                DropdownMenuItem(
                    value: "Helping Hands", child: Text("Helping Hands")),
                DropdownMenuItem(
                    value: "Care Foundation", child: Text("Care Foundation")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedNgo = value;
                });
              },
            )),
        const SizedBox(height: 16),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration.style("Amount"),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: AppInputDecoration.style("Phone Number"),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: AppInputDecoration.style("Email"),
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(18),
            decoration: AppInputDecoration.style("Gateway"),
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
