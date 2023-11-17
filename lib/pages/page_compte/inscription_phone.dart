import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:vp_chretien/pages/page_compte/otp_verification.dart';
import 'package:vp_chretien/services/auth_service.dart';


Color _mainColor= const Color(0xFF446600);
class InscriptionPhone extends StatefulWidget {
  const InscriptionPhone({super.key});
  @override
  State<InscriptionPhone> createState() => _InscriptionPhoneState();
}

class _InscriptionPhoneState extends State<InscriptionPhone> {

  @override
  void initState() {
    super.initState();
  }

  CountryCode countryCode = CountryCode();
  String selectedCountryName = '';
  String selectedCountryCode = '';
  final _contactController = TextEditingController();

  final _formKey= GlobalKey<FormState>();
  bool loading = false;
  String numero = '';
  void sendOtpCode(){
    if(_formKey.currentState!.validate()){
      if(numero.isNotEmpty) {
        loading=true;
        setState(() {});
        final auth = FirebaseAuth.instance;
        AuthService().authWithPhoneNumber(
          numero,
          onCodeSend: (verificationId , v){
            loading=false;
            setState(() {});
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OtpVerification(numero: numero, verificationId: verificationId,)));
          },
          onAutoVerify: (v) async{

            await auth.signInWithCredential(v);
            setState(() {
              loading=false;
            });
          },
          onFailed: (e){
            //loading=false;
            Fluttertoast.showToast(msg: "Connexion echouée, Veuillez réessayer");
            setState(() {
              loading=false;
            });
          },
          autoRetrieval: (v){

          },
        );
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // print(pays);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(color: Colors.grey.shade600,height: screenWidth>300?40.0:30.0,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
                // width: double.maxFinite,
                child: Text(
                  "Confirmez votre numéro",
                  style: GoogleFonts.abrilFatface(
                    fontSize: screenWidth>300?18.0:13.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                )
            ),

            SizedBox(
                // width: double.maxFinite,
                child: Text(
                  "Assurez-vous que le numéro de téléphone est valide pour obtenir un code de vérification",
                  style: TextStyle(
                    fontSize: screenWidth>300?16.0:11.0,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
                // width: double.maxFinite,
                child: Text(
                  "NB : CHOISISSEZ VOTRE PAYS D'ABORD !",
                  style: TextStyle(
                    fontSize: screenWidth>300?16.0:11.0,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),

            ),

            SizedBox(height: screenWidth>300?20.0:15.0,),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  CountryCodePicker(
                    onChanged: (CountryCode code) {
                      setState(() {
                        countryCode = code;
                        selectedCountryName = code.name!;
                        selectedCountryCode = code.code!;

                      });
                    },
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    // initialSelection: 'BF',
                    favorite: const ['BF','CI'],
                    // optional. Shows only country name and flag
                    showCountryOnly: true,
                    // optional. Shows only country name and flag when popup is closed.
                    showOnlyCountryWhenClosed: true,
                    builder: (countryCode) {
                      return Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade500,
                              width: 1.0,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "${countryCode?.flagUri}",
                              package: 'country_code_picker',
                              width: 32.0,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              '${countryCode?.name} (${countryCode?.dialCode})',
                              style: TextStyle(fontSize: screenWidth>300?16.0:11.0),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      );
                    },
                    // optional. aligns the flag and the Text left
                    alignLeft: false,
                    showDropDownButton: true,
                    boxDecoration: const BoxDecoration(
                        shape: BoxShape.rectangle
                    ),
                  ),

                  SizedBox(
                    height: screenWidth>300?20.0:15.0,
                  ),

                  SizedBox(
                    height: screenWidth>300?50.0:35.0,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.blue,
                      controller: _contactController,
                      style: TextStyle(
                          fontSize: screenWidth>300?18.0:13.0
                      ),
                      decoration: InputDecoration(
                        focusColor: Colors.blue,
                        labelText: "Numero de téléphone",
                        // hintText: "Adresse email",
                        labelStyle: TextStyle(color: Colors.grey.shade500,fontSize: screenWidth>300?18.0:13.0),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue,width: 2.0)
                        ),
                      ),
                      onChanged: (value){
                        numero = "${countryCode.dialCode}$value";
                        setState(() {});
                      },
                      validator: (valeur){
                        if(int.tryParse(valeur!,radix: 10) == null || valeur.length<5 ){
                          return "Veuillez saisir un numéro de téléphone";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: screenWidth>300?20.0:15.0,
                  ),

                  ElevatedButton(
                    onPressed: loading ? null : sendOtpCode,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 50.0),
                      backgroundColor: _mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                    ),
                    child: loading?
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ) :
                    Text("Confirmer" , style: TextStyle( color: Colors.white , fontSize: screenWidth>300?20.0:15.0, fontWeight: FontWeight.w600),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
