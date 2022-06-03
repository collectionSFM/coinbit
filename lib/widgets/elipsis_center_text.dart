import 'package:flutter/material.dart';

class ElipsisCenterText extends StatelessWidget {

  final String text;

  final int ? firstLengthText;

  final int ? lastLengthText;

  final TextStyle ? textStyle;

  const ElipsisCenterText({Key? key, required this.text, this.textStyle, this.firstLengthText = 8, this.lastLengthText = 8}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var first8Address = text.substring(0, firstLengthText);
    var last8Address = text.substring(text.length - lastLengthText!);
    return Text('$first8Address...$last8Address', style: textStyle);
  }
}
