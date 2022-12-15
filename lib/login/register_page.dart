import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/all_routes.dart';
import 'package:grp_6_bicycle/login/login_message_state.dart';
import 'package:grp_6_bicycle/login/login_page.dart';
import 'login_message_state.dart';
import 'login_input_validation.dart';

import '../DB/UserDB.dart';
import '../DTO/UserDTO.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final brown = const Color.fromARGB(255, 80, 62, 33);
  final orange = const Color.fromARGB(255, 212, 134, 34);
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordConfirmationTextController = TextEditingController();
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  String emailMessage = "";
  String passwordMessage = "";
  String namesMessage = "";

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/logo6.png',
              height: 120,
              width: queryData.size.width * 0.7,
            ),
            Text(namesMessage, style: const TextStyle(color: Colors.red)),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: firstNameTextController,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Firstname',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: lastNameTextController,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Lastname',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            Text(emailMessage, style: const TextStyle(color: Colors.red)),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: emailTextController,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            Text(passwordMessage, style: const TextStyle(color: Colors.red)),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: passwordTextController,
                obscureText: true,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                controller: passwordConfirmationTextController,
                obscureText: true,
                style: TextStyle(
                  color: brown,
                ),
                cursorColor: orange,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: orange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: brown,
                      ),
                    ),
                    labelText: 'Confirm Password',
                    labelStyle:
                        TextStyle(color: brown, fontWeight: FontWeight.w500)),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: queryData.size.width * 0.3,
                    height: queryData.size.width * 0.08,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: brown)),
                      onPressed: () {
                        Navigator.of(context).pop(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const LoginPage();
                            },
                          ),
                        );
                      },
                      child: textCreator('Go to login', orange),
                    ),
                  ),
                  SizedBox(
                    width: queryData.size.width * 0.3,
                    height: queryData.size.width * 0.08,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: brown)),
                      onPressed: () {
                        signUp();
                      },
                      child: textCreator('Create an account', orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  signUp() async {
    try {
      if (!validateInputs()) {
        return;
      }
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      UserDTO user = buildUserFromFields();
      //create a user using the uid generated by Firebase authentication
      UserDB().createUser(userCredential.user?.uid as String, user);
      redirectUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          passwordMessage = "A stronger password is required.";
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          emailMessage = "Email is already in use.";
        });
      }
    } catch (e) {
      setState(() {
        emailMessage =
            "A technical error occured. Are you connected to the internet?";
      });
    }
  }

  bool validateInputs() {
    //the input validation class contains all validation logic
    InputValidation validator = InputValidation();

    //the login message state have a text and a value
    //they are container for the error message and the input validity
    LoginMessageState emailState =
        validator.validatEmail(emailTextController.text);
    LoginMessageState passwordState = validator.validatePassword(
        passwordTextController.text, passwordConfirmationTextController.text);
    LoginMessageState namesState = validator.validateNames(
        firstNameTextController.text, lastNameTextController.text);

    //write all errors on inputs
    setState(() {
      emailMessage = emailState.message;
      passwordMessage = passwordState.message;
      namesMessage = namesState.message;
    });

    return (namesState.result && emailState.result && passwordState.result);
  }

  UserDTO buildUserFromFields() {
    return UserDTO(
        firstName: firstNameTextController.text,
        lastName: lastNameTextController.text,
        userType: 1,
        favoriteRoutes: []);
  }

  void redirectUser() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const AllRoutes();
        },
      ),
    );
  }
}

Text textCreator(String title, var color) {
  return Text(
    title,
    style: TextStyle(color: color, fontWeight: FontWeight.w500),
  );
}
