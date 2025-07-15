import 'package:flutter/material.dart';

class Hofladen {
  final String name;
  final String adresse;
  final String entfernung;
  final List<String> kategorien;
  final Image bilder;
  final double lat;
  final double lng;

  Hofladen({
    required this.name,
    required this.adresse,
    required this.entfernung,
    required this.kategorien,
    required this.bilder,
    required this.lat,
    required this.lng,
  });
}
