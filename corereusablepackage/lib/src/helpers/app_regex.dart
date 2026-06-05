class AppRegex {
  AppRegex._();

  static final email = RegExp(r'^[\w\-.+]+@([\w-]+\.)+[\w-]{2,}$');
  static final phone = RegExp(r'^\+?[0-9\s\-]{7,15}$');
  static final url = RegExp(r'https?://[^\s]+');
  static final arabic = RegExp(r'[؀-ۿݐ-ݿ]');
  static final digitsOnly = RegExp(r'^[0-9]+$');
  static final lettersOnly = RegExp(r'^[a-zA-Z؀-ۿ\s]+$');
  static final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  static final username = RegExp(r'^[a-zA-Z0-9._]{3,30}$');
  static final noSpecialChars = RegExp(r'[^a-zA-Z0-9؀-ۿ\s]');

  static final strongPassword = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$',
  );

  static final mediumPassword = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$',
  );

  static final creditCard = RegExp(r'^\d{4}\s?\d{4}\s?\d{4}\s?\d{4}$');
  static final cvv = RegExp(r'^\d{3,4}$');
  static final ipAddress = RegExp(
    r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
  );
  static final hexColor = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

  static bool isEmail(String value) => email.hasMatch(value.trim());
  static bool isPhone(String value) => phone.hasMatch(value.trim());
  static bool isUrl(String value) => url.hasMatch(value.trim());
  static bool isArabic(String value) => arabic.hasMatch(value);
  static bool isDigits(String value) => digitsOnly.hasMatch(value);
  static bool isStrongPassword(String value) => strongPassword.hasMatch(value);
  static bool isUsername(String value) => username.hasMatch(value);
  static bool isHexColor(String value) => hexColor.hasMatch(value);

  static String extractDigits(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  static List<String> extractUrls(String text) =>
      url.allMatches(text).map((m) => m.group(0)!).toList();

  static List<String> extractEmails(String text) =>
      email.allMatches(text).map((m) => m.group(0)!).toList();
}
