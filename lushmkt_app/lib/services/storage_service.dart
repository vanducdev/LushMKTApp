import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider cho StorageService quản lý bộ nhớ cục bộ Hive + SharedPreferences
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService phải được khởi tạo trước trong hàm main()');
});

class StorageService {
  final SharedPreferences _sharedPrefs;
  
  // Khởi tạo các box tên phân vùng Hive
  static const String userBoxName = 'user_data_box';
  static const String cacheBoxName = 'app_cache_box';

  StorageService(this._sharedPrefs);

  /// Khởi tạo Hive và SharedPreferences
  static Future<StorageService> init() async {
    // 1. Khởi tạo Hive Flutter
    await Hive.initFlutter();
    
    // Mở sẵn các Box cơ bản của Hive để đọc ghi lập tức
    await Hive.openBox(userBoxName);
    await Hive.openBox(cacheBoxName);
    
    // 2. Khởi tạo SharedPreferences
    final sharedPrefs = await SharedPreferences.getInstance();
    return StorageService(sharedPrefs);
  }

  // ==========================================
  // HIVE API: HỖ TRỢ ĐỌC/GHI NO-SQL TỐC ĐỘ CAO
  // ==========================================

  Box get _userBox => Hive.box(userBoxName);
  Box get _cacheBox => Hive.box(cacheBoxName);

  /// Ghi dữ liệu Object vào Hive Cache
  Future<void> cacheData(String key, dynamic value) async {
    await _cacheBox.put(key, value);
  }

  /// Đọc dữ liệu Object từ Hive Cache
  dynamic getCachedData(String key) {
    return _cacheBox.get(key);
  }

  /// Xóa Hive Cache theo Key
  Future<void> clearCacheKey(String key) async {
    await _cacheBox.delete(key);
  }

  /// Ghi thông tin User Profile vào User Box
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    await _userBox.put('profile', profile);
  }

  /// Lấy thông tin User Profile
  Map<String, dynamic>? getUserProfile() {
    final raw = _userBox.get('profile');
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }

  // ==========================================
  // SHARED PREFERENCES: QUẢN LÝ THIẾT LẬP CƠ BẢN
  // ==========================================

  /// Ghi String đơn giản vào Preferences (vd: Auth Token)
  Future<bool> setString(String key, String value) async {
    return await _sharedPrefs.setString(key, value);
  }

  /// Đọc String từ Preferences
  String? getString(String key) {
    return _sharedPrefs.getString(key);
  }

  /// Ghi Boolean đơn giản (vd: dark_mode)
  Future<bool> setBool(String key, bool value) async {
    return await _sharedPrefs.setBool(key, value);
  }

  /// Đọc Boolean từ Preferences
  bool? getBool(String key) {
    return _sharedPrefs.getBool(key);
  }

  /// Xóa sạch mọi dữ liệu cục bộ khi người dùng Logout
  Future<void> clearAll() async {
    await _userBox.clear();
    await _cacheBox.clear();
    await _sharedPrefs.clear();
  }
}
