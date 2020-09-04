import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignInCards(title: "Login with Google"),
          SignInCards(title: "Login with Facebook"),
        ],
      ),
    );
  }
}

class SignInCards extends StatelessWidget {
  final String title;

  const SignInCards({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(color: Colors.black, fontSize: 18);

    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: MaterialButton(
        onPressed: () {},
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Center(
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
