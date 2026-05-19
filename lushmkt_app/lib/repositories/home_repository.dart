import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lushmkt_app/core/providers/network_providers.dart';

// Provider quản lý HomeRepository dùng chung
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return HomeRepository(dio);
});

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  /// 1. Lấy danh sách banner quảng cáo
  Future<Response> getBanners() async {
    return await _dio.get('/home/banners');
  }

  /// 2. Lấy danh sách danh mục (Facebook, Google, Proxy, VPS)
  Future<Response> getCategories() async {
    return await _dio.get('/categories');
  }

  /// 3. Lấy danh sách dịch vụ bán chạy (Buff Like, Follow...)
  Future<Response> getHotServices() async {
    return await _dio.get('/services'); // Endpoint lấy tất cả services hoặc hot services
  }

  /// 4. Lấy danh sách sản phẩm nổi bật (Tài khoản VIA, Clone Gmail...)
  Future<Response> getFeaturedProducts() async {
    return await _dio.get('/products');
  }

  /// 5. Lấy chỉ số thống kê tổng quan của User (Đơn hàng chạy, Đã chi tiêu)
  Future<Response> getStats() async {
    // Với tài khoản đã login, lấy thống kê ví & lịch sử nhanh
    return await _dio.get('/transactions');
  }
}
