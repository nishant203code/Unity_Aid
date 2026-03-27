import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentService {
  final Razorpay _razorpay = Razorpay();

  void initialize({
    required Function(PaymentSuccessResponse response) onSuccess,
    required Function(PaymentFailureResponse response) onFailure,
    required Function(ExternalWalletResponse response) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout({
    required String keyId,
    required int amountInPaise,
    required String title,
    required String description,
    String? contact,
    String? email,
  }) {
    final options = {
      'key': keyId,
      'amount': amountInPaise,
      'name': title,
      'description': description,
      'prefill': {
        'contact': contact ?? '',
        'email': email ?? '',
      },
      'theme': {
        'color': '#2E7D32',
      },
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
