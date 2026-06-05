extension ListExt<T> on List<T> {
  T? get safeFirst => isEmpty ? null : first;
  T? get safeLast => isEmpty ? null : last;

  T? safeElementAt(int index) =>
      (index >= 0 && index < length) ? this[index] : null;

  Map<K, List<T>> groupBy<K>(K Function(T) keyOf) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = keyOf(item);
      (map[key] ??= []).add(item);
    }
    return map;
  }

  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  List<T> unique([Object Function(T)? keyOf]) {
    final seen = <Object>{};
    return where((item) {
      final key = keyOf != null ? keyOf(item) : item as Object;
      return seen.add(key);
    }).toList();
  }

  List<T> sortedBy<K extends Comparable>(K Function(T) keyOf) {
    return [...this]..sort((a, b) => keyOf(a).compareTo(keyOf(b)));
  }

  List<T> sortedByDescending<K extends Comparable>(K Function(T) keyOf) {
    return [...this]..sort((a, b) => keyOf(b).compareTo(keyOf(a)));
  }
}
