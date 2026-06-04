import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestCamera() => _request(Permission.camera);
  Future<bool> requestPhotos() => _request(Permission.photos);
  Future<bool> requestStorage() => _request(Permission.storage);
  Future<bool> requestMicrophone() => _request(Permission.microphone);
  Future<bool> requestLocation() => _request(Permission.location);
  Future<bool> requestNotification() => _request(Permission.notification);

  Future<bool> checkCamera() => Permission.camera.isGranted;
  Future<bool> checkPhotos() => Permission.photos.isGranted;
  Future<bool> checkStorage() => Permission.storage.isGranted;
  Future<bool> checkMicrophone() => Permission.microphone.isGranted;
  Future<bool> checkLocation() => Permission.location.isGranted;
  Future<bool> checkNotification() => Permission.notification.isGranted;

  Future<bool> _request(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<void> openSettings() => openAppSettings();
}
