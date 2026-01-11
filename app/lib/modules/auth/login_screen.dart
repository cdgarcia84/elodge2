import 'package:flutter/material.dart';

import '../../core/session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onLogin});

  final ValueChanged<UserSession> onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppUser? _selectedUser = MockUsers.users.first;
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final user = _selectedUser;
    if (user == null) {
      setState(() => _error = 'Selecciona un usuario.');
      return;
    }
    if (_passwordController.text != user.password) {
      setState(() => _error = 'Password incorrecta.');
      return;
    }

    widget.onLogin(user.toSession());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ingreso',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AppUser>(
                    value: _selectedUser,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                    items: [
                      for (final user in MockUsers.users)
                        DropdownMenuItem(
                          value: user,
                          child: Text('${user.username} (${user.rolGestion})'),
                        ),
                    ],
                    onChanged: (value) => setState(() {
                      _selectedUser = value;
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      helperText: 'Demo: demo',
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Ingresar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
