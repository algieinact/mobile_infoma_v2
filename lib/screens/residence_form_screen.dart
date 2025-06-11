import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/residence_provider.dart';
import '../models/residence_model.dart';

class ResidenceFormScreen extends StatefulWidget {
  final Residence? residence;

  const ResidenceFormScreen({Key? key, this.residence}) : super(key: key);

  @override
  State<ResidenceFormScreen> createState() => _ResidenceFormScreenState();
}

class _ResidenceFormScreenState extends State<ResidenceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _priceController = TextEditingController();
  final _capacityController = TextEditingController();
  final _facilitiesController = TextEditingController();
  final _rulesController = TextEditingController();
  String _type = 'kost';
  String _gender = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.residence != null) {
      _nameController.text = widget.residence!.title;
      _descriptionController.text = widget.residence!.description;
      _addressController.text = widget.residence!.address;
      _cityController.text = widget.residence!.city;
      _provinceController.text = widget.residence!.province;
      _priceController.text = widget.residence!.price.toString();
      _capacityController.text = widget.residence!.totalRooms.toString();
      _type = widget.residence!.type;
      _gender = widget.residence!.genderType;
      _facilitiesController.text = widget.residence!.facilities.join(', ');
      _rulesController.text = widget.residence!.rules.join(', ');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    _facilitiesController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> residenceData;

      if (widget.residence == null) {
        // Creating new residence
        residenceData = {
          'title': _nameController.text,
          'description': _descriptionController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'province': _provinceController.text,
          'price': double.parse(_priceController.text),
          'total_rooms': int.parse(_capacityController.text),
          'type': _type,
          'gender_type': _gender,
          'price_period': 'monthly', // Assuming a default
          'facilities': _facilitiesController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          'rules':
              _rulesController.text.split(',').map((e) => e.trim()).toList(),
          'available_rooms': int.parse(_capacityController
              .text), // Assuming available_rooms = total_rooms
          'category_id':
              1, // Assuming a default category ID. This might need to be a selectable field later.
        };
        print('Sending create data: $residenceData');
        await context.read<ResidenceProvider>().createResidence(residenceData);
      } else {
        // Updating existing residence
        residenceData =
            widget.residence!.toJson(); // Start with all existing data

        // Override with form values
        residenceData['title'] = _nameController.text;
        residenceData['description'] = _descriptionController.text;
        residenceData['address'] = _addressController.text;
        residenceData['city'] = _cityController.text;
        residenceData['province'] = _provinceController.text;
        residenceData['price'] = double.parse(_priceController.text);
        residenceData['total_rooms'] = int.parse(_capacityController.text);
        residenceData['type'] = _type;
        residenceData['gender_type'] = _gender;
        residenceData['facilities'] =
            _facilitiesController.text.split(',').map((e) => e.trim()).toList();
        residenceData['rules'] =
            _rulesController.text.split(',').map((e) => e.trim()).toList();

        // Update updated_at field
        residenceData['updated_at'] = DateTime.now().toIso8601String();

        print('Sending update data: $residenceData');

        await context.read<ResidenceProvider>().updateResidence(
              widget.residence!.id,
              residenceData,
            );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.residence == null
                  ? 'Residence created successfully'
                  : 'Residence updated successfully',
            ),
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.residence == null ? 'Add Residence' : 'Edit Residence'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _provinceController,
              decoration: const InputDecoration(
                labelText: 'Province',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a province';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _capacityController,
              decoration: const InputDecoration(
                labelText: 'Capacity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a capacity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _facilitiesController,
              decoration: const InputDecoration(
                labelText: 'Facilities (comma-separated)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter facilities';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _rulesController,
              decoration: const InputDecoration(
                labelText: 'Rules (comma-separated)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter rules';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'kost', child: Text('Kost')),
                DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                DropdownMenuItem(value: 'house', child: Text('House')),
              ],
              onChanged: (value) {
                setState(() => _type = value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'male', child: Text('Male')),
                DropdownMenuItem(value: 'female', child: Text('Female')),
              ],
              onChanged: (value) {
                setState(() => _gender = value!);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.residence == null
                      ? 'Add Residence'
                      : 'Update Residence'),
            ),
          ],
        ),
      ),
    );
  }
}
