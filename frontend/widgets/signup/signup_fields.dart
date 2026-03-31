import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
