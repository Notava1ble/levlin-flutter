import 'package:isar/isar.dart';

part "settings.g.dart";

@Collection()
class Settings {
  Id id = Isar.autoIncrement;

  String theme = "light";
}
