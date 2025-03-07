int getNeededXpFromLevel(int level) {
  if (level < 1) {
    return 0;
  } else if (level <= 15) {
    return level * (level + 7);
  } else if (level <= 30) {
    return (2.5 * level * level - 38 * level + 337.5).floor();
  } else {
    return (4.5 * level * level - 158 * level + 2137.5).floor();
  }
}
