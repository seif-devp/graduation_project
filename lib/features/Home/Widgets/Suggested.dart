import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Suggested for You",
          style: TextStyle(
            fontSize: 22, // 🔥 كبرناه
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("See all", style: TextStyle(color: Colors.blue,fontSize: 16)),
      ],
    );
  }
}