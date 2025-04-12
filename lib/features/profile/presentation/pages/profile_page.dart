// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:modular_skripsi_app/features/auth/data/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../widgets/profile_field.dart';
import '../widgets/profile_avatar.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';

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

  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout Confirmation'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('LOGOUT'),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Dialog(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Logging out...'),
                  ],
                ),
              ),
            ),
      );

      // Perform actual logout
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      // Close dialog and navigate to login
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(user),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),

                    // User info card
                    _buildUserInfoCard(user),

                    const SizedBox(height: 24),

                    // Profile details section
                    _buildProfileDetailsSection(user),

                    // Account settings section
                    _buildAccountSettingsSection(),

                    // Logout button
                    _buildLogoutButton(),

                    const SizedBox(height: 24),

                    // Save button (only shown in edit mode)
                    if (_isEditing)
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _saveProfile,
                        icon:
                            _isLoading
                                ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.save),
                        label: const Text('SAVE CHANGES'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(UserModel? user) {
    return SliverAppBar(
      expandedHeight: 100.0,
      pinned: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          child: Stack(
            children: [
              // Add some decoration elements (smaller and more subtle)
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -15,
                bottom: -30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (!_isEditing) // Edit button when not in edit mode
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _toggleEdit,
            tooltip: 'Edit Profile',
          ),
        if (_isEditing) // Close button in edit mode
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _toggleEdit,
            tooltip: 'Cancel Editing',
          ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Help & Support')));
          },
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(UserModel? user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar section with edit capability
          Stack(
            children: [
              ProfileAvatar(
                avatarUrl: user?.avatarUrl,
                name: user?.name ?? 'User',
                size: 100,
              ),
              if (_isEditing)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Name field
          _isEditing
              ? TextFormField(
                controller: _nameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              )
              : Text(
                user?.name ?? 'User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
          const SizedBox(height: 4),

          // Email display
          Text(
            user?.email ?? 'No email',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          const SizedBox(height: 16),

          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!, width: 1),
            ),
            child: Text(
              user?.role ?? 'User',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailsSection(UserModel? user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Profile Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Profile fields
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.orange[700],
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Account Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Settings options
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Change Password')));
            },
          ),

          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: 'Notification Settings',
            subtitle: 'Manage your notification preferences',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification Settings')),
              );
            },
          ),

          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'Change app language',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Language Settings')),
              );
            },
            showDivider: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[600]),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1, indent: 70),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout),
        label: const Text('LOGOUT'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
