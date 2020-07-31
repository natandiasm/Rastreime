import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:rastreimy/models/user_model.dart';
import 'package:rastreimy/screens/signup_screen.dart';
import 'package:rastreimy/widgets/custom_button.dart';
import 'package:rastreimy/widgets/custom_input.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Get.theme.backgroundColor,
      appBar: AppBar(
        title: Text("Entrar"),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Criar conta",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: 400,
                  child: Get.isDarkMode
                      ? FlareActor("assets/flare/bg-login-dark.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          animation: "start")
                      : FlareActor("assets/flare/bg-login.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          animation: "start"),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 200,
                          child: Hero(
                              tag: "icon-login",
                              transitionOnUserGestures: true,
                              child: Get.isDarkMode
                                  ? Image.asset('assets/images/login-dark.png')
                                  : Image.asset('assets/images/login.png'))),
                      Form(
                        key: _formKey,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16.0),
                          children: <Widget>[
                            CustomInput(
                              controller: _emailController,
                              hintText: "E-mail",
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text.isEmpty || !text.contains("@"))
                                  return "E-mail inválido!";
                              },
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            CustomInput(
                              controller: _passController,
                              hintText: "Senha",
                              obscureText: true,
                              validator: (text) {
                                if (text.isEmpty || text.length < 6)
                                  return "Senha Inválida!";
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: () {
                                  if (_emailController.text.isEmpty) {
                                    Get.snackbar("Atenção",
                                        "Coloque primeiro seu e-mail para recupeção!",
                                        backgroundColor: Get.theme.cardColor,
                                        icon:
                                            Icon(LineAwesomeIcons.exclamation));
                                  } else {
                                      model.recoverPass(_emailController.text);
                                  }
                                },
                                child: Text(
                                  "Esqueci minha senha",
                                  textAlign: TextAlign.right,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            CustomButton(
                              child: Text(
                                "Entrar",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {}
                                model.signIn(
                                  email: _emailController.text,
                                  pass: _passController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Get.back();
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao Entrar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
