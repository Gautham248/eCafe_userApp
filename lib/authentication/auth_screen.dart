import 'package:flutter/material.dart';
import 'package:canteen_management_user/authentication/login.dart';
import 'package:canteen_management_user/authentication/registration.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
            ),
            automaticallyImplyLeading: false,
            title: const Text(
              "eCafe",
              style: TextStyle(
                  fontSize: 40, color: Colors.white, fontFamily: "Lobster"),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  //  icon: Icon(Icons.person, color: Colors.white),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),


                ),
                Tab(
                //  icon: Icon(Icons.person, color: Colors.white),
                  child: Text(
                     "Register",
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),


                ),
              ],
              indicatorColor: Colors.white38,
              indicatorWeight: 6,
            )),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white,
                Colors.orange,
              ])),
          child: const TabBarView(children: [
            LoginScreen(),
            RegisterScreen(),
          ]),
        ),
      ),
    );
  }
}
