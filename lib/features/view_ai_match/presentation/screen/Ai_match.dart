import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AiMatch extends StatelessWidget {
  final double score;
  final List<String> matchedSkills;
  final List<String> missingSkills;

  const AiMatch({
    super.key,
    required this.score,
    required this.matchedSkills,
    required this.missingSkills,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("AI Match Analysis", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.blue)),
              ],
            ),
            SizedBox(height: 20.h),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100.w, height: 100.w,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.blue.shade50,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Text("${score.toInt()}%", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            SizedBox(height: 10.h),
            const Text("Match Score", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 25.h),
            _buildSectionHeader(Icons.check_circle_outline, "Why You Match", Colors.green),
            _buildBulletPoint("Matched with ${matchedSkills.length} key requirements"),
            SizedBox(height: 15.h),
            _buildSectionHeader(Icons.check_circle_outline, "Matching Skills", Colors.green),
            Wrap(spacing: 8, children: matchedSkills.map((s) => _buildChip(s, Colors.green.shade50, Colors.green)).toList()),
            SizedBox(height: 15.h),
            _buildSectionHeader(Icons.cancel_outlined, "Missing Skills", Colors.red),
            Wrap(spacing: 8, children: missingSkills.map((s) => _buildChip(s, Colors.red.shade50, Colors.red)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(children: [Icon(icon, color: color, size: 20), SizedBox(width: 8.w), Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold))]);
  }

  Widget _buildBulletPoint(String text) {
    return Padding(padding: EdgeInsets.only(left: 28.w, top: 5.h), child: Row(children: [const Text("• "), Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp)))]));
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Chip(label: Text(label, style: TextStyle(color: textColor, fontSize: 11.sp)), backgroundColor: bgColor, side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)));
  }
}