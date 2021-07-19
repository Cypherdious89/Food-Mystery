import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../custom_widgets/shadowButton.dart';
import '../Utils/authService.dart';

class EmailScreen extends StatefulWidget {
  EmailScreen({@required this.option});
  final String option;
  @override
  _EmailScreenState createState() => _EmailScreenState(option: option);
}

class _EmailScreenState extends State<EmailScreen> {
  _EmailScreenState({@required this.option});
  final String option;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  void deactivate() {
    super.deactivate();
    _emailController.dispose();
    _passwordController.dispose();
  }

  final AuthHandler authService = AuthHandler();
  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "$option failed!",
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: 20,
                color: Color(0xffab47bc),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Your $option for ${_emailController.text} failed!'),
                  Text('Please try again with this or different email.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: Color(0xffab47bc),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFFCF3EE),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.5, vertical: 5),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffab47bc))))
              : new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "$option here to write your food blog",
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 35.5,
                        color: Color(0xffab47bc),
                      ),
                    ),
                    new TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Username",
                        icon: FaIcon(FontAwesomeIcons.userCheck,
                            color: Color(0xFFab47bc), size: 22.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                        ),
                      ),
                    ),
                    new TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.vpn_key,
                            color: Color(0xFFab47bc), size: 22.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFab47bc), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(17.5)),
                        ),
                      ),
                    ),
                    new ShadowButton(
                      icon: Icon(Icons.edit,
                          color: Color(0xffab47bc), size: 24.5),
                      text: 'Let\'s write ',
                      textSize: 22.5,
                      width: 210,
                      height: 48,
                      press: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          createAlertDialog(context);
                          return;
                        } else {
                          if (option == "Sign Up") {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              bool res = await authService.createEmailUser(
                                  _emailController.text,
                                  _passwordController.text);
                              if (!res) {
                                setState(() {
                                  isLoading = false;
                                });
                                createAlertDialog(context);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushNamed(context, 'Regis_Screen');
                              }
                            } catch (error) {
                              setState(() {
                                isLoading = false;
                              });
                              createAlertDialog(context);
                            }
                          } else if (option == "Sign In") {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              bool res = await authService.signInEmailUser(
                                  _emailController.text,
                                  _passwordController.text);
                              if (!res) {
                                setState(() {
                                  isLoading = false;
                                });
                                createAlertDialog(context);
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    'Item_Screen', (route) => false);
                              }
                            } catch (error) {
                              setState(() {
                                isLoading = false;
                              });
                              createAlertDialog(context);
                            }
                          }
                        }
                      },
                    ),
                  ],
                )),
    );
  }
}

//{
//try{
//final newUser = await AuthService.createEmailUser(_emailController.text, _passwordController.text);
//if(newUser != null){
//
//}
//}
//catch(error){
//print(error);
//createAlertDialog(context);
//}
//}
//else if(option == "Sign In"){
//try{
//final existingUser = await AuthService.signInEmailuser(_emailController.text, _passwordController.text);
//if(existingUser != null){
//Navigator.push(context, MaterialPageRoute(builder: (context) => ItemScreen()));
//}
//}
//catch(error){
//print(error);
//createAlertDialog(context);
//}
//}
