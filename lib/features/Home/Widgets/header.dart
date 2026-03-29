import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Quick Actions.dart';
import 'info.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 40, 16, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff2F6FED), Color(0xff3E7BFA)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          UserInfo(),

          QuickActions(),
        ],
      ),
    );
  }
}
