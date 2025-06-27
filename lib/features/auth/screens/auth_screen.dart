import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isLoginMode = true;
  bool _obscurePassword = true; // 👈 Added for show/hide password toggle

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _auth.signInWithEmail(_email, _password);
      } else {
        await _auth.signUpWithEmail(_email, _password);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleMode() {
    setState(() => _isLoginMode = !_isLoginMode);
  }

  void _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInWithGoogle();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isLoginMode ? 'Login' : 'Sign Up',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value!.contains('@') ? null : 'Enter valid email',
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      key: const ValueKey('password'),
                      obscureText: _obscurePassword, // 👈 Link with toggle
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>
                          value != null && value.length >= 6 ? null : 'Min 6 chars',
                      onSaved: (value) => _password = value!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLoginMode ? 'Login' : 'Sign Up'),
                ),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(_isLoginMode
                      ? "Create new account"
                      : "Already have an account? Login"),
                ),
                const Divider(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Continue with Google'),
                  onPressed: _signInWithGoogle,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
