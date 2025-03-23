import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/theme/theme_colors.dart';

class XpBar extends StatelessWidget {
  final int xpNeeded;
  final int xpObtained;
  const XpBar({super.key, required this.xpNeeded, required this.xpObtained});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double totalWidth = deviceWidth - 40;
    final double ratio =
        xpNeeded > 0 ? (xpObtained / xpNeeded).clamp(0.0, 1.0) : 0.0;
    final double progressWidth = totalWidth * ratio;

    // Determine text background: if center falls on progress (green), use white.
    // Otherwise, use context.secondary's luminance to decide.
    final Color textColor =
        progressWidth > (totalWidth / 2)
            ? Colors.white
            : context.secondary.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;

    return Center(
      child: Container(
        height: 20,
        width: totalWidth,
        decoration: BoxDecoration(
          color: context.secondary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Container(
              width: progressWidth,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Center(
              child: Text(
                "$xpObtained/$xpNeeded",
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
