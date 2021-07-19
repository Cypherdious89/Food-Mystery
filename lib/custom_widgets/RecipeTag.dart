import 'package:flutter/material.dart';

class RecipeTag extends StatelessWidget {
  RecipeTag({@required this.tagName});
  final String tagName;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77.5,
      height: 30.0,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              tagName,
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12.5,
                color: const Color(0xffab47bc),
              ),
              textAlign: TextAlign.center,
            ),
          ]),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: const Color(0xfffcf3ee),
        border: Border.all(width: 1.0, color: const Color(0xffab47bc)),
      ),
    );
  }
}
