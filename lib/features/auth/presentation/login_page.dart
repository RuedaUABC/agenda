import 'package:flutter/material.dart';
import 'package:agenda/features/auth/data/auth_service.dart';
import 'package:agenda/features/navegacion/presentation/navegacion.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Bienvenido ${userCredential.user?.displayName}"),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const nav()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono principal (Nativo)
            Icon(
              Icons.calendar_today_rounded,
              size: 100,
              color: colors.primary,
            ),
            const SizedBox(height: 40),

            Text(
              "Mi Agenda",
              style: theme.textTheme.headlineLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Organiza tu tiempo con estilo",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 60),

            _isLoading
                ? CircularProgressIndicator(color: colors.primary)
                : ElevatedButton.icon(
                    onPressed: _handleGoogleSignIn,
                    // CAMBIO: Usamos un icono nativo en lugar de una URL
                    icon: const Icon(Icons.account_circle_outlined, size: 24),
                    label: const Text("Continuar con Google"),
                    style: ElevatedButton.styleFrom(
                      // Usamos colores de tu esquema OKLCH
                      backgroundColor: colors.surfaceContainerHighest,
                      foregroundColor: colors.onSurface,
                      minimumSize: const Size(double.infinity, 55),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Basado en --radius
                        side: BorderSide(
                          color: colors.outlineVariant,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
