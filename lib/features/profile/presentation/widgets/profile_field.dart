import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final bool isEditing;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const ProfileField({
    Key? key,
    required this.label,
    this.controller,
    this.initialValue,
    required this.isEditing,
    required this.prefixIcon,
    this.validator,
  }) : assert(controller != null || initialValue != null),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        isEditing && controller != null
            ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(prefixIcon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
              ),
              validator: validator,
            )
            : Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(prefixIcon, color: Colors.grey),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      controller?.text ?? initialValue ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
