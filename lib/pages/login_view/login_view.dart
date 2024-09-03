import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:whatsapp/pages/home_view/home_view.dart';

import '../../core/services/snackbar_sevice.dart';
import '../../core/utils/shareddata.dart';
import '../../core/widegts/cutsom_textField.dart';

import '../../main.dart';
import '../create_account_view/create_account_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static String routeName = "LoginView";

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passWordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/image/background_image.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 120,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            "Login",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: mediaQuery.height * 0.20, left: 20, right: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Welcome back !",
                    style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    label: "E-mail",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "you must enter your E-mail";
                      }
                      var regexp = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                      if (!regexp.hasMatch(value)) {
                        return "Invalid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextFormField(
                    obscureText: isVisible,
                    controller: passWordController,
                    label: "Password",
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        child: isVisible == true
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined)),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "you must enter your password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      login();
                    },
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        decoration: BoxDecoration(
                            color: Color(0xFF9A1DDB),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CreateAccount.routeName);
                    },
                    child: const Text(
                      "Or Create My Account",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        EasyLoading.show();
        ShareData.savedEmail(emailController.text);
        String? userName = prefs?.getString("name");
        DataUser dataUser =
            DataUser(email: emailController.text, name: userName ?? "");
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passWordController.text);
        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage("Your logged in successfully");
        Navigator.pushReplacementNamed(context, HomeView.routeName,
            arguments: dataUser);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage("No user found for that email");
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage(
              "Wrong password provided for that user");
        }
      }
    }
  }
}
