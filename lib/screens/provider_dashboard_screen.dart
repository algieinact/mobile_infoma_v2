import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/residence_provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/residence_card.dart';
import '../widgets/activity_card.dart';
import 'residence_form_screen.dart';
import 'activity_form_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load data when screen is initialized
    Future.microtask(() {
      context.read<ResidenceProvider>().loadResidences();
      context.read<ActivityProvider>().loadActivities();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Residences'),
            Tab(text: 'Activities'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResidencesTab(),
          _buildActivitiesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show different dialogs based on selected tab
          if (_tabController.index == 0) {
            _showAddResidenceDialog();
          } else {
            _showAddActivityDialog();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildResidencesTab() {
    return Consumer<ResidenceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        if (provider.residences.isEmpty) {
          return const Center(
            child: Text('No residences found. Add your first residence!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.residences.length,
          itemBuilder: (context, index) {
            final residence = provider.residences[index];
            return ResidenceCard(
              residence: residence,
              onEdit: () => _showEditResidenceDialog(residence),
              onDelete: () => _showDeleteResidenceDialog(residence.id),
            );
          },
        );
      },
    );
  }

  Widget _buildActivitiesTab() {
    return Consumer<ActivityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        if (provider.activities.isEmpty) {
          return const Center(
            child: Text('No activities found. Add your first activity!'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.activities.length,
          itemBuilder: (context, index) {
            final activity = provider.activities[index];
            return ActivityCard(
              activity: activity,
              onEdit: () => _showEditActivityDialog(activity),
              onDelete: () => _showDeleteActivityDialog(activity.id),
            );
          },
        );
      },
    );
  }

  void _showAddResidenceDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResidenceFormScreen(),
      ),
    );
  }

  void _showEditResidenceDialog(dynamic residence) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResidenceFormScreen(residence: residence),
      ),
    );
  }

  void _showDeleteResidenceDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Residence'),
        content: const Text('Are you sure you want to delete this residence?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ResidenceProvider>().deleteResidence(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Residence deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddActivityDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ActivityFormScreen(),
      ),
    );
  }

  void _showEditActivityDialog(dynamic activity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityFormScreen(activity: activity),
      ),
    );
  }

  void _showDeleteActivityDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<ActivityProvider>().deleteActivity(id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Activity deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
