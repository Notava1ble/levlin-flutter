import 'package:flutter/material.dart';
import 'package:levlin/theme/theme_colors.dart';

class XpBar extends StatelessWidget {
  final int xpNeeded;
  final int xpObtained;
  const XpBar({super.key, required this.xpNeeded, required this.xpObtained});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: 20,
        width: deviceWidth - 40,
        decoration: BoxDecoration(
          color: context.secondary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            Container(
              width: (deviceWidth - 40) * (xpObtained / xpNeeded),
              height: 20,
              color: context.tertiary,
            ),
          ],
        ),
      ),
    );
  }
}
