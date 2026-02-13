import 'package:flutter/material.dart';
import '../../models/ngo_model.dart';

class NGODetailPage extends StatelessWidget {
  final NGO ngo;

  const NGODetailPage({super.key, required this.ngo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ngo.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(ngo.logoUrl),
            ),
            const SizedBox(height: 16),
            Text(
              ngo.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(ngo.location),
            const SizedBox(height: 16),
            Text(ngo.description),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Donate to NGO"),
            )
          ],
        ),
      ),
    );
  }
}
