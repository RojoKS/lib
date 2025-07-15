import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anmelden oder Registrieren')),
      body: Center(
        child: SingleChildScrollView(
          // Verhindert Fehler, wenn die Tastatur das Bild verdeckt
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // E-Mail Feld
                TextFormField(
                  controller: _emailController, // Das Notizbuch für dieses Feld
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Bitte gib eine gültige E-Mail ein.';
                    }
                    return null; // null bedeutet: alles in Ordnung!
                  },
                ),
                const SizedBox(height: 12),

                // Passwort Feld
                TextFormField(
                  controller: _passwortController,
                  decoration: const InputDecoration(labelText: 'Passwort'),
                  obscureText:
                      true, // Das versteckt das Passwort (zeigt •••• an)
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Das Passwort muss mindestens 6 Zeichen lang sein.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Der Anmelde-Button
                ElevatedButton(
                  onPressed: () {
                    // Hier nutzen wir den "Draht", um die Validierung zu starten
                    final istFormularGueltig =
                        _formKey.currentState?.validate() ?? false;
                    if (istFormularGueltig) {
                      // Wenn alles gültig ist, machen wir hier später weiter...
                      print(
                        'Formular ist gültig! E-Mail: ${_emailController.text}',
                      );
                    }
                  },
                  child: const Text('Anmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
