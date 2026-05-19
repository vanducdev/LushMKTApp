import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Quản lý Theme & Ngôn ngữ & Security
class SettingsState {
  final bool isDarkMode;
  final String language; // vi, en
  final bool isFaceIDEnabled;
  final bool isPINLockEnabled;

  SettingsState({
    this.isDarkMode = true,
    this.language = 'vi',
    this.isFaceIDEnabled = true,
    this.isPINLockEnabled = false,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? language,
    bool? isFaceIDEnabled,
    bool? isPINLockEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      isFaceIDEnabled: isFaceIDEnabled ?? this.isFaceIDEnabled,
      isPINLockEnabled: isPINLockEnabled ?? this.isPINLockEnabled,
    );
  }
}

class SettingsStateNotifier extends StateNotifier<SettingsState> {
  SettingsStateNotifier() : super(SettingsState());

  void toggleTheme() => state = state.copyWith(isDarkMode: !state.isDarkMode);
  void setLanguage(String lang) => state = state.copyWith(language: lang);
  void toggleFaceID() => state = state.copyWith(isFaceIDEnabled: !state.isFaceIDEnabled);
  void togglePINLock() => state = state.copyWith(isPINLockEnabled: !state.isPINLockEnabled);
}

final appSettingsProvider = StateNotifierProvider<SettingsStateNotifier, SettingsState>((ref) {
  return SettingsStateNotifier();
});

// 2. Quản lý Developer API Keys
class ApiKeyModel {
  final String id;
  final String key;
  final String date;

  ApiKeyModel({required this.id, required this.key, required this.date});
}

class ApiKeysNotifier extends StateNotifier<List<ApiKeyModel>> {
  ApiKeysNotifier() : super([]) {
    _loadDefaultKeys();
  }

  void _loadDefaultKeys() {
    state = [
      ApiKeyModel(id: 'LUSH-API-8910', key: 'lush_live_8910abcde1029384756', date: '01/05/2026'),
    ];
  }

  void generateNewKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newKey = ApiKeyModel(
      id: 'LUSH-API-${timestamp % 10000}',
      key: 'lush_live_${timestamp}xyz${(timestamp + 99).toRadixString(16)}',
      date: 'Hôm nay',
    );
    state = [...state, newKey];
  }

  void revokeKey(String id) {
    state = state.where((k) => k.id != id).toList();
  }
}

final apiKeysProvider = StateNotifierProvider<ApiKeysNotifier, List<ApiKeyModel>>((ref) {
  return ApiKeysNotifier();
});

// 3. Quản lý Thiết bị đã đăng nhập (Devices)
class DeviceSessionModel {
  final String id;
  final String deviceName;
  final String location;
  final String lastActive;
  final bool isCurrent;

  DeviceSessionModel({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });
}

class DevicesSessionNotifier extends StateNotifier<List<DeviceSessionModel>> {
  DevicesSessionNotifier() : super([]) {
    _loadDefaultDevices();
  }

  void _loadDefaultDevices() {
    state = [
      DeviceSessionModel(id: 'dev-1', deviceName: 'Apple iPhone 15 Pro Max', location: 'Hà Nội, Việt Nam', lastActive: 'Đang hoạt động', isCurrent: true),
      DeviceSessionModel(id: 'dev-2', deviceName: 'Windows PC - Google Chrome', location: 'TP. Hồ Chí Minh, Việt Nam', lastActive: '2 giờ trước'),
      DeviceSessionModel(id: 'dev-3', deviceName: 'MacBook Air - Safari', location: 'Đà Nẵng, Việt Nam', lastActive: '3 ngày trước'),
    ];
  }

  void terminateSession(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}

final devicesSessionProvider = StateNotifierProvider<DevicesSessionNotifier, List<DeviceSessionModel>>((ref) {
  return DevicesSessionNotifier();
});

// 4. Quản lý Hệ thống Referral (Tiếp thị liên kết)
class ReferralState {
  final String refLink;
  final int totalReferredUsers;
  final double totalEarnings;

  ReferralState({
    required this.refLink,
    required this.totalReferredUsers,
    required this.totalEarnings,
  });

  ReferralState copyWith({
    String? refLink,
    int? totalReferredUsers,
    double? totalEarnings,
  }) {
    return ReferralState(
      refLink: refLink ?? this.refLink,
      totalReferredUsers: totalReferredUsers ?? this.totalReferredUsers,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}

class ReferralNotifier extends StateNotifier<ReferralState> {
  ReferralNotifier() : super(ReferralState(
    refLink: 'https://lushmkt.com/ref/ducva99',
    totalReferredUsers: 12,
    totalEarnings: 300000.0,
  ));

  /// Giả lập phát sinh người dùng mới nạp thẻ qua link giới thiệu
  void simulateNewReferral() {
    state = state.copyWith(
      totalReferredUsers: state.totalReferredUsers + 1,
      totalEarnings: state.totalEarnings + 25000.0, // Nhận thêm hoa hồng 25k VND!
    );
  }
}

final referralProvider = StateNotifierProvider<ReferralNotifier, ReferralState>((ref) {
  return ReferralNotifier();
});
