import 'package:isar/isar.dart';

part "quest.g.dart";

@Collection()
class Quest {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;
  late String type;
  late int goal;

  // Completed days
  late DateTime lastCompleted;
}
