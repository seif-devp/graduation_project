import 'package:flutter/material.dart';

import 'menu_item.dart';

class QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: [
        menuItem(Icons.search, "Search Jobs", Colors.blue),
        menuItem(Icons.upload, "Upload CV", Colors.green),
        menuItem(Icons.favorite, "Favorites", Colors.red),
        menuItem(Icons.calendar_today, "Interviews", Colors.purple),
      ],
    );
  }
}
