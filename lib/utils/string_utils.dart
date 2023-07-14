class StringUtils {

}

extension StringExtras on String {
  String get firstLetterCap {
    if (length > 0) {
      if (length > 1) {
        return '${this[0].toUpperCase()}${substring(1)}';
      }
      return this[0].toUpperCase();
    }
    return this;
  }
}