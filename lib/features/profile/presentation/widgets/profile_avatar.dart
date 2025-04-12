import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;
  final double size;

  const ProfileAvatar({
    Key? key,
    this.avatarUrl,
    required this.name,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create initials from the name
    final nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
      if (nameParts.length > 1) {
        initials += nameParts[1][0];
      }
    }

    return avatarUrl != null && avatarUrl!.isNotEmpty
        ? CircleAvatar(
          radius: size / 2,
          backgroundImage: NetworkImage(avatarUrl!),
          backgroundColor: Colors.grey[200],
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
                      color: Colors.blue,
                    ),
                  )
                  : null,
        )
        : CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            initials.toUpperCase(),
            style: TextStyle(
              fontSize: size / 3,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        );
  }
}
