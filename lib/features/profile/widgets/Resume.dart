import 'package:flutter/material.dart';

class ResumeItem extends StatelessWidget {
  final String name, date;
  final List<Widget> actions;

  const ResumeItem({
    super.key,
    required this.name,
    required this.date,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.article_outlined, color: Color(0xFF2563EB)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          // عرض الأيقونات المرسلة من الصفحة الأساسية
          ...actions,
        ],
      ),
    );
  }
}