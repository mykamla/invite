import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myliveevent/theme/my_theme.dart';
import 'package:myliveevent/widget/loading.dart';
import 'package:myliveevent/ui/profil/connection/services/authentication.dart';
import 'package:myliveevent/widget/text_divider/src/text_divider.dart';

class AuthenticateScreen extends StatefulWidget {
  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {

  final AuthenticationService _auth = AuthenticationService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final pageController = PageController();
  int selectedIndex = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      nameController.text = '';
      passwordController.text = '';
      confirmPasswordController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print("@@-XX");
      } else {
        print("@@-YY");
        Navigator.pushReplacementNamed(context, '/my_bottom_menu', arguments:  {
          'user': user,
          'uid': user.uid
        });
       }
    });

    return loading
        ? Scaffold(backgroundColor: PrimaryColor, body: Loading(iconColor: Colors.green,),)
        : Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PrimaryColor,
        leading: selectedIndex != 0 ? IconButton(
          icon: Icon(CupertinoIcons.back, size: 30),
          onPressed: () {
            pageController.animateToPage(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              );
            //  selectedIndex = 0;
            //  setState(() {});
            toggleView();
          },
        ) : SizedBox(),
      ),
            backgroundColor: PrimaryColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                  children: [
                    Expanded(
                      flex: selectedIndex == 0 ? 2 : 1,
                        child: Container(
                          child: FlutterLogo(size: 150),
                        ),),
                    Expanded(
                      flex: 1,
                        child: selectedIndex == 0
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bienvenue",
                                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                            Text("Si vous avez déjà un compte, identifiez-vous",
                                style: TextStyle(color: Colors.white, fontSize: 15)),
                          ],
                        ) : SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: ExpandablePageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: pageController,
                        onPageChanged: (value) {
                          selectedIndex = value;
                          setState(() {});
                        },
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 30, right: 30),
                                width: double.infinity,
                                height: 50,
                                child:  ElevatedButton(
                                  onPressed: () {
                                    pageController.animateToPage(1,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    selectedIndex = 1;
                                    setState(() {});
                                  },
                                  child: Text("S'identifier",
                                      style: TextStyle(fontSize: 18, color: PrimaryColor), textAlign: TextAlign.center),

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
                                ),
                              ),
                              SizedBox(height: 30,),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: TextDivider.horizontal(
                                        color: PrimaryColor100,
                                        text: Text(
                                            'OU',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              background: Paint()
                                                ..color = PrimaryColor100!
                                                ..strokeWidth = 20
                                                ..strokeJoin = StrokeJoin.round
                                                ..strokeCap = StrokeCap.round
                                                ..style = PaintingStyle.stroke,
                                              color: Colors.white,
                                            ))
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 30,),
                              Container(
                                margin: EdgeInsets.only(left: 30, right: 30),
                                width: double.infinity,
                                height: 50,
                                child:  ElevatedButton(
                                  onPressed: () {
                                    pageController.animateToPage(2,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                    selectedIndex = 2;
                                    setState(() {});
                                  },
                                  child: Text("S'inscrire",
                                      style: TextStyle(fontSize: 18, color: PrimaryColor), textAlign: TextAlign.center),
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                      backgroundColor: MaterialStateColor.resolveWith((states) => PinkColor),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            //side: BorderSide(color: Colors.red, width: .1)
                                          )
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Expanded(
                                flex: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                                  child: Form(
                                    key: selectedIndex != 1 ? Key("1") : _formKey,
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
                                        SizedBox(height: 10.0),
                                        //password
                                        Container(
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
                                              labelText: 'Mot de passe',
                                              suffixIcon: Icon(
                                                CupertinoIcons.lock_circle,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            ),
                                            validator: (value) => value != null && value.length < 6
                                                ? "Mot de passe requis (au-moins 6 caractères)"
                                                : null,),
                                          decoration: BoxDecoration(
                                            color: PrimaryColor100,
                                            //  border: Border.all(color: PrimaryColorLight),
                                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          ),),
                                        SizedBox(height: 10.0),
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
                                            "S'dentifier",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState?.validate() == true) {
                                              setState(() => loading = true);
                                              var password = passwordController.value.text;
                                              var email = emailController.value.text;

                                              dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                                              if (result == null) {
                                                setState(() {
                                                  loading = false;
                                                  error = 'Impossible de se connecter';
                                                });
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
                          Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      child: Form(
                        key: selectedIndex != 2 ? Key("2") : _formKey,
                        child: Column(
                          children: [
                            Container(
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
                                    CupertinoIcons.person_crop_circle,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                ),
                                validator: (value) =>
                                value == null || value.isEmpty ? "Entrer un nom" : null,
                              ),
                              decoration: BoxDecoration(
                                color: PrimaryColor100,
                                //  border: Border.all(color: PrimaryColorLight),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),),
                            SizedBox(height: 10.0),
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
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 8),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(color: PrimaryColor),
                                cursorColor: PrimaryColor,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: PrimaryColor300),
                                  labelText: 'Créer un mot de passe',
                                  suffixIcon: Icon(
                                    CupertinoIcons.lock_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                validator: (value) => value != null && value.length < 6
                                    ? "Mot de passe (au-moins 6 caractères)"
                                    : null,),
                              decoration: BoxDecoration(
                                color: PrimaryColor100,
                                //  border: Border.all(color: PrimaryColorLight),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 8),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                style: TextStyle(color: PrimaryColor),
                                cursorColor: PrimaryColor,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: PrimaryColor300),
                                  labelText: 'Confirmer le mot de passe',
                                  suffixIcon: Icon(
                                    CupertinoIcons.lock_circle,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                validator: (value) => passwordController.text != confirmPasswordController.text
                                    ? "Mot de passe non identique"
                                    : null,),
                              decoration: BoxDecoration(
                                color: PrimaryColor100,
                                //  border: Border.all(color: PrimaryColorLight),
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              ),),
                            SizedBox(height: 10.0),
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                                    backgroundColor: MaterialStateColor.resolveWith((states) => PinkColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          //side: BorderSide(color: Colors.red, width: .1)
                                        )
                                    )
                                ),
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() == true) {
                                  setState(() => loading = true);
                                  var password = passwordController.value.text;
                                  var email = emailController.value.text;
                                  var name = nameController.value.text;

                                  dynamic result = await _auth.registerWithEmailAndPassword(name, email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Impossible de se connecter';
                                    });
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
                        ],
                      ),
                    ),

                  ],
                ),
            ),

          );
  }
}
