import 'package:flutter/material.dart';
import 'package:yojna_mitr/features/schemes/screens/scheme_details_screen.dart';
import '../../schemes/models/scheme_model.dart';
import '../../bookmarks/services/bookmark_service.dart';

class BookmarksScreen extends StatelessWidget {
  BookmarksScreen({super.key});

  final BookmarkService _bookmarkService = BookmarkService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Schemes")),
      body: StreamBuilder<List<Scheme>>(
        stream: _bookmarkService.getBookmarksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookmarks = snapshot.data ?? [];

          if (bookmarks.isEmpty) {
            return const Center(child: Text("No saved schemes yet."));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final scheme = bookmarks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(scheme.name),
                  subtitle: Text(scheme.description),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SchemeDetailsScreen(scheme: scheme),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
