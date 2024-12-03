int calculateReadingTime(String content) {
  //rivan is a good boy
  final wordCount = content.split(RegExp(r'\s+')).length;
  final readingTime = wordCount / 225;
  return readingTime.ceil();
}
