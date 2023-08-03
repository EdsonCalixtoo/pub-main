import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Signup/signup_screen.dart';
import 'package:flutter_instagram_feed_ui_redesign/components/already_have_an_account_acheck.dart';
import 'package:flutter_instagram_feed_ui_redesign/constants.dart';
import 'package:flutter_instagram_feed_ui_redesign/Screens/feed_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Login bem-sucedido - navegar para a próxima tela (FeedScreen)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FeedScreen()),
        );
      } catch (e) {
        // Tratar erros de login
        print("Erro ao fazer login: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kSecondColor,
            onSaved: (value) => _email = value!,
            decoration: InputDecoration(
              hintText: "Exemplo@gmail.com",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Por favor, digite seu e-mail";
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kSecondColor,
              onSaved: (value) => _password = value!,
              decoration: InputDecoration(
                hintText: "Senha",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Por favor, digite sua senha";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: _signIn,
            child: Text("Login".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
