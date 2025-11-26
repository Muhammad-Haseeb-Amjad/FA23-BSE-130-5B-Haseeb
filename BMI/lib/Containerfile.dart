import 'package:flutter/material.dart';
class repeatcontainer extends StatelessWidget {
  repeatcontainer({required this.colors, this.cardWidget,this.onPressed});
  final Color colors;
  final Widget? cardWidget;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: cardWidget,
        decoration: BoxDecoration(
          color: colors,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}