import 'package:flutter/material.dart';
import 'hofladen.dart';

class HofladenTile extends StatelessWidget {
  final Hofladen hofladen;

  const HofladenTile({super.key, required this.hofladen});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: hofladen.bilder,
        ),
        title: Text(hofladen.name),
        subtitle: Text(
          "${hofladen.adresse}\n${hofladen.kategorien.join(', ')}",
        ),
        trailing: Text(hofladen.entfernung),
        isThreeLine: false,
      ),
    );
  }
}
