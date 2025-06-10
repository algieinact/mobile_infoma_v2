import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/residence_provider.dart';
import '../models/residence_model.dart';
import '../widgets/residence_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'residence_detail_screen.dart';

class ResidenceListScreen extends StatefulWidget {
  const ResidenceListScreen({Key? key}) : super(key: key);

  @override
  State<ResidenceListScreen> createState() => _ResidenceListScreenState();
}

class _ResidenceListScreenState extends State<ResidenceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ResidenceProvider>().loadResidences());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search residences...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<ResidenceProvider>().searchResidences(value);
                },
              )
            : const Text('Residences'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ResidenceProvider>().searchResidences('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),
        ],
      ),
      body: Consumer<ResidenceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadResidences(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.filteredResidences.isEmpty) {
            return const Center(child: Text('No residences found'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadResidences(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.filteredResidences.length,
              itemBuilder: (context, index) {
                final residence = provider.filteredResidences[index];
                return ResidenceCard(
                  residence: residence,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResidenceDetailScreen(
                          residenceId: residence.id,
                        ),
                      ),
                    );
                  },
                  onDelete:
                      () {}, // Empty callback since we don't want delete functionality here
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add residence screen
          // TODO: Implement add residence screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
