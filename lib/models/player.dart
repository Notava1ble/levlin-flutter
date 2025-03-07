import 'package:isar/isar.dart';

part 'player.g.dart';

@Collection()
class Player {
  Id id = Isar.autoIncrement;
  int level = 1;
  int xp = 0;
}
