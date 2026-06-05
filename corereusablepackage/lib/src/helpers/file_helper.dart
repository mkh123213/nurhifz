class FileHelper {
  FileHelper._();

  static String formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String getExtension(String path) {
    final dot = path.lastIndexOf('.');
    if (dot == -1 || dot == path.length - 1) return '';
    return path.substring(dot + 1).toLowerCase();
  }

  static String getMimeType(String path) {
    final ext = getExtension(path);
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'json':
        return 'application/json';
      case 'txt':
        return 'text/plain';
      case 'html':
        return 'text/html';
      case 'zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }

  static bool isImage(String path) =>
      ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'].contains(getExtension(path));

  static bool isVideo(String path) =>
      ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(getExtension(path));

  static bool isAudio(String path) =>
      ['mp3', 'wav', 'aac', 'flac', 'ogg'].contains(getExtension(path));

  static bool isDocument(String path) =>
      ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'csv'].contains(getExtension(path));
}
