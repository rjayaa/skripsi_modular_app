import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/profile_field.dart';
import '../widgets/profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement profile update through an API call
    // This would typically connect to your updateProfile endpoint

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // For now, just update the local state
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // This is a placeholder - in a real app, you'd update the profile via API

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Profile avatar
                ProfileAvatar(
                  avatarUrl: user?.avatarUrl,
                  name: user?.name ?? 'User',
                  size: 120,
                ),

                const SizedBox(height: 30),

                // Name field
                ProfileField(
                  label: 'Name',
                  controller: _nameController,
                  isEditing: _isEditing,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Email field (non-editable)
                ProfileField(
                  label: 'Email',
                  initialValue: user?.email ?? '',
                  isEditing: false, // Email is non-editable
                  prefixIcon: Icons.email,
                ),

                const SizedBox(height: 16),

                // Role field (non-editable)
                ProfileField(
                  label: 'Role',
                  initialValue: user?.role ?? 'User',
                  isEditing: false, // Role is non-editable
                  prefixIcon: Icons.badge,
                ),

                const SizedBox(height: 16),

                // Member since (non-editable)
                if (user?.createdAt != null)
                  ProfileField(
                    label: 'Member Since',
                    initialValue: _formatDate(user!.createdAt),
                    isEditing: false,
                    prefixIcon: Icons.calendar_today,
                  ),

                const SizedBox(height: 30),

                // Save button (only shown in edit mode)
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('SAVE PROFILE'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
