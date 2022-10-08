import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/widget/text_divider/src/text_divider.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PrimaryColor,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
            backgroundColor: PrimaryColor,
            body:Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: CustomScrollView(
              slivers: [
              SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: FlutterLogo(size: 150),
                      ),),
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Un email vous serras envoyer pour récuperer votre mot de passe",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    //email
                                    Container(
                                      padding: EdgeInsets.only(left: 20, right: 8),
                                      child: TextFormField(
                                        controller: emailController,
                                        style: TextStyle(color: PrimaryColor),
                                        cursorColor: PrimaryColor,
                                        keyboardType: TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelStyle: TextStyle(color: PrimaryColor300),
                                          labelText: 'Email',
                                          suffixIcon: Icon(
                                            CupertinoIcons.at_circle,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                        validator: (value) => value == null || value.isEmpty ? "Email requis" : null,
                                      ),
                                      decoration: BoxDecoration(
                                        color: PrimaryColor100,
                                        //  border: Border.all(color: PrimaryColorLight),
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      ),),
                                    SizedBox(height: 20.0),
                                    Container(
                                      margin: EdgeInsets.only(left: 30, right: 30),
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                            backgroundColor: MaterialStateColor.resolveWith((states) => YellowColor),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  //side: BorderSide(color: Colors.red, width: .1)
                                                )
                                            )
                                        ),
                                        child: Text(
                                          "Réinitilaiser le mot de passe",
                                          style: TextStyle(color: PrimaryColor),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState?.validate() == true) {

                                            var email = emailController.value.text;

                                            try{
                                              await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
                                                  .whenComplete(() => Navigator.pop(context));
                                            } on FirebaseAuthException catch(e){
                                              setState(() => error = e.message??'');
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                    Text(
                                      error,
                                      style: TextStyle(color: Colors.redAccent, fontSize: 15.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            )
              ],
            )),

          );
  }
}
