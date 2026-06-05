import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  Future<bool> makeCall(String phoneNumber) {
    return openUrl('tel:$phoneNumber');
  }

  Future<bool> sendSms(String phoneNumber, {String? body}) {
    final uri = body != null
        ? 'sms:$phoneNumber?body=${Uri.encodeComponent(body)}'
        : 'sms:$phoneNumber';
    return openUrl(uri);
  }

  Future<bool> sendEmail({
    required String to,
    String? subject,
    String? body,
  }) {
    final params = <String, String>{};
    if (subject != null) params['subject'] = subject;
    if (body != null) params['body'] = body;
    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final uri = query.isNotEmpty ? 'mailto:$to?$query' : 'mailto:$to';
    return openUrl(uri);
  }

  Future<bool> openWhatsApp(String phoneNumber, {String? message}) {
    final encoded = message != null ? Uri.encodeComponent(message) : '';
    final url = encoded.isNotEmpty
        ? 'https://wa.me/$phoneNumber?text=$encoded'
        : 'https://wa.me/$phoneNumber';
    return openUrl(url);
  }

  Future<bool> openMap({required double lat, required double lng}) {
    return openUrl('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
  }
}
