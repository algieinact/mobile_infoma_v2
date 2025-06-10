import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/residence_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 1000);
  String _sortBy = 'price_low';
  final List<String> _selectedAmenities = [];

  final List<String> _availableAmenities = [
    'WiFi',
    'Kitchen',
    'Washer',
    'Dryer',
    'Air Conditioning',
    'Heating',
    'TV',
    'Parking',
    'Gym',
    'Pool',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Residences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 16),

          // Sort By
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8,
            children: [
              _buildSortChip('price_low', 'Price: Low to High'),
              _buildSortChip('price_high', 'Price: High to Low'),
              _buildSortChip('rating', 'Rating'),
              _buildSortChip('reviews', 'Most Reviews'),
            ],
          ),
          const SizedBox(height: 16),

          // Amenities
          const Text(
            'Amenities',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8,
            children:
                _availableAmenities.map((amenity) {
                  return FilterChip(
                    label: Text(amenity),
                    selected: _selectedAmenities.contains(amenity),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final provider = context.read<ResidenceProvider>();
                provider.filterByPriceRange(_priceRange.start, _priceRange.end);
                provider.sortResidences(_sortBy);
                if (_selectedAmenities.isNotEmpty) {
                  provider.filterByAmenities(_selectedAmenities);
                }
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _sortBy == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _sortBy = value;
          });
        }
      },
    );
  }
}
