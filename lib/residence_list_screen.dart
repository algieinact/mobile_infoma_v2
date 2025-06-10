import 'package:flutter/material.dart';

class ResidenceListScreen extends StatelessWidget {
  const ResidenceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Residence List'),
      ),
      body: const Center(
        child: Text('Residence List Screen'),
      ),
    );
  }
}
