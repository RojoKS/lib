import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'hofladen.dart';
import 'hofladen_tile.dart';
import 'standort_service.dart';
import 'places_service.dart';
import 'auth_service.dart';

void main() {
  runApp(const RegioDirektApp());
}

class RegioDirektApp extends StatelessWidget {
  const RegioDirektApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RegioDirekt',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Hofladen> naheHoflaeden = [];
  String? _ausgewaehlteKategorie;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _ladeStandortUndHoflaeden();
  }

  Future<void> _ladeStandortUndHoflaeden() async {
    // Setze den Ladezustand, damit der Nutzer eine Rückmeldung bekommt.
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Standort abfragen
      final position = await StandortService.getStandort();
      if (position == null) {
        throw Exception("Standort konnte nicht ermittelt werden.");
      }

      // 2. Hofläden über den neuen Service suchen
      final gefundeneHoflaeden = await PlacesService.findHoflaeden(position);

      // 3. UI mit den neuen Daten aktualisieren
      setState(() {
        naheHoflaeden = gefundeneHoflaeden;
        _isLoading = false;
      });
    } catch (e) {
      // Fehler abfangen und eine Nachricht für den Nutzer setzen.
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      print(e); // Fehler in der Konsole ausgeben für die Entwicklung.
    }
  }

  Widget _buildCategoryChip(String kategorie, IconData icon) {
    final isSelected = _ausgewaehlteKategorie == kategorie;
    return FilterChip(
      label: Text(kategorie),
      avatar: Icon(icon, color: isSelected ? Colors.white : Colors.green[700]),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _ausgewaehlteKategorie = kategorie;
          } else {
            _ausgewaehlteKategorie = null;
          }
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.green,
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
      elevation: 1,
      pressElevation: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final anzeigeHoflaeden = naheHoflaeden.where((hof) {
      if (_ausgewaehlteKategorie == null) {
        return true;
      }
      return hof.kategorien.contains(_ausgewaehlteKategorie);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('RegioDirekt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            tooltip: 'Anmelden',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const SizedBox(height: 32),
            Text(
              'RegioDirekt',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Finde regionale Produkte & Hofläden in deiner Nähe.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Adresseingabe
            TextField(
              decoration: InputDecoration(
                hintText: 'Deine Adresse oder PLZ eingeben...',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) {},
            ),

            const SizedBox(height: 32),

            // Kategorien
            const Text(
              'Lebensmittel-Kategorien',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildCategoryChip("Obst", Icons.apple),
                _buildCategoryChip("Gemüse", Icons.grass),
                _buildCategoryChip("Milch", Icons.local_drink),
                _buildCategoryChip("Eier", Icons.egg),
                _buildCategoryChip("Fleisch", Icons.set_meal),
                _buildCategoryChip("Honig", Icons.bug_report),
                _buildCategoryChip("Brot", Icons.bakery_dining),
              ],
            ),

            const SizedBox(height: 32),

            // Hofläden Liste
            Text(
              _ausgewaehlteKategorie ?? 'Hofläden in deiner Nähe',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Text(
                  'Ein Fehler ist aufgetreten:\n$_errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: anzeigeHoflaeden.length,
                itemBuilder: (context, index) {
                  return HofladenTile(hofladen: anzeigeHoflaeden[index]);
                },
              ),
          ],
        ),
      ),
    );
  }
}
