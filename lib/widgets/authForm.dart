import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth.dart';
import 'package:flutter_app/widgets/buttonDesign.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Please enter your mail';
                  }
                },
                onSaved: (value) {
                  // >> to save email
                  _authData['email'] = value;
                },
                decoration: InputDecoration(prefixIcon: Icon(Icons.person),
                    labelText: 'Please enter your email', hintText: 'example@mail.com'),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Please enter your password',prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Please enter your password!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
              ),
              SizedBox(
                height: 15,
              ),
              if (_authMode == AuthMode.Signup)
                TextFormField(
                  enabled: _authMode == AuthMode.Signup,
                  decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  validator: _authMode == AuthMode.Signup
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        }
                      : null,
                ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  //  padding:
                     //   EdgeInsets.symmetric(horizontal: 160.0, vertical: 10.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                ),
              SizedBox(height: 5),
              FlatButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onPressed: _switchAuthMode,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ));
  }
}
