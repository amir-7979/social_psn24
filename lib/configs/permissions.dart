import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestStoragePermission() async {
  PermissionStatus status = await Permission.storage.request();

  if (status.isDenied) {
    // The user denied access, handle it appropriately
    // Maybe show a dialog explaining why you need this permission
  } else if (status.isPermanentlyDenied) {
    // The user permanently denied access, guide them to the app settings
    openAppSettings();
  }

  // Check if the permission is granted
  if (status.isGranted) {
    // You can now access storage for photos, videos, and audio files
  }
  return status;
}
