import 'package:flutter/material.dart';

class CustomTextView extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;

  const CustomTextView({
    super.key,
    required this.text,
    this.fontSize = 16.0,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.center,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color?? Colors.black,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}