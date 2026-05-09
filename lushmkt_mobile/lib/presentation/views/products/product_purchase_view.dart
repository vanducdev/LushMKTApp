import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../controllers/cart_controller.dart';

class ProductPurchaseView extends StatefulWidget {
  const ProductPurchaseView({super.key});

  @override
  State<ProductPurchaseView> createState() => _ProductPurchaseViewState();
}

class _ProductPurchaseViewState extends State<ProductPurchaseView> {
  final CartController _cartController = Get.put(CartController());
  
  String _searchQuery = '';
  String _selectedCategory = 'VIA Facebook';

  final List<String> _categories = [
    'VIA Facebook',
    'Gmail',
    'Proxy',
    'Discord Token',
    'Cookie',
  ];

  final List<ProductModel> _allProducts = [
    ProductModel(id: 1, name: 'VIA Facebook Cổ kháng 2FA', price: 45000, stock: 124, category: 'VIA Facebook', description: 'Tài khoản FB từ 2012-2020 chất lượng cao.', rating: 4.8, reviewCount: 42),
    ProductModel(id: 2, name: 'VIA FB Ngoại cổ ngâm lâu', price: 65000, stock: 45, category: 'VIA Facebook', description: 'Bao login sạch, IP ngoại kháng spam cực tốt.', rating: 4.9, reviewCount: 18),
    ProductModel(id: 3, name: 'Gmail Ngoại Cổ (Đã ngâm 1 năm)', price: 8500, stock: 430, category: 'Gmail', description: 'Gmail cổ ngâm, đã ver Phone sạch.', rating: 4.7, reviewCount: 95),
    ProductModel(id: 4, name: 'Gmail New Reg tay sạch', price: 4200, stock: 999, category: 'Gmail', description: 'Gmail mới đăng ký thủ công, bảo hành 1-1.', rating: 4.5, reviewCount: 120),
    ProductModel(id: 5, name: 'Proxy IPv4 Sạch Tốc độ cao', price: 22000, stock: 99, category: 'Proxy', description: 'Proxy IPv4 Việt Nam hạn sử dụng 30 ngày.', rating: 4.6, reviewCount: 37),
    ProductModel(id: 6, name: 'Discord Token Full Ver Cổ', price: 15000, stock: 80, category: 'Discord Token', description: 'Token Discord cổ kháng quét tốt nhất.', rating: 4.9, reviewCount: 12),
    ProductModel(id: 7, name: 'Cookie Facebook Nuôi Cứng', price: 5000, stock: 500, category: 'Cookie', description: 'Định dạng Cookie dùng cho tool nuôi an toàn.', rating: 4.4, reviewCount: 22),
  ];

  @override
  Widget build(BuildContext context) {
    // Filtered products list
    final filteredProducts = _allProducts.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CỬA HÀNG TÀI NGUYÊN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1)),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        actions: [
          // Shopping cart badge icon
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF00E5FF)),
                    onPressed: _showCartBottomSheet,
                  ),
                  Obx(() => _cartController.totalCartCount > 0
                      ? Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                            child: Text(
                              '${_cartController.totalCartCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox()),
                ],
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(color: const Color(0xFF0D0F14)),
          
          SafeArea(
            child: Column(
              children: [
                // 1. Search Bar Input
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm tài nguyên MMO...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF00E5FF)),
                      filled: true,
                      fillColor: const Color(0xFF161B22),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF00E5FF)),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),

                // 2. Category Tab Filters Slider
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF161B22),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.04)),
                          ),
                          child: Center(
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Products Grid View
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(child: Text('Không tìm thấy tài nguyên nào phù hợp.', style: TextStyle(color: Colors.grey)))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Beautiful Product Card Helper
  Widget _buildProductCard(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF0D0F14), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 10),
                    const SizedBox(width: 2),
                    Text('${product.rating}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text('Còn: ${product.stock}', style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: const TextStyle(color: Colors.grey, fontSize: 9),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${product.price.toInt()}đ',
                style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 13, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF00E5FF), size: 18),
                onPressed: () {
                  _cartController.addProduct(product, 1);
                  Get.snackbar(
                    'Đã Thêm Vào Giỏ',
                    'Đã thêm 1 x ${product.name} vào giỏ hàng.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF161B22),
                    colorText: Colors.white,
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  // Shopping Cart Bottom Sheet Helper
  void _showCartBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF161B22),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GIỎ HÀNG CỦA BẠN',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
            ),
            const SizedBox(height: 16),
            Obx(() => _cartController.cartItems.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: Text('Giỏ hàng trống.', style: TextStyle(color: Colors.grey))),
                  )
                : SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: _cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartController.cartItems[index];
                        return ListTile(
                          title: Text(item.product.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          subtitle: Text('Số lượng: ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          trailing: Text('${item.totalCost.toInt()}đ', style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 12, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                  )),
            const Divider(color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TỔNG THANH TOÁN:', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                Obx(() => Text(
                  '${_cartController.totalCartPrice.toInt()}đ',
                  style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 16, fontWeight: FontWeight.bold),
                ))
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _cartController.clearCart();
                  Get.snackbar(
                    'Mua Thành Công',
                    'Đơn hàng của bạn đã được thanh toán và giao hàng tự động thành công.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('THANH TOÁN NGAY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
