import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFunc;
  final bool isLoading;
  AuthForm(this.submitFunc, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = " ";
  String _username = " ";
  String _password = " ";

  void onSaving() {
    bool _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      // this helps closing up the keyboard after the user clicks the button that calls the function 'onSaving()'
      FocusScope.of(context).unfocus();
      widget.submitFunc(_email.trim(), _password.trim(), _username.trim(), _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Card(
          margin: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(17.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (val) {
                      if (val!.isEmpty || !val.contains("@")) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val!,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a username.';
                        }
                        return null;
                      },
                      onSaved: (val) => _username = val!,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val!.isEmpty || val!.length < 7) {
                        return 'Password must be more than 7 characters.';
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val!,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if(widget.isLoading)
                    CircularProgressIndicator(),
                  if(!widget.isLoading)
                    RaisedButton(
                      color: Colors.pinkAccent,
                      child: Text(
                        _isLogin? "Sign in" : 'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: onSaving,
                    ),
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin
                            ? "Create an account"
                            : "Already have an account",
                        style: TextStyle(color: Colors.pinkAccent),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
