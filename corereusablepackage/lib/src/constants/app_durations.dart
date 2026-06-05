class AppDurations {
  AppDurations._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const slower = Duration(milliseconds: 800);

  static const pageTransition = Duration(milliseconds: 250);
  static const shimmer = Duration(milliseconds: 1200);
  static const toast = Duration(seconds: 2);
  static const debounce = Duration(milliseconds: 400);
  static const snackBar = Duration(seconds: 3);
}
