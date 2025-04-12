// lib/features/profile/presentation/widgets/profile_field.dart
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
        Row(
          children: [
            Icon(prefixIcon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        isEditing && controller != null
            ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                fillColor: Colors.grey[50],
                filled: true,
              ),
              validator: validator,
            )
            : Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller?.text ?? initialValue ?? '',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
