// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:vp_chretien/models/user_model.dart';
//
//
// final auth = FirebaseAuth.instance;
// void authWithPhoneNumber(String phone , {
//   required Function(String value, int? value1) onCodeSend,
//   required Function(PhoneAuthCredential value) onAutoVerify,
//   required Function(FirebaseAuthException value) onFailed,
//   required Function(String value) autoRetrieval
// }) async{
//
//   auth.verifyPhoneNumber(
//       phoneNumber: phone,
//       timeout: const Duration(seconds: 40),
//       verificationCompleted: onAutoVerify,
//       verificationFailed: onFailed,
//       codeSent: onCodeSend,
//       codeAutoRetrievalTimeout: autoRetrieval,
//   );
// }
//
// Future<void> optSend(String verificationId,String smsCode) async{
//   final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
//   await auth.signInWithCredential(credential);
//   return;
// }
//
// void updateUserProfil( Map<String,dynamic> userInformations) async{
//
//   DatabaseReference ref= FirebaseDatabase.instance.ref();
//   // print(key);
//   String key= auth.currentUser!.uid;
//   await ref.child("Admin/Users/$key").update(userInformations).then((value){
//       Fluttertoast.showToast(msg: "Mise à jour effectué avec succès");
//     }
//   ).catchError((e){
//     Fluttertoast.showToast(msg: "Une erreur s'est produite lors de la mise à jour");
//   });
//
// }
//
// // la deconnexion
// void signOut() async {
//   await auth.signOut();
// }
//
// // recuperer l'utilisateur courant
//
// Future<bool> resetPassword(String email) async {
//   try{
//     await auth.setLanguageCode('fr');
//     await auth.sendPasswordResetEmail(email: email);
//     return true;
//   }catch(e){
//     return false;
//   }
// }