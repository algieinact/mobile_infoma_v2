import 'package:flutter/material.dart';
import '../models/residence_model.dart';
import '../services/residence_service.dart';
import 'booking_form_screen.dart';

class ResidenceDetailScreen extends StatefulWidget {
  final int residenceId;

  const ResidenceDetailScreen({Key? key, required this.residenceId})
      : super(key: key);

  @override
  State<ResidenceDetailScreen> createState() => _ResidenceDetailScreenState();
}

class _ResidenceDetailScreenState extends State<ResidenceDetailScreen> {
  late Future<Residence> _residenceFuture;

  @override
  void initState() {
    super.initState();
    _residenceFuture = ResidenceService.getResidenceById(widget.residenceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Residence>(
        future: _residenceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _residenceFuture = ResidenceService.getResidenceById(
                          widget.residenceId,
                        );
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No residence found'));
          }

          final residence = snapshot.data!;
          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: residence.images?.isNotEmpty ?? false
                      ? Image.network(
                          residence.images!.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.home,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              residence.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                residence.rating.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Address
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              residence.address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price and Capacity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${residence.price.toStringAsFixed(2)}/month',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${residence.totalRooms} persons',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        residence.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),

                      // Amenities
                      Text(
                        'Amenities',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: residence.facilities.map((amenity) {
                          return Chip(
                            label: Text(amenity),
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Book Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingFormScreen(residence: residence),
                              ),
                            );

                            if (result == true) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
