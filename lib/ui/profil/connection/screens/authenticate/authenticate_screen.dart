import 'package:flutter/material.dart';
import 'package:myliveevent/theme/myTheme.dart';
import 'package:myliveevent/ui/profil/connection/common/constants.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      nameController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 50),
                      child: FlutterLogo(size: 150),
                    ),
                    Text(showSignIn ? "S'enregistrer" : 'Se connecter',
                        style: TextStyle(color: PrimaryColor, fontSize: 20)),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              !showSignIn
                           ? Container(
                            height: 50,
                            padding: EdgeInsets.only(left: 20, right: 8),
                            child: TextFormField(
                              controller: nameController,
                              style: TextStyle(color: PrimaryColor),
                              cursorColor: PrimaryColor,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: PrimaryColor300),
                                labelText: 'Votre nom',
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              validator: (value) =>
                              value == null || value.isEmpty ? "Vous devez entrer un nom" : null,
                            ),
                            decoration: BoxDecoration(
                              color: PrimaryColor100,
                              //  border: Border.all(color: PrimaryColorLight),
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            ),)
                                  : Container(),
                              !showSignIn ? SizedBox(height: 10.0) : Container(),
                              Container(
                                height: 50,
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
                                    labelText: 'Votre email',
                                    suffixIcon: Icon(
                                      Icons.email,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? "Vous devez entrer un email" : null,
                                ),
                                decoration: BoxDecoration(
                                  color: PrimaryColor100,
                                  //  border: Border.all(color: PrimaryColorLight),
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),),
                              SizedBox(height: 10.0),
                              Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 20, right: 8),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  style: TextStyle(color: PrimaryColor),
                                  cursorColor: PrimaryColor,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(color: PrimaryColor300),
                                    labelText: !showSignIn ? 'Créer un mot de passe' : 'Mot de passe',
                                    suffixIcon: Icon(
                                      Icons.password,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  validator: (value) => value != null && value.length < 6
                                      ? "Vous devez entrer un mot de passe avec au-moins 6 caractères"
                                      : null,),
                                decoration: BoxDecoration(
                                  color: PrimaryColor100,
                                  //  border: Border.all(color: PrimaryColorLight),
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),),
                              SizedBox(height: 10.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => PrimaryColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red, width: .1)
                                        )
                                    )

                                ),
                                child: Text(
                                  showSignIn ? "Login" : "S'enregistrer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() == true) {
                                    setState(() => loading = true);
                                    var password = passwordController.value.text;
                                    var email = emailController.value.text;
                                    var name = nameController.value.text;

                                      dynamic result = showSignIn
                                          ? await _auth.signInWithEmailAndPassword(email, password)
                                          : await _auth.registerWithEmailAndPassword(name, email, password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = 'Impossible de se connecter';
                                      });
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red, fontSize: 15.0),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(showSignIn ? "Je n'ai pas encore de compte.\nCréer un compte" : "J'ai déjà un compte.\nJe me connecte",
                          style: TextStyle(fontSize: 15, color: PrimaryColor300), textAlign: TextAlign.center),
                      onPressed: () => toggleView(),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
