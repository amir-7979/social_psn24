import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _singleton = StorageService._internal();
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  factory StorageService() => _singleton;

  StorageService._internal();

  Future<void> saveData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readData(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(key: key);
  }
}
