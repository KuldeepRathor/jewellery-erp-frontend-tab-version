class StringUtils {
  static String restrictLength(String input, int maxLenght) {
    if (input.length <= maxLenght) return input;
    return input.substring(0, maxLenght);
  }

  static String leftAlign(String text, int lineWidth) {
    if (text.length > lineWidth) return text.substring(0, lineWidth);
    return text.padRight(lineWidth);
  }

  static String trimDecimal(String? value) {
    if (value == null) return '';
    return value.endsWith('.00') ? value.replaceAll('.00', '') : value;
  }
}
