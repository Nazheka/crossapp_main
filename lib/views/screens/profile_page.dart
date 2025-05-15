import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_the_label/providers/connectivity_provider.dart';
import 'package:read_the_label/services/auth_service.dart';
import 'package:read_the_label/models/user.dart';
import 'package:read_the_label/viewmodels/auth_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return FutureBuilder<User?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/auth');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      child: Icon(
                        user.isGuest ? Icons.person_outline : Icons.person,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        if (user.isGuest)
                          const Text(
                            'Guest User',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontFamily: 'Poppins',
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Poppins',
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 3,
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
                    child: Column(
                      children: [
                        _infoTile(context, Icons.person, 'Name', user.name),
                        const Divider(height: 24, thickness: 0.7),
                        _infoTile(context, Icons.email, 'Email', user.email),
                        const Divider(height: 24, thickness: 0.7),
                        _infoTile(context, Icons.badge, 'User ID', user.id ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_reset),
                        title: const Text('Change Password', style: TextStyle(fontFamily: 'Poppins')),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Change password not implemented yet.')),
                          );
                        },
                      ),
                      const Divider(height: 0),
                      Consumer<ConnectivityProvider>(
                        builder: (context, connectivityProvider, _) {
                          return ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Log out', style: TextStyle(color: Colors.red, fontFamily: 'Poppins')),
                            onTap: () async {
                              if (!connectivityProvider.isConnected) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please connect to the internet to log out.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              await context.read<AuthViewModel>().logout();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoTile(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 