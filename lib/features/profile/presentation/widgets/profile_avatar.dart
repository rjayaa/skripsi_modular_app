// lib/features/profile/presentation/widgets/profile_avatar.dart
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const ProfileAvatar({
    Key? key,
    this.avatarUrl,
    required this.name,
    this.size = 100,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create initials from the name
    final nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
        initials += nameParts[1][0];
      }
    }

    final defaultBackgroundColor =
        avatarUrl == null
            ? Theme.of(context).primaryColor.withOpacity(0.2)
            : Colors.grey[200];
    final defaultTextColor = Theme.of(context).primaryColor;

    // Check if we should use avatar image or initials
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:
          avatarUrl != null && avatarUrl!.isNotEmpty
              ? CircleAvatar(
                radius: size / 2,
                backgroundColor: backgroundColor ?? defaultBackgroundColor,
                // Attempt to load the image
                backgroundImage: NetworkImage(avatarUrl!),
                // Fallback if image fails to load
                onBackgroundImageError: (exception, stackTrace) {
                  // Silently handle error
                },
                child:
                    avatarUrl == null
                        ? Text(
                          initials.toUpperCase(),
                          style: TextStyle(
                            fontSize: size / 3,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? defaultTextColor,
                          ),
                        )
                        : null,
              )
              : CircleAvatar(
                radius: size / 2,
                backgroundColor: backgroundColor ?? defaultBackgroundColor,
                child: Text(
                  initials.toUpperCase(),
                  style: TextStyle(
                    fontSize: size / 3,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? defaultTextColor,
                  ),
                ),
              ),
    );
  }
}
