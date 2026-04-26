import 'package:flutter/material.dart';

Widget menuItem(IconData icon, String text, Color color) {
  return Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 4, 3, 92).withOpacity(0.3),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    ),
  );
}
