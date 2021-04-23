import 'package:flutter/material.dart';

class buttonGen extends StatelessWidget {
  final Color colorText;
  final Color colorCase;
  final String buttonText;
  final Widget link;

  buttonGen(
      {Key key,
      @required this.colorText,
      @required this.colorCase,
      @required this.buttonText,
      @required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: colorCase,
      child: Text(
        buttonText,
        style: TextStyle(
          color: colorText,

        ),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => link));
      },
    );
  }
}

class roundButtonGen extends StatelessWidget {
  final Color colorText;
  final Color colorCase;
  final String buttonText;
  final Widget link;

  roundButtonGen(
      {Key key,
      @required this.colorText,
      @required this.colorCase,
      @required this.buttonText,
      @required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => link));
        },
        child: Text(
          buttonText,
          style: TextStyle(
              color: colorText,
              fontSize: 30),
        ),
        height: 40.0,
        color: colorCase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ));
  }
}

class imageButtonGen extends StatelessWidget {
  final Widget link;
  final String img;

  imageButtonGen({Key key, @required this.link, @required this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => link));
      },
      child: InkWell(
        child: Image.asset(
          img,
          width: 50,
        ),
      ),
    );
  }
}

class buttonAppBar extends StatelessWidget {
  final String buttonText;
  final Widget link;

  buttonAppBar({Key key, @required this.buttonText, @required this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonGen(
        colorText: Colors.redAccent,
        colorCase: Colors.blueAccent,
        buttonText: buttonText,
        link: link);
  }
}