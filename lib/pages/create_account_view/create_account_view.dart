import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../core/services/snackbar_sevice.dart';
import '../../core/utils/shareddata.dart';
import '../../core/widegts/cutsom_textField.dart';

import '../home_view/home_view.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({super.key});

  static String routeName = "createAccount";

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  bool isVisiblePassword = false;
  bool isVisibleConfirmPassword = false;

  @override
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 120,
          title: const Text("Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              top: mediaQuery.height * 0.20, right: 20, left: 20),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    label: "Name",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "you must enter your name";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextFormField(
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    label: "Email",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "you must enter your name";
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
                    obscureText: !isVisiblePassword,
                    controller: passwordController,
                    label: "Password",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVisiblePassword = !isVisiblePassword;
                        });
                      },
                      child: isVisiblePassword == true
                          ? const Icon(Icons.visibility_off_outlined)
                          : const Icon(Icons.visibility_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "you must enter your password";
                      }
                      var regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (regex.hasMatch(value)) {
                        return "Enter valid password";
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
                      createAccount();
                    },
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        decoration: BoxDecoration(
                            color: const Color(0xFF9A1DDB),
                            borderRadius: BorderRadius.circular(6)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Create Account",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (formkey.currentState!.validate()) {
      try {
        EasyLoading.show();
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        ShareData.savedName(nameController.text);
        ShareData.savedEmail(emailController.text);
        DataUser dataUser =
            DataUser(email: emailController.text, name: nameController.text);

        EasyLoading.dismiss();
        SnackBarService.showSuccessMessage(
            "Your account has been created successfully");

        Navigator.pushReplacementNamed(context, HomeView.routeName,
            arguments: dataUser);
      } on FirebaseAuthException catch (ex) {
        if (ex.code == 'weak-password') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage("The password provided is too weak");

          print('The password provided is too weak.');
        } else if (ex.code == 'email-already-in-use') {
          EasyLoading.dismiss();
          SnackBarService.showErrorMessage(
              "The account already exists for that email");

          print('The account already exists for that email.');
        }
      } catch (ex) {
        print(ex);
      }
    }
  }
}
