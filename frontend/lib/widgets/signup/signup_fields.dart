import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper function to validate if user is 18 or older
bool isUserAtLeast18(DateTime? dateOfBirth) {
  if (dateOfBirth == null) return false;
  final today = DateTime.now();
  final age = today.year - dateOfBirth.year;
  final hasHadBirthday = today.month > dateOfBirth.month ||
      (today.month == dateOfBirth.month && today.day >= dateOfBirth.day);
  return hasHadBirthday ? age >= 18 : age > 18;
}

/// Helper function to calculate age from date of birth
int calculateAge(DateTime dateOfBirth) {
  final today = DateTime.now();
  var age = today.year - dateOfBirth.year;
  if (today.month < dateOfBirth.month ||
      (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
    age--;
  }
  return age;
}

InputDecoration inputStyle(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIcon: Icon(icon, color: Colors.white),
    filled: true,
    fillColor: Colors.white.withOpacity(0.15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    ),
  );
}

Widget signupField(
    TextEditingController controller, String label, IconData icon,
    {bool optional = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle(label, icon),
    ),
  );
}

Widget phoneField(TextEditingController controller) {
  return signupField(
    controller,
    "Contact Number",
    Icons.phone,
  );
}

Widget aadharField(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(12),
      ],
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle("Aadhar Number", Icons.credit_card),
    ),
  );
}

Widget otpField(TextEditingController controller, String label, IconData icon) {
  return Row(
    children: [
      Expanded(
        child: signupField(controller, label, icon),
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text("Verify"),
      )
    ],
  );
}

Widget genderDropdown(Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle("Gender", Icons.person),
      items: ["Male", "Female", "Other"]
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ))
          .toList(),
      onChanged: onChanged,
    ),
  );
}

Widget categoryDropdown(Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: DropdownButtonFormField<String>(
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle("Category", Icons.group),
      items: ["General", "OBC", "SC", "ST"]
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(color: Colors.white)),
              ))
          .toList(),
      onChanged: onChanged,
    ),
  );
}

Widget dateOfBirthField(
  BuildContext context,
  DateTime? selectedDate,
  Function(DateTime?) onDateChanged,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate:
                  DateTime.now().subtract(const Duration(days: 365 * 18)),
              helpText: 'Select your date of birth',
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.green.shade400,
                      surface: Colors.grey[900]!,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              onDateChanged(pickedDate);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? 'DOB: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Select Date of Birth',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (selectedDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Age: ${calculateAge(selectedDate)} years',
              style: TextStyle(
                  color: isUserAtLeast18(selectedDate)
                      ? Colors.green.shade300
                      : Colors.red.shade300,
                  fontSize: 14),
            ),
          ),
        if (selectedDate != null && !isUserAtLeast18(selectedDate))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '❌ You must be at least 18 years old to register',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget nextButton(VoidCallback onTap) {
  return ElevatedButton(onPressed: onTap, child: const Text("Next"));
}

Widget stepNavButtons(VoidCallback back, VoidCallback next) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton(onPressed: back, child: const Text("Back")),
      ElevatedButton(onPressed: next, child: const Text("Next")),
    ],
  );
}

Widget submitButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Navigator.pop(context),
    child: const Text("Sign Up"),
  );
}
