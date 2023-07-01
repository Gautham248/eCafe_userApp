import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
Future passwordReset() async{
   try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
     showDialog(context: context, builder: (context)
     {
       return AlertDialog(
         content: Text("Password reset link sent, check your email") ,
       );
     });

   } on FirebaseAuthException catch(e)
  {
    print(e);
    showDialog(context: context, builder: (context)
    {
      return AlertDialog(
        content: Text(e.message.toString()) ,
      );
    });
  }
}
  // void _submitEmail() {
  //   final String email = emailController.text;
  //   // Do something with the email (e.g., send it to the server)
  //   print('Submitted email: $email');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.cyan],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: ()
                  {
                    passwordReset();

                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: ()
                  {
                 Navigator.pop(context);

                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
