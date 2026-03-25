import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // CORRECCIÓN 1: Usar la instancia estática definida en tu archivo subido
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // CORRECCIÓN 2: Inicializar antes de usar (requerido por tu versión)
      await _googleSignIn.initialize();

      // Paso 1: Iniciar sesión (en tu archivo se llama 'authenticate' para flujo interactivo)
      // Nota: Tu archivo define 'authenticate' como el método principal para obtener tokens
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Paso 2: Obtener tokens
      // En tu archivo, 'authentication' es un GETTER que devuelve GoogleSignInAuthentication
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // CORRECCIÓN 3: Eliminado el "gg" accidental de tu código y ajuste de tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        // Nota: Si googleAuth no tiene accessToken, usa null o búscalo vía authorizationClient
        accessToken: null,
        idToken: googleAuth.idToken,
      );

      // Paso 3: Firebase
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(getErrorMessage(e.code));
    } catch (e) {
      debugPrint("Error no controlado: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No se encontró ningún usuario con esa dirección de correo electrónico.';
      case 'wrong-password':
        return 'La contraseña proporcionada es incorrecta.';
      case 'user-disabled':
        return 'El usuario ha sido deshabilitado.';
      case 'too-many-requests':
        return 'Demasiadas solicitudes. Intenta de nuevo más tarde.';
      case 'operation-not-allowed':
        return 'Operación no permitida.';
      default:
        return 'Error desconocido: $errorCode';
    }
  }
}
