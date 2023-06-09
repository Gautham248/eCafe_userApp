import 'package:canteen_management_user/global/global.dart';
import 'package:canteen_management_user/mainScreens/home_screen.dart';
import 'package:canteen_management_user/widgets/error_dialog.dart';
import 'package:canteen_management_user/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canteen_management_user/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      //login
      loginNow();
    } else {
      //error
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please enter email and password",
            );
          });
    }
  }

  loginNow() async {
    //error
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Verifying Credentials",
          );
        });

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      {
        //error
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: error.message.toString(),
              );
            });
      }
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection(("users"))
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", snapshot.data()!["email"]);
      await sharedPreferences!.setString("name", snapshot.data()!["name"]);
      await sharedPreferences!
          .setString("photoUrl", snapshot.data()!["photoUrl"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/login.png",
                height: 270,
              ),
            ),
          ),
          Form(
              child: Column(
            children: [
              CustomTextField(
                data: Icons.email,
                controller: emailController,
                hintText: "Email",
                isObscure: false,
                enabled: true,
              ),
              CustomTextField(
                data: Icons.lock,
                controller: passwordController,
                hintText: "Password",
                isObscure: true,
                enabled: true,
              ),
            ],
          )),
          ElevatedButton(
            onPressed: (() {
              formValidation();
            }),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
