import 'package:flutter/material.dart';

import 'main.dart';

class Kunde {
  final String id;
  final String email;
  final String passwort;

  Kunde({required this.id, required this.email, required this.passwort});
}

class KundeState extends State<HomeScreen> {
  List<Kunde> kunden = [
    Kunde(id: '1', email: 'freestyler@vlr.de', passwort: 'freestyle'),
    Kunde(id: '2', email: 'romanvlr@web.de', passwort: 'passwort'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
