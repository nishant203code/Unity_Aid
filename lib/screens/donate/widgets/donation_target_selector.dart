import 'package:flutter/material.dart';
import 'ngo_donation_form.dart';
import 'case_donation_form.dart';
import '../../../widgets/theme/input_decoration.dart';

enum DonationTarget {
  ngo,
  caseTarget,
}

class DonationTargetSelector extends StatefulWidget {
  final String? prefilledCaseId;

  const DonationTargetSelector({
    super.key,
    this.prefilledCaseId,
  });

  @override
  State<DonationTargetSelector> createState() => _DonationTargetSelectorState();
}

class _DonationTargetSelectorState extends State<DonationTargetSelector> {
  DonationTarget selectedTarget = DonationTarget.ngo;
  final TextEditingController caseIdController = TextEditingController();
  @override
  void initState() {
    super.initState();

    if (widget.prefilledCaseId != null) {
      selectedTarget = DonationTarget.caseTarget;
      caseIdController.text = widget.prefilledCaseId!;
    } else {
      selectedTarget = DonationTarget.ngo;
    }
  }

  @override
  void didUpdateWidget(covariant DonationTargetSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(widget.prefilledCaseId);
    if (widget.prefilledCaseId != null &&
        widget.prefilledCaseId != oldWidget.prefilledCaseId) {
      setState(() {
        selectedTarget = DonationTarget.caseTarget; // or enum if you switched
        caseIdController.text = widget.prefilledCaseId!;
        // if implemented
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Donation Target",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButtonFormField<DonationTarget>(
              borderRadius: BorderRadius.circular(18),
              decoration: AppInputDecoration.style("Payment Type"),
              value: selectedTarget,
              items: const [
                DropdownMenuItem(value: DonationTarget.ngo, child: Text("NGO")),
                DropdownMenuItem(
                    value: DonationTarget.caseTarget,
                    child: Text("Incident / Case")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedTarget = value!;

                  if (value == DonationTarget.ngo) {
                    caseIdController.clear();
                  }
                });
              },
            )),
        const SizedBox(height: 20),
        if (selectedTarget == DonationTarget.ngo)
          const NGODonationForm()
        else
          CaseDonationForm(
            caseIdController: caseIdController,
          ),
      ],
    );
  }
}
