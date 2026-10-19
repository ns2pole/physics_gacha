/// 数値欄。カーソル位置に記号を差し込む。
class ExpressionEditor {
  String text = '';
  int cursor = 0;

  void insert(String value) {
    text = text.replaceRange(cursor, cursor, value);
    cursor += value.length;
  }

  void backspace() {
    if (cursor == 0) return;
    text = text.replaceRange(cursor - 1, cursor, '');
    cursor -= 1;
  }

  /// `3.0` のうしろなら `3.0×10^|`、空欄なら `10^|`。指数は続けて打つ。
  void insertPowerOfTen() {
    final before = text.substring(0, cursor);
    final needsTimes = before.isNotEmpty && !before.endsWith('×');
    insert(needsTimes ? '×10^' : '10^');
  }

  void clear() {
    text = '';
    cursor = 0;
  }

  /// 先頭の符号を付けたり外したりする。
  void toggleSign() {
    final negative = text.startsWith('-') || text.startsWith('−');
    if (negative) {
      text = text.substring(1);
      cursor = cursor == 0 ? 0 : cursor - 1;
      return;
    }
    text = '-$text';
    cursor += 1;
  }
}
