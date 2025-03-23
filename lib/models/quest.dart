import 'package:isar/isar.dart';

part "quest.g.dart";

@Embedded()
class DayCompletion {
  late DateTime day;
  late int progress;
}

@Collection()
class Quest {
  // Quest id
  Id id = Isar.autoIncrement;

  // Quest name
  late String name;
  late String type;
  late int goal;

  // Completed days
  List<DayCompletion> completions = [];
}
