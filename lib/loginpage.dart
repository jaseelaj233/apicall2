import 'package:apicall2/blankpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final String adminemail = "arun@gmail.com";
final String adminpassword = "123456";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  Future<void> _loginbutton() async {
    final String baseUrl = "https://musicapp.jissanto.com/api/login";
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BlankPage()),
        );
      } else {
        _showErrorMessage('Login failed. Please try again.');
      }
    } catch (e) {
      _showErrorMessage('An error occurred. Please check your connection.');
    }
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 162, 54, 54),
        key: globalKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login'),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: 'email', border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              height: 50,
              width: 100,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child:
                  ElevatedButton(onPressed: _loginbutton, child: Text('login')),
            ),
          ],
        ));
  }
}
