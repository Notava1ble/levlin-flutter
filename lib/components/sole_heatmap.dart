import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:levlin/theme/theme_colors.dart';

class SoleHeatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final DateTime startDate;
  final int itemGoal;
  const SoleHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
    required this.itemGoal,
  });

  @override
  Widget build(BuildContext context) {
    // Compute dynamic colorsets based on progress relative to itemGoal
    final baseGreen = HSLColor.fromColor(Colors.green);
    final Map<int, Color> dynamicColorSets = {
      1:
          HSLColor.fromAHSL(
            1.0,
            baseGreen.hue,
            baseGreen.saturation,
            0.8,
          ).toColor(),
    };
    for (double t in [0.2, 0.4, 0.6, 0.8, 1.0]) {
      int thresholdValue = (itemGoal * t).ceil();
      // Lightness varies from 0.3 to 0.7 as t increases
      double lightness = 0.8 - (0.3 * t);
      dynamicColorSets[thresholdValue] =
          HSLColor.fromAHSL(
            1.0,
            baseGreen.hue,
            baseGreen.saturation,
            lightness,
          ).toColor();
    }

    // Calculate an adjusted start date that aligns to the week's start (Monday)
    final adjustedStartDate = startDate.subtract(
      Duration(days: startDate.weekday - 1),
    );

    // New logic: Compute the end date (last week Saturday) and shift datasets accordingly.
    final today = DateTime.now();
    final currentWeekStart = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: today.weekday - 1));
    final lastWeekSaturday = currentWeekStart.subtract(Duration(days: 2));
    final offsetDays = today.difference(lastWeekSaturday).inDays;
    final shiftedDatasets = datasets?.map(
      (date, count) =>
          MapEntry(date.subtract(Duration(days: offsetDays)), count),
    );

    return HeatMap(
      startDate: adjustedStartDate,
      endDate: lastWeekSaturday, // end date changed to last week Saturday
      datasets: shiftedDatasets, // use shifted dataset dates
      colorMode: ColorMode.color,
      defaultColor: context.secondary,
      textColor: Colors.white,
      showColorTip: false,
      showText: false,
      scrollable: true,
      size: 14,
      margin: EdgeInsets.all(1.2),
      borderRadius: 2,
      fontSize: 0,
      colorsets: dynamicColorSets, // changed here
    );
  }
}
