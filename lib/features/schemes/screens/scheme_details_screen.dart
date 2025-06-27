import 'package:flutter/material.dart';
import '../models/scheme_model.dart';

class SchemeDetailsScreen extends StatelessWidget {
  final Scheme scheme;

  const SchemeDetailsScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Scheme Title
            Text(
              scheme.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
            ),
            const SizedBox(height: 12),

            // Chips for Metadata
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (scheme.state.isNotEmpty)
                  Chip(
                    label: Text("State: ${scheme.state}"),
                    backgroundColor: Colors.teal[50],
                  ),
                if (scheme.sector.isNotEmpty)
                  Chip(
                    label: Text("Eligibility: ${scheme.sector}"),
                    backgroundColor: Colors.orange[50],
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Description Section
            const Text(
              "Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              scheme.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 24),

            // CTA Button Placeholder
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  // TODO: Later you can link this to scheme application process
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apply process coming soon!')),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text("How to Apply"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
