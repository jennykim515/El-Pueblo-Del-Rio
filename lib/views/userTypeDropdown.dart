import 'package:flutter/material.dart';

class UserTypeDropdown extends StatefulWidget {
  final Function(String?) onSelect; // Callback function

  const UserTypeDropdown({super.key, required this.onSelect});

  @override
  _UserTypeDropdownState createState() => _UserTypeDropdownState();
}

class _UserTypeDropdownState extends State<UserTypeDropdown> {
  String? _selectedValue = 'Resident'; // Default value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: "Select your role",
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        items: <String>['Resident', 'Officer']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding( // Wrap the text with Padding
              padding: const EdgeInsets.only(left: 8.0), // Indent to the right
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
          });

          widget.onSelect(newValue); // Call the callback function with the new value
        },
      ),
    );
  }
}
