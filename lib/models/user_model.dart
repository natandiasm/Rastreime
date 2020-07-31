import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user;
      await _saveUserData(userData);
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      isLoading = false;
      print(e);
      notifyListeners();
      onFail();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user;
      String FCM = await FirebaseMessaging().getToken();
      _updateUserData({'tokenFCM': FCM});
      await _loadCurrentUser();

      isLoading = false;
      onSuccess();
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  void recoverPass(String email, {@required VoidCallback onError}) {
    _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              Get.snackbar("Confira seu e-mail",
                  "Será enviado um e-mail para você com as instruções",
                  backgroundColor: Get.theme.cardColor,
                  duration: Duration(seconds: 8))
            })
        .catchError((e) {
      print(e.code);
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          Get.snackbar(
              "E-mail inválido", "Confirme se você digitou o e-mail correto",
              backgroundColor: Get.theme.cardColor,
              duration: Duration(seconds: 8));
          break;
        case "ERROR_USER_NOT_FOUND":
          Get.snackbar(
              "Usuário não encontrado", "Esse email não está cadastrado",
              backgroundColor: Get.theme.cardColor,
              duration: Duration(seconds: 8));
          break;
      }
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  Future<Null> _updateUserData(Map<String, dynamic> userData) async {
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .updateData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
