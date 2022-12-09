import 'dart:html';

import 'package:flutter/material.dart';
import 'package:grp_6_bicycle/all_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            const FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 62, 33),
                    ),
                  ),
                  labelText: 'Login',
                ),
              ),
            ),
            const FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 80, 62, 33),
                    ),
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const AllRoutes();
                    },
                  ),
                );
              },
              child: const Text('login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Need an account ? '),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AllRoutes();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Color.fromARGB(255, 51, 102, 204),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const FractionallySizedBox(
                widthFactor: 0.7,
                child: LoginRegisterInput(name: 'name', obscure: false)),
          ],
        ),
      ),
    );
  }
}

class LoginRegisterInput extends StatelessWidget {
  final bool obscure;
  final String name;
  const LoginRegisterInput(
      {super.key, required this.name, required this.obscure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 80, 62, 33),
          ),
        ),
        labelText: name,
      ),
    );
    ;
  }
}
