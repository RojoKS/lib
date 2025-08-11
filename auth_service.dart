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
  var _isLoginMode = true; // true = Anmelden, false = Registrieren

  @override
  void dispose() {
    _emailController.dispose();
    _passwortController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLoginMode ? 'Anmelden' : 'Registrieren')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            margin: const EdgeInsets.all(20.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // E-Mail Feld
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Bitte gib eine gültige E-Mail ein.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Passwort Feld
                    TextFormField(
                      controller: _passwortController,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Das Passwort muss mindestens 6 Zeichen lang sein.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Der Anmelde/Registrierungs-Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          final istFormularGueltig =
                              _formKey.currentState?.validate() ?? false;
                          if (istFormularGueltig) {
                            print(
                              'Formular ist gültig! E-Mail: ${_emailController.text}',
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(_isLoginMode ? 'Anmelden' : 'Registrieren'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLoginMode = !_isLoginMode;
                        });
                      },
                      child: Text(
                        _isLoginMode
                            ? 'Noch kein Konto? Jetzt registrieren'
                            : 'Bereits ein Konto? Hier anmelden',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
