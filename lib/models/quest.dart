import 'package:isar/isar.dart';

part "quest.g.dart";

@Embedded()
class DayCompletion {
  // You can adjust the type to suit your needs (e.g., DateTime, String, etc.)
  late DateTime day;
  late int progress;
}

@Collection()
class Quest {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;
  late String type;
  late int goal;

  // Completed days
  List<DayCompletion> completions = [];
}
