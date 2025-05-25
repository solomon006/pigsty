import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delicious/providers/auth_provider.dart';
import 'package:delicious/screens/login_screen.dart';
import 'package:delicious/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: authProvider.isAuthenticated 
          ? _buildProfileContent(context, authProvider)
          : _buildNotAuthenticatedView(context),
    );
  }
  
  Widget _buildProfileContent(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.userModel;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    user?.displayName?.isNotEmpty == true 
                        ? user!.displayName![0].toUpperCase() 
                        : 'U',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Divider(),
          
          // Profile Options
          _buildProfileOption(
            context,
            icon: Icons.location_on_outlined,
            title: 'Delivery Address',
            subtitle: user?.address ?? 'No address added',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(initialTab: 1),
                ),
              );
            },
          ),
          
          const Divider(),
          
          _buildProfileOption(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Configure notification settings',            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications settings coming soon!')),
              );
            },
          ),
          
          const Divider(),
          
          _buildProfileOption(
            context,
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Add or remove payment methods',            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment methods feature coming soon!')),
              );
            },
          ),
          
          const Divider(),
          
          _buildProfileOption(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Contact us, FAQs, and more',            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support: Contact us at support@delicious.com')),
              );
            },
          ),
          
          const Divider(),
          
          _buildProfileOption(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            subtitle: 'Terms of service and privacy policy',            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Delicious Food Shop'),
                  content: const Text('Version 1.0.0\n\nA modern food delivery app for ordering burgers, pizzas, and drinks.\n\nTerms of Service and Privacy Policy available at delicious.com'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Show confirmation dialog
                final result = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('SIGN OUT'),
                      ),
                    ],
                  ),
                );
                
                if (result == true) {
                  await authProvider.signOut();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotAuthenticatedView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Please login to access your profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Login to view and manage your account details',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('LOGIN / REGISTER'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
