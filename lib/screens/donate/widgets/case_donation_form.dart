import 'package:flutter/material.dart';
import '../../../widgets/theme/app_colors.dart';
import '../../../widgets/theme/input_decoration.dart';

class CaseDonationForm extends StatelessWidget {
  final TextEditingController caseIdController;

  const CaseDonationForm({
    super.key,
    required this.caseIdController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: caseIdController,
          decoration: AppInputDecoration.style("Case ID"),
        ),
        const SizedBox(height: 12),

        // Appears only if NGO is linked (mocked for now)
        Text(
          "Handled by: Helping Hands NGO",
          style: TextStyle(color: AppColors.primary),
        ),

        const SizedBox(height: 16),

        Text("Donation Progress",
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
          keyboardType: TextInputType.number,
          decoration: AppInputDecoration.style("Amount"),
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: DropdownButtonFormField<String>(
            borderRadius: BorderRadius.circular(18),
            decoration: AppInputDecoration.style("Payment Type"),
            items: const [
              DropdownMenuItem(value: "UPI", child: Text("UPI")),
              DropdownMenuItem(
                  value: "Credit Card", child: Text("Credit Card")),
              DropdownMenuItem(value: "Debit Card", child: Text("Debit Card")),
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
            onPressed: () {},
            child: const Text(
              "Donate",
              style: TextStyle(
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
