import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../models/activity_model.dart';

class ActivityFormScreen extends StatefulWidget {
  final Activity? activity;

  const ActivityFormScreen({Key? key, this.activity}) : super(key: key);

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxParticipantsController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  String _type = 'workshop';
  String _format = 'online';
  bool _isFree = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  DateTime _registrationDeadline = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      _titleController.text = widget.activity!.title;
      _descriptionController.text = widget.activity!.description;
      _locationController.text = widget.activity!.location;
      _cityController.text = widget.activity!.city;
      _provinceController.text = widget.activity!.province;
      _priceController.text = widget.activity!.price.toString();
      _maxParticipantsController.text =
          widget.activity!.maxParticipants.toString();
      _requirementsController.text = widget.activity!.requirements ?? '';
      _benefitsController.text = widget.activity!.benefits ?? '';
      _meetingLinkController.text = widget.activity!.meetingLink ?? '';
      _type = widget.activity!.type;
      _format = widget.activity!.format;
      _isFree = widget.activity!.isFree;
      _startDate = widget.activity!.startDate;
      _endDate = widget.activity!.endDate;
      _registrationDeadline = widget.activity!.registrationDeadline;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _priceController.dispose();
    _maxParticipantsController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectRegistrationDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _registrationDeadline,
      firstDate: DateTime.now(),
      lastDate: _startDate,
    );
    if (picked != null) {
      setState(() {
        _registrationDeadline = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final activityData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'type': _type,
        'price': _isFree ? 0 : double.parse(_priceController.text),
        'is_free': _isFree,
        'location': _locationController.text,
        'city': _cityController.text,
        'province': _provinceController.text,
        'format': _format,
        'meeting_link': _meetingLinkController.text,
        'start_date': _startDate.toIso8601String(),
        'end_date': _endDate.toIso8601String(),
        'registration_deadline': _registrationDeadline.toIso8601String(),
        'requirements': _requirementsController.text,
        'benefits': _benefitsController.text,
        'max_participants': int.parse(_maxParticipantsController.text),
      };

      if (widget.activity == null) {
        await context.read<ActivityProvider>().createActivity(activityData);
      } else {
        await context.read<ActivityProvider>().updateActivity(
              widget.activity!.id,
              activityData,
            );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.activity == null
                  ? 'Activity created successfully'
                  : 'Activity updated successfully',
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
        title: Text(widget.activity == null ? 'Add Activity' : 'Edit Activity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
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
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'workshop', child: Text('Workshop')),
                DropdownMenuItem(value: 'seminar', child: Text('Seminar')),
                DropdownMenuItem(value: 'training', child: Text('Training')),
                DropdownMenuItem(
                    value: 'competition', child: Text('Competition')),
              ],
              onChanged: (value) {
                setState(() => _type = value!);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Free Activity'),
              value: _isFree,
              onChanged: (value) {
                setState(() => _isFree = value);
              },
            ),
            if (!_isFree) ...[
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
                  if (!_isFree && (value == null || value.isEmpty)) {
                    return 'Please enter a price';
                  }
                  if (!_isFree && double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
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
            DropdownButtonFormField<String>(
              value: _format,
              decoration: const InputDecoration(
                labelText: 'Format',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'online', child: Text('Online')),
                DropdownMenuItem(value: 'offline', child: Text('Offline')),
                DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
              ],
              onChanged: (value) {
                setState(() => _format = value!);
              },
            ),
            if (_format == 'online' || _format == 'hybrid') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _meetingLinkController,
                decoration: const InputDecoration(
                  labelText: 'Meeting Link',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((_format == 'online' || _format == 'hybrid') &&
                      (value == null || value.isEmpty)) {
                    return 'Please enter a meeting link';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Date'),
              subtitle: Text(_startDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, true),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('End Date'),
              subtitle: Text(_endDate.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, false),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Registration Deadline'),
              subtitle: Text(_registrationDeadline.toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectRegistrationDeadline(context),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _requirementsController,
              decoration: const InputDecoration(
                labelText: 'Requirements',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _benefitsController,
              decoration: const InputDecoration(
                labelText: 'Benefits',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxParticipantsController,
              decoration: const InputDecoration(
                labelText: 'Maximum Participants',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter maximum participants';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitForm,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.activity == null
                      ? 'Add Activity'
                      : 'Update Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
