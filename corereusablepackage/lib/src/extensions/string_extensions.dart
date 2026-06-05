extension StringExt on String {
  String get capitalized =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase =>
      split(' ').map((w) => w.capitalized).join(' ');

  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  bool get isEmail =>
      RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(trim());

  bool get isPhone =>
      RegExp(r'^\+?[0-9\s\-]{7,15}$').hasMatch(trim());

  bool get isNumeric => double.tryParse(this) != null;

  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');

  String? get nullIfEmpty => isEmpty ? null : this;
}
