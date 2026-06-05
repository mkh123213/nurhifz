import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<ShareResult> shareText(String text, {String? subject}) {
    return Share.share(text, subject: subject);
  }

  Future<ShareResult> shareFile(XFile file, {String? text}) {
    return Share.shareXFiles([file], text: text);
  }

  Future<ShareResult> shareFiles(List<XFile> files, {String? text}) {
    return Share.shareXFiles(files, text: text);
  }
}
