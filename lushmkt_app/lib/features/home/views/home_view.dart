import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/core/theme/lush_design_system.dart';
import 'package:lushmkt_app/features/home/providers/home_providers.dart';
import 'package:lushmkt_app/routes/app_router.dart';
import 'package:lushmkt_app/services/storage_service.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _bannerPageController;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    super.dispose();
  }

  // Khớp nối điều hướng Tab bar dưới đáy
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Điều hướng khai báo GoRouter (mô phỏng hoặc thực tế)
    switch (index) {
      case 1:
        context.push('/orders');
        break;
      case 3:
        context.push('/wallet');
        break;
      case 4:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Nền Dark Space sâu thẳm
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00E5FF),
          backgroundColor: const Color(0xFF161B22),
          onRefresh: () async {
            // Làm mới các luồng thông tin Riverpod
            ref.invalidate(bannersProvider);
            ref.invalidate(categoriesProvider);
            ref.invalidate(hotServicesProvider);
            ref.invalidate(featuredProductsProvider);
            ref.invalidate(homeStatsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP ANNOUNCEMENT TICKER (Notification Ticker)
                _buildNotificationTicker(),
                const SizedBox(height: 16),

                // 2. HEADER: WELCOME MESSAGE
                _buildHeaderSection(),
                const SizedBox(height: 20),

                // 3. SLICK GLASS WALLET CARD (Wallet Card)
                _buildWalletCard(),
                const SizedBox(height: 20),

                // 4. ANIMATED ADVERTISING BANNERS (Banners)
                _buildBannerSlider(),
                const SizedBox(height: 24),

                // 5. SERVICE CATEGORIES GRID (Service Categories)
                _buildCategoriesSection(),
                const SizedBox(height: 24),

                // 6. STATISTICS GRID (Statistics)
                _buildStatsGrid(),
                const SizedBox(height: 24),

                // 7. POPULAR SERVICES & PRODUCTS (Popular Services)
                _buildPopularServicesSection(),
                const SizedBox(height: 24),

                _buildFeaturedProductsSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.04),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: const Color(0xFF0D0F14),
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard, color: Color(0xFF00E5FF)),
              label: 'Tổng quan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rocket_launch_outlined),
              activeIcon: Icon(Icons.rocket_launch, color: Color(0xFF00E5FF)),
              label: 'Dịch vụ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront, color: Color(0xFF00E5FF)),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF00E5FF)),
              label: 'Nạp tiền',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person, color: Color(0xFF00E5FF)),
              label: 'Tài khoản',
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Widget chạy chữ thông báo nổi bật (Notification Ticker)
  Widget _buildNotificationTicker() {
    final announcement = ref.watch(announcementTickerProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF7000FF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF7000FF).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.campaign_rounded,
            color: Color(0xFF00E5FF),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 18,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Text(
                      announcement,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Header chào mừng
  Widget _buildHeaderSection() {
    final storage = ref.watch(storageServiceProvider);
    final userProfile = storage.getUserProfile();
    final String username = userProfile?['name'] ?? 'Lush User';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào,',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              username.toUpperCase(),
              style: GoogleFonts.orbitron(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        // Nút Notification
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            context.push('/notifications');
          },
        ),
      ],
    );
  }

  /// 3. Ví Tiền Thủy Tinh Cao Cấp (Wallet Card)
  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF161B22).withOpacity(0.8),
            const Color(0xFF0D0F14).withOpacity(0.9),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF00E5FF).withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withOpacity(0.04),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Mesh vector phát sáng chéo
            Positioned(
              right: -50,
              bottom: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7000FF).withOpacity(0.12),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SỐ DƯ TÀI KHOẢN',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          letterSpacing: 1,
                        ),
                      ),
                      const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF00E5FF),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2,450,000 ₫',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOẠI THÀNH VIÊN',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'VIP PARTNER',
                            style: GoogleFonts.orbitron(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF7000FF),
                            ),
                          ),
                        ],
                      ),
                      
                      // Nút nạp tiền VietQR nhanh
                      ElevatedButton.icon(
                        onPressed: () {
                          context.push('/wallet');
                        },
                        icon: const Icon(Icons.add_rounded, size: 16, color: Colors.black),
                        label: const Text('NẠP TIỀN'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: GoogleFonts.orbitron(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. Slider Banner Quảng cáo
  Widget _buildBannerSlider() {
    final bannersAsync = ref.watch(bannersProvider);

    return bannersAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
      ),
      error: (err, stack) => const SizedBox.shrink(),
      data: (banners) {
        return Column(
          children: [
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _bannerPageController,
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('image/isometric-b2b-illustration.png'), // Duplicated static assets
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Glass Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner['title'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'CLICK ĐỂ KHÁM PHÁ NGAY',
                                style: GoogleFonts.orbitron(
                                  fontSize: 9,
                                  color: const Color(0xFF00E5FF),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentBannerIndex == index
                        ? const Color(0xFF00E5FF)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 5. MMO Categories (Facebook, Google, Proxy, VPS)
  Widget _buildCategoriesSection() {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DANH MỤC TÀI NGUYÊN',
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const Text('Lỗi tải danh mục.'),
          data: (categories) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                
                // Trỏ icon tương ứng
                IconData categoryIcon = Icons.rocket_launch_rounded;
                if (category['slug'] == 'facebook') {
                  categoryIcon = Icons.facebook_rounded;
                } else if (category['slug'] == 'gmail') {
                  categoryIcon = Icons.email_rounded;
                } else if (category['slug'] == 'proxy') {
                  categoryIcon = Icons.vpn_lock_rounded;
                } else if (category['slug'] == 'vps') {
                  categoryIcon = Icons.dns_rounded;
                }

                return InkWell(
                  onTap: () {
                    // Mở tab tương ứng
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161B22),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withOpacity(0.08),
                          ),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: const Color(0xFF00E5FF),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'] ?? '',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  /// 6. Thống kê Realtime (Statistics)
  Widget _buildStatsGrid() {
    final statsAsync = ref.watch(homeStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, s) => const SizedBox.shrink(),
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _buildStatItem(
                'ĐÃ CHI TIÊU',
                '1,850,000 ₫',
                Icons.trending_up_rounded,
                const Color(0xFF00E5FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatItem(
                'ĐƠN HOẠT ĐỘNG',
                '${stats['active_orders']} ĐƠN',
                Icons.autorenew_rounded,
                const Color(0xFF7000FF),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.08),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 7. Popular Services & Products
  Widget _buildPopularServicesSection() {
    final hotServicesAsync = ref.watch(hotServicesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DỊCH VỤ MMO PHỔ BIẾN',
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        hotServicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text('Lỗi tải dữ liệu.'),
          data: (services) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.02),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF00E5FF).withOpacity(0.08),
                        child: const Icon(Icons.flash_on_rounded, color: Color(0xFF00E5FF), size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Đơn tối thiểu: ${service['min_quantity']} • Giá/Sub: ${service['price_per_one']}đ',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/orders');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7000FF).withOpacity(0.2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.orbitron(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('MUA'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeaturedProductsSection() {
    final productsAsync = ref.watch(featuredProductsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SẢN PHẨM KHUYÊN DÙNG',
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => const Text('Lỗi tải dữ liệu.'),
          data: (products) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B22),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.02),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7000FF).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF7000FF), size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Kho: ${product['stock_quantity']} • Giá: ${product['price']}đ',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Thêm mua nhanh
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF).withOpacity(0.2),
                          foregroundColor: const Color(0xFF00E5FF),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.orbitron(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('KHO'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
