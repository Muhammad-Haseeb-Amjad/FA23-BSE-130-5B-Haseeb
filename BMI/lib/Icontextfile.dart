import 'package:flutter/material.dart';
class repeatIcon extends StatelessWidget {
  repeatIcon({required this.icondata, required this.label});
  final IconData icondata;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:[
        Icon(
          icondata,
          size: 40.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(label,style: TextStyle(
            fontSize: 18.0,
            color: Color(0xFF8D8E98)
        ),)
      ],
    );
  }
}