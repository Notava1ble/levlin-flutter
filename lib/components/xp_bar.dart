import 'package:flutter/material.dart';
import 'package:levlin/theme/theme_colors.dart';

class XpBar extends StatelessWidget {
  final int xpNeeded;
  final int xpObtained;
  const XpBar({super.key, required this.xpNeeded, required this.xpObtained});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.secondary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity * (xpObtained / xpNeeded),
              height: 20,
              color: context.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
