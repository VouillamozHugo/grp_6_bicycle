import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/login/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final brown = const Color.fromARGB(255, 80, 62, 33);
  final orange = const Color.fromARGB(255, 212, 134, 34);
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
            //Text(loginMessage, style: const TextStyle(color: Colors.red)),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
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
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
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
            FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
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
                        debugPrint('Outlined button');
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
}

Text textCreator(String title, var color) {
  return Text(
    title,
    style: TextStyle(color: color, fontWeight: FontWeight.w500),
  );
}
