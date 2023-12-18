import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user_model.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  //authentification via un numéro de téléphone
  void authWithPhoneNumber(String phone , {
    required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoVerify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval
  }) async{

    auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 40),
      verificationCompleted: onAutoVerify,
      verificationFailed: onFailed,
      codeSent: onCodeSend,
      codeAutoRetrievalTimeout: autoRetrieval,
    );
  }
  // envoie d'un OPT par sms
  Future<void> optSend(String verificationId,String smsCode) async{
    final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential);
    return;
  }
  // Inscription par adresse email
  Future<void> signUpWithEmail(UserModel userModel ) async{
    DatabaseReference firebaseDatabase = FirebaseDatabase.instance.ref().child('Admin/Users');
    User? user = auth.currentUser;
    await firebaseDatabase.child(user!.uid).set(userModel.toMap());
  }

  //mise à jour du profil de l'utilisateur
  void updateUserProfil( Map<String,dynamic> userInformations) async{

    DatabaseReference ref= FirebaseDatabase.instance.ref();
    // print(key);
    String key= auth.currentUser!.uid;
    await ref.child("Admin/Users/$key").update(userInformations).then((value){
      Fluttertoast.showToast(msg: "Mise à jour effectué avec succès");
    }
    ).catchError((e){
      Fluttertoast.showToast(msg: "Une erreur s'est produite lors de la mise à jour");
    });

  }

  // la deconnexion
  void signOut() async {
    await auth.signOut();
  }

  //recupération de mot de passe
  Future<bool> resetPassword(String email) async {
    try{
      await auth.setLanguageCode('fr');
      await auth.sendPasswordResetEmail(email: email);
      return true;
    }catch(e){
      return false;
    }
  }

  //information de l'utilisateur connecté
  UserModel getUserInfo() {
    UserModel userModel=UserModel();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Admin/Users/${auth.currentUser?.uid}');
    ref.onValue.listen((event) {
        userModel = UserModel.fromMap(event.snapshot.value);
    });

    return userModel;
  }

  void deleteUser() {
    auth.signOut();
    try {
      FirebaseDatabase.instance.ref().child(
          'Admin/Users/${auth.currentUser?.uid}').remove();
      Fluttertoast.showToast(msg: "Votre compte à été supprimé avec succès");

    }catch(e){
      Fluttertoast.showToast(msg: "Une erreur est survenue veuillez essayer à nouveau");
    }
  }

}