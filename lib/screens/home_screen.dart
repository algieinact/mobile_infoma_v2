import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'residence_list_screen.dart';
import 'booking_list_screen.dart';
import 'activities_screen.dart';
import 'provider_dashboard_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isProviderScreen = false;

  @override
  void initState() {
    super.initState();
    // Check user role once when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null && user.role == AppConstants.providerRole) {
        setState(() {
          _isProviderScreen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        if (user == null) {
          return const Center(
            child: Text('No user data available'),
          );
        }

        // Show provider dashboard for users with provider role
        if (_isProviderScreen) {
          return const ProviderDashboardScreen();
        }

        // Show regular home screen for other users
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user.name}!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text('Email: ${user.email}'),
                          Text('Role: ${user.role ?? 'Not specified'}'),
                          Text(
                              'Member since: ${user.createdAt.toString().split(' ')[0]}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400, // Fixed height for the grid
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildActionCard(
                          context,
                          'Residences',
                          Icons.home,
                          Colors.blue,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResidenceListScreen(),
                            ),
                          ),
                        ),
                        _buildActionCard(
                          context,
                          'Activities',
                          Icons.local_activity,
                          Colors.green,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ActivitiesScreen(),
                            ),
                          ),
                        ),
                        _buildActionCard(
                          context,
                          'Bookings',
                          Icons.book_online,
                          Colors.orange,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingListScreen(),
                            ),
                          ),
                        ),
                        _buildActionCard(
                          context,
                          'Reviews',
                          Icons.star,
                          Colors.purple,
                          () => _showComingSoon(context, 'Reviews'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return AlertDialog(
              title: const Text('Logout'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to logout?'),
                  if (authProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          try {
                            await authProvider.logout();
                            if (mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Logout failed: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          }
                        },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
