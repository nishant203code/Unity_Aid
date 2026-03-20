import 'package:flutter/material.dart';
import '../../../widgets/theme/input_decoration.dart';
import '../../../widgets/theme/app_colors.dart';

class NGODonationForm extends StatelessWidget {
  const NGODonationForm({super.key});

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
              items: const [
                DropdownMenuItem(
                    value: "Helping Hands", child: Text("Helping Hands")),
                DropdownMenuItem(
                    value: "Care Foundation", child: Text("Care Foundation")),
              ],
              onChanged: (_) {},
            )),
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
