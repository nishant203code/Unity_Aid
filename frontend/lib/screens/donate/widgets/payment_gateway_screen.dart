import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../widgets/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point – call this from your donate button
// ─────────────────────────────────────────────────────────────────────────────
Future<void> showPaymentGateway(
  BuildContext context, {
  required double amount,
  required String description,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PaymentGatewaySheet(
      amount: amount,
      description: description,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Main sheet widget
// ─────────────────────────────────────────────────────────────────────────────
class PaymentGatewaySheet extends StatefulWidget {
  final double amount;
  final String description;

  const PaymentGatewaySheet({
    super.key,
    required this.amount,
    required this.description,
  });

  @override
  State<PaymentGatewaySheet> createState() => _PaymentGatewaySheetState();
}

class _PaymentGatewaySheetState extends State<PaymentGatewaySheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _simulatePayment(String method) async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _processing = false);
    Navigator.pop(context);
    _showSuccessDialog(method);
  }

  void _showSuccessDialog(String method) {
    final txnId =
        'TXN${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(9999)}';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PaymentSuccessDialog(
        amount: widget.amount,
        method: method,
        txnId: txnId,
        description: widget.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Column(
          children: [
            // ── Drag handle ──
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // ── Header ──
            _GatewayHeader(amount: widget.amount, description: widget.description),

            // ── Tab Bar ──
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor:
                    isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                labelStyle: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 11),
                tabs: const [
                  Tab(text: 'UPI'),
                  Tab(text: 'Card'),
                  Tab(text: 'Net\nBank'),
                  Tab(text: 'Wallet'),
                ],
              ),
            ),

            // ── Tab views ──
            Expanded(
              child: _processing
                  ? const _ProcessingView()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _UpiTab(onPay: _simulatePayment),
                        _CardTab(onPay: _simulatePayment),
                        _NetBankingTab(onPay: _simulatePayment),
                        _WalletTab(onPay: _simulatePayment),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _GatewayHeader extends StatelessWidget {
  final double amount;
  final String description;

  const _GatewayHeader({required this.amount, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay Securely',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.lock_rounded,
                    color: AppColors.primary, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.volunteer_activism,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey.shade600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _SecurityBadge(label: '256-bit SSL'),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  final String label;
  const _SecurityBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade200),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user, size: 11, color: Colors.green.shade700),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Processing overlay
// ─────────────────────────────────────────────────────────────────────────────
class _ProcessingView extends StatelessWidget {
  const _ProcessingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 70,
          width: 70,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Processing Payment…',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Please do not press back',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Pay Button
// ─────────────────────────────────────────────────────────────────────────────
class _PayButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _PayButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        onPressed: onPressed,
        icon: const Icon(Icons.lock_rounded, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UPI Tab
// ─────────────────────────────────────────────────────────────────────────────
class _UpiTab extends StatefulWidget {
  final void Function(String method) onPay;
  const _UpiTab({required this.onPay});

  @override
  State<_UpiTab> createState() => _UpiTabState();
}

class _UpiTabState extends State<_UpiTab> {
  final _upiController = TextEditingController();
  String? _selectedApp;

  static const _upiApps = [
    _UpiApp('Google Pay', Icons.g_mobiledata, Color(0xFF4285F4)),
    _UpiApp('PhonePe', Icons.phone_android, Color(0xFF5F259F)),
    _UpiApp('Paytm', Icons.account_balance_wallet, Color(0xFF00BAF2)),
    _UpiApp('BHIM', Icons.account_balance, Color(0xFF003EA1)),
    _UpiApp('Amazon Pay', Icons.shopping_bag, Color(0xFFFF9900)),
    _UpiApp('WhatsApp Pay', Icons.chat, Color(0xFF25D366)),
  ];

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Quick UPI apps ──
          const Text('Pay with UPI App',
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: _upiApps.map((app) {
              final selected = _selectedApp == app.name;
              return GestureDetector(
                onTap: () => setState(() => _selectedApp = app.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? app.color.withOpacity(0.12)
                        : Colors.grey.shade50,
                    border: Border.all(
                      color: selected ? app.color : Colors.grey.shade200,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(app.icon, color: app.color, size: 30),
                      const SizedBox(height: 6),
                      Text(
                        app.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selected ? app.color : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const _Divider(label: 'OR ENTER UPI ID'),
          const SizedBox(height: 16),

          // ── Manual UPI ID ──
          TextField(
            controller: _upiController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'yourname@upi / yourname@bank',
              prefixIcon: const Icon(Icons.alternate_email,
                  color: AppColors.primary),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              suffixIcon: TextButton(
                onPressed: () {},
                child: const Text('VERIFY',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ),
          ),

          const SizedBox(height: 24),
          _PayButton(
            onPressed: () {
              final method = _selectedApp ??
                  (_upiController.text.isNotEmpty
                      ? 'UPI (${_upiController.text})'
                      : 'UPI');
              widget.onPay(method);
            },
            label: 'Pay via UPI',
          ),
          const SizedBox(height: 12),
          _UpiInfoRow(),
        ],
      ),
    );
  }
}

class _UpiInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          'Powered by NPCI BHIM UPI',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}

class _UpiApp {
  final String name;
  final IconData icon;
  final Color color;
  const _UpiApp(this.name, this.icon, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Tab
// ─────────────────────────────────────────────────────────────────────────────
class _CardTab extends StatefulWidget {
  final void Function(String method) onPay;
  const _CardTab({required this.onPay});

  @override
  State<_CardTab> createState() => _CardTabState();
}

class _CardTabState extends State<_CardTab> {
  final _cardNumber = TextEditingController();
  final _cardHolder = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  bool _saveCard = false;
  bool _isDebit = true;

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardHolder.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  String get _detectedNetwork {
    final n = _cardNumber.text.replaceAll(' ', '');
    if (n.startsWith('4')) return 'Visa';
    if (n.startsWith('5') || n.startsWith('2')) return 'Mastercard';
    if (n.startsWith('6')) return 'RuPay';
    if (n.startsWith('3')) return 'Amex';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card type toggle
          Row(
            children: [
              _TypeChip(
                label: 'Debit Card',
                selected: _isDebit,
                onTap: () => setState(() => _isDebit = true),
              ),
              const SizedBox(width: 10),
              _TypeChip(
                label: 'Credit Card',
                selected: !_isDebit,
                onTap: () => setState(() => _isDebit = false),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Card number
          TextField(
            controller: _cardNumber,
            keyboardType: TextInputType.number,
            maxLength: 19,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _CardNumberFormatter(),
            ],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              counterText: '',
              labelText: 'Card Number',
              prefixIcon:
                  const Icon(Icons.credit_card, color: AppColors.primary),
              suffixIcon: _detectedNetwork.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _detectedNetwork,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cardholder name
          TextField(
            controller: _cardHolder,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              prefixIcon:
                  const Icon(Icons.person, color: AppColors.primary),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Expiry
              Expanded(
                child: TextField(
                  controller: _expiry,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ExpiryFormatter(),
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'MM / YY',
                    prefixIcon: const Icon(Icons.calendar_today,
                        color: AppColors.primary, size: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // CVV
              Expanded(
                child: TextField(
                  controller: _cvv,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    labelText: 'CVV',
                    prefixIcon: const Icon(Icons.lock,
                        color: AppColors.primary, size: 18),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Save card
          Row(
            children: [
              Switch(
                value: _saveCard,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _saveCard = v),
              ),
              const SizedBox(width: 4),
              Text('Save card for future payments',
                  style: TextStyle(
                      color: Colors.grey.shade700, fontSize: 13)),
            ],
          ),

          const SizedBox(height: 20),
          _PayButton(
            onPressed: () => widget.onPay(
                _isDebit ? 'Debit Card' : 'Credit Card'),
            label: 'Pay Securely',
          ),
          const SizedBox(height: 14),
          _NetworkLogos(),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _NetworkLogos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.credit_card, size: 22, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text('Visa', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 12),
        Text('Mastercard', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 12),
        Text('RuPay', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 12),
        Text('Amex', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Net Banking Tab
// ─────────────────────────────────────────────────────────────────────────────
class _NetBankingTab extends StatefulWidget {
  final void Function(String method) onPay;
  const _NetBankingTab({required this.onPay});

  @override
  State<_NetBankingTab> createState() => _NetBankingTabState();
}

class _NetBankingTabState extends State<_NetBankingTab> {
  String? _selectedBank;

  static const _popularBanks = [
    _Bank('SBI', Icons.account_balance, Color(0xFF0B3D91)),
    _Bank('HDFC Bank', Icons.account_balance, Color(0xFF004C97)),
    _Bank('ICICI Bank', Icons.account_balance, Color(0xFFB01116)),
    _Bank('Axis Bank', Icons.account_balance, Color(0xFF97144D)),
    _Bank('Kotak Bank', Icons.account_balance, Color(0xFFEE3424)),
    _Bank('PNB', Icons.account_balance, Color(0xFF1E5C97)),
  ];

  static const _allBanks = [
    'Bank of Baroda', 'Bank of India', 'Canara Bank', 'Central Bank',
    'Federal Bank', 'IDBI Bank', 'Indian Bank', 'IndusInd Bank',
    'Karnataka Bank', 'RBL Bank', 'UCO Bank', 'Union Bank of India',
    'Yes Bank', 'South Indian Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Banks',
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: _popularBanks.map((bank) {
              final selected = _selectedBank == bank.name;
              return GestureDetector(
                onTap: () => setState(() => _selectedBank = bank.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: selected
                        ? bank.color.withOpacity(0.12)
                        : Colors.grey.shade50,
                    border: Border.all(
                      color: selected ? bank.color : Colors.grey.shade200,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(bank.icon, color: bank.color, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        bank.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selected ? bank.color : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const _Divider(label: 'ALL BANKS'),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _allBanks.contains(_selectedBank) ? _selectedBank : null,
            decoration: InputDecoration(
              hintText: 'Select your bank',
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            items: _allBanks
                .map((b) =>
                    DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) => setState(() => _selectedBank = v),
          ),

          const SizedBox(height: 24),
          _PayButton(
            onPressed: () =>
                widget.onPay('Net Banking (${_selectedBank ?? 'Bank'})'),
            label: 'Pay via Net Banking',
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('You will be redirected to your bank\'s portal',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500)),
          ),
        ],
      ),
    );
  }
}

class _Bank {
  final String name;
  final IconData icon;
  final Color color;
  const _Bank(this.name, this.icon, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Wallet Tab
// ─────────────────────────────────────────────────────────────────────────────
class _WalletTab extends StatefulWidget {
  final void Function(String method) onPay;
  const _WalletTab({required this.onPay});

  @override
  State<_WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<_WalletTab> {
  String? _selectedWallet;

  static const _wallets = [
    _WalletOption('Paytm', Icons.account_balance_wallet, Color(0xFF00BAF2)),
    _WalletOption('Amazon Pay', Icons.shopping_bag, Color(0xFFFF9900)),
    _WalletOption('Mobikwik', Icons.mobile_friendly, Color(0xFF6D1ED4)),
    _WalletOption('Freecharge', Icons.flash_on, Color(0xFF1EC28B)),
    _WalletOption('Ola Money', Icons.directions_car, Color(0xFF2F8C09)),
    _WalletOption('Jio Money', Icons.wifi, Color(0xFF0A57A5)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Wallet',
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),

          ..._wallets.map((wallet) {
            final selected = _selectedWallet == wallet.name;
            return GestureDetector(
              onTap: () => setState(() => _selectedWallet = wallet.name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? wallet.color.withOpacity(0.08)
                      : Colors.grey.shade50,
                  border: Border.all(
                    color: selected ? wallet.color : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: wallet.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(wallet.icon, color: wallet.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        wallet.name,
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 15,
                          color: selected
                              ? wallet.color
                              : null,
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(Icons.check_circle,
                          color: wallet.color, size: 22)
                    else
                      Icon(Icons.radio_button_unchecked,
                          color: Colors.grey.shade400, size: 22),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          _PayButton(
            onPressed: () =>
                widget.onPay('Wallet (${_selectedWallet ?? 'Wallet'})'),
            label: 'Pay via Wallet',
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Wallet balance will be deducted instantly',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletOption {
  final String name;
  final IconData icon;
  final Color color;
  const _WalletOption(this.name, this.icon, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Divider with label
// ─────────────────────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                letterSpacing: 0.8),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Formatters
// ─────────────────────────────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    final str = buf.toString();
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length <= 2) return newValue.copyWith(text: digits);
    final str = '${digits.substring(0, 2)}/${digits.substring(2)}';
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment Success Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentSuccessDialog extends StatelessWidget {
  final double amount;
  final String method;
  final String txnId;
  final String description;

  const _PaymentSuccessDialog({
    required this.amount,
    required this.method,
    required this.txnId,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 56,
              ),
            ),
            const SizedBox(height: 20),

            const Text('Payment Successful!',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Text(
              'Your donation of ₹${amount.toStringAsFixed(0)} has been received.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Details card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Amount', value: '₹${amount.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Method', value: method),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Towards', value: description),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Txn ID', value: txnId),
                  const SizedBox(height: 8),
                  _DetailRow(
                      label: 'Status',
                      value: 'SUCCESS',
                      valueColor: Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Done',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '🙏 Thank you for your generosity!',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label,
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12)),
        ),
        const Text(': ',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
