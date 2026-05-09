import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/service_order_view.dart';
import '../profile/profile_view.dart';
import '../products/product_purchase_view.dart';
import '../payment/deposit_view.dart';
import 'notifications_view.dart';
import '../../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = Get.put(HomeController());
  int _currentIndex = 0;

  // Bottom Navigation tabs pages mapping
  Widget _buildBody() {
    switch (_currentIndex) {
      case 1: // Services Tab
        return const ServiceOrderView();
      case 2: // Shop Tab (Default to ProductPurchaseView)
        return const ProductPurchaseView();
      case 3: // Orders (History / Support)
        return const DepositView();
      case 4: // Profile Tab
        return const ProfileView();
      default: // Home Dashboard Tab
        return _buildDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0D0F14),
          selectedItemColor: const Color(0xFF00E5FF),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Trang chủ'),
            BottomNavigationBarItem(icon: Icon(Icons.rocket_launch_outlined), label: 'Dịch vụ'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cửa hàng'),
            BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'Nạp tiền'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Tài khoản'),
          ],
        ),
      ),
    );
  }

  // Dashboard Page Content (Home Tab)
  Widget _buildDashboard() {
    return Stack(
      children: [
        Container(color: const Color(0xFF0D0F14)),
        
        // Glowing Neon Background Circle
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.12),
                  blurRadius: 90,
                ),
              ],
            ),
          ),
        ),

        SafeArea(
          child: RefreshIndicator(
            onRefresh: _controller.refreshData,
            color: const Color(0xFF00E5FF),
            backgroundColor: const Color(0xFF161B22),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. App Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: Color(0xFF161B22),
                              child: Text('L', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Xin chào,', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                Text(
                                  'LushDeveloper 🚀',
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Realtime notifications count badge
                        GestureDetector(
                          onTap: () => Get.to(() => const NotificationsView()),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161B22),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                                ),
                                child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF2D55),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // 2. Realtime Stats Grid
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'ONLINE LIVE',
                            '${_controller.onlineUsers.value} Users',
                            const Color(0xFF00E5FF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'HỆ THỐNG',
                            _controller.systemStatus.value,
                            Colors.green,
                          ),
                        ),
                      ],
                    )),
                  ),
                ),

                // 3. Banner Slider
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80'),
                        fit: BoxFit.cover,
                        opacity: 0.8,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KHUYẾN MÃI NẠP TIỀN 10%',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Áp dụng khi chuyển khoản VietQR tự động MB Bank',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // 4. Quick Services Categories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DANH MỤC DỊCH VỤ',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _controller.categories.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            final cat = _controller.categories[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF161B22),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.04)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D0F14),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.rocket_launch_outlined, color: Color(0xFF00E5FF), size: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat['name'],
                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${cat['count']} dịch vụ',
                                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Realtime Stats Card Helper
  Widget _buildStatCard(String label, String value, Color glowColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glowColor.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: glowColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
