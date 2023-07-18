import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?>  get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  })
  async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

  }

  Future<UserCredential?> registerUser(String email, String password, String contact, String fullName) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Enregistrement des champs supplémentaires dans la base de données utilisateur de Firebase
      await userCredential.user?.updateProfile(displayName: fullName);

      // Enregistrement des champs supplémentaires dans la base de données Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'contact': contact,
        'fullName': fullName,
      });

      return userCredential;

    } catch (e) {
      print('Erreur lors de l\'enregistrement de l\'utilisateur : $e');
      return null;
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

}