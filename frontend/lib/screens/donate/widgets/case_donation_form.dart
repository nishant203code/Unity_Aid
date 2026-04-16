import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../services/razorpay_payment_service.dart';
import '../../../widgets/theme/app_colors.dart';
import '../../../widgets/theme/input_decoration.dart';

// ── Hard-coded test key (replace with live key before production) ──
const String _kRazorpayTestKey = 'rzp_test_SeHcKLZ80m216X';

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
  final RazorpayPaymentService _paymentService = RazorpayPaymentService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool _isOpeningCheckout = false;

  // Quick-select amount chips
  static const List<int> _quickAmounts = [100, 500, 1000, 2500, 5000];
  int? _selectedQuickAmount;

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

  // ── Snackbar helper ──────────────────────────────────────────────────────
  void _showMessage(String message, {Color? color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Razorpay callbacks ───────────────────────────────────────────────────
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (mounted) setState(() => _isOpeningCheckout = false);
    _showSuccessDialog(
      paymentId: response.paymentId ?? 'N/A',
      orderId: response.orderId,
      signature: response.signature,
    );
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    if (mounted) setState(() => _isOpeningCheckout = false);
    _showMessage(
      'Payment failed: ${response.message ?? 'Unknown error'}',
      color: Colors.red,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) setState(() => _isOpeningCheckout = false);
    _showMessage(
      'External wallet selected: ${response.walletName ?? 'N/A'}',
      color: Colors.blue,
    );
  }

  // ── Validation & checkout ────────────────────────────────────────────────
  Future<void> _startPayment() async {
    final caseId = widget.caseIdController.text.trim();
    if (caseId.isEmpty) {
      _showMessage('Please enter a case ID.', color: Colors.orange);
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
      _showMessage('Razorpay is not supported on web.', color: Colors.orange);
      return;
    }

    setState(() => _isOpeningCheckout = true);

    _paymentService.openCheckout(
      keyId: _kRazorpayTestKey,
      amountInPaise: amount * 100,
      title: 'UnityAid – Case Donation',
      description: 'Donation for Case ID: $caseId',
      contact: contact,
      email: email,
    );
  }

  // ── Success dialog ───────────────────────────────────────────────────────
  void _showSuccessDialog({
    required String paymentId,
    String? orderId,
    String? signature,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 52),
            ),
            const SizedBox(height: 18),
            const Text('Payment Successful!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '₹${_amountController.text} donated to Case #${widget.caseIdController.text}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 16),
            _ReceiptTile(label: 'Payment ID', value: paymentId),
            if (orderId != null) _ReceiptTile(label: 'Order ID', value: orderId),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 8),
            Text('🙏 Thank you for your generosity!',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Case ID
        TextFormField(
          controller: widget.caseIdController,
          decoration: AppInputDecoration.style("Case ID"),
        ),
        const SizedBox(height: 12),

        const Text(
          "Handled by: Helping Hands NGO",
          style: TextStyle(color: AppColors.primary),
        ),

        const SizedBox(height: 16),
        const Text("Donation Progress",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: 0.6,
            minHeight: 10,
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 4),
        Text('60% funded',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),

        const SizedBox(height: 20),

        // Quick amount chips
        const Text("Quick Select Amount",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickAmounts.map((amt) {
            final selected = _selectedQuickAmount == amt;
            return GestureDetector(
              onTap: () => setState(() {
                _selectedQuickAmount = amt;
                _amountController.text = amt.toString();
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        selected ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  '₹$amt',
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Custom amount
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() => _selectedQuickAmount = null),
          decoration: AppInputDecoration.style("Or enter custom amount (₹)"),
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

        const SizedBox(height: 24),

        // Razorpay badge
        _RazorpayBadge(),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
            ),
            onPressed: _isOpeningCheckout ? null : _startPayment,
            icon: _isOpeningCheckout
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.volunteer_activism),
            label: Text(
              _isOpeningCheckout ? "Opening Razorpay…" : "Donate via Razorpay",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 13, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              'Secured with 256-bit SSL via Razorpay',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tiny Razorpay branding badge ───────────────────────────────────────────
class _RazorpayBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payment, size: 18, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            'Powered by Razorpay',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'TEST MODE',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Receipt row widget ─────────────────────────────────────────────────────
class _ReceiptTile extends StatelessWidget {
  final String label;
  final String value;
  const _ReceiptTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600)),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
