import 'package:flutter/material.dart';

class iconButtonGen extends StatelessWidget {
  final Icon iconeName;
  final String link;
  final Color color;

  iconButtonGen({Key key, @required this.iconeName, @required this.link, @required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: iconeName,
      color: color,
      onPressed: () {
        Navigator.of(context).pushNamed(link);
      },
    );
  }
}