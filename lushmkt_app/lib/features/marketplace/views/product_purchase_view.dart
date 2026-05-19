import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lushmkt_app/core/theme/lush_design_system.dart';
import 'package:lushmkt_app/features/marketplace/providers/marketplace_providers.dart';

class ProductPurchaseView extends ConsumerStatefulWidget {
  const ProductPurchaseView({super.key});

  @override
  ConsumerState<ProductPurchaseView> createState() => _ProductPurchaseViewState();
}

class _ProductPurchaseViewState extends ConsumerState<ProductPurchaseView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Đồng bộ controller tìm kiếm ban đầu
    _searchController.addListener(() {
      ref.read(marketplaceSearchProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(marketplaceSearchProvider);
    final selectedCategory = ref.watch(marketplaceCategoryProvider);
    final productsAsync = ref.watch(marketplaceProductsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14), // Cyber Black
      appBar: AppBar(
        title: Text(
          'LushMKT STORE',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: const Color(0xFF0D0F14),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Color(0xFF00E5FF)),
            onPressed: () {
              // Mở bộ lọc nâng cao
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. SEARCH & CATEGORIES BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              children: [
                // Khung tìm kiếm Neon
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF00E5FF)),
                    hintText: 'Tìm kiếm VIA, Gmail, VPS, Proxy sạch...',
                    hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF161B22),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.5),
                    ),
                  ),
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 12),
                
                // Thanh cuộn chọn danh mục ngang
                _buildCategoryFilterRow(selectedCategory),
              ],
            ),
          ),

          // 2. STUNNING DIGITAL PRODUCTS LIST
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00E5FF)),
              ),
              error: (err, stack) => const Center(
                child: Text('Lỗi tải tài nguyên MMO.'),
              ),
              data: (products) {
                // Áp dụng bộ lọc tìm kiếm & danh mục
                final filtered = products.where((p) {
                  final name = (p['name'] ?? '').toString().toLowerCase();
                  final desc = (p['description'] ?? '').toString().toLowerCase();
                  final category = p['category'] ?? '';

                  final matchesSearch = name.contains(search.toLowerCase()) || desc.contains(search.toLowerCase());
                  final matchesCategory = selectedCategory == 'Tất cả' || category == selectedCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'Không tìm thấy sản phẩm nào.',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final prod = filtered[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withOpacity(0.06),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7000FF).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (prod['category'] ?? 'MMO').toString().toUpperCase(),
                                  style: GoogleFonts.orbitron(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF7000FF),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    (prod['rating'] ?? 5.0).toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            prod['name'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            prod['description'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: Colors.white10, height: 1),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GIÁ SẢN PHẨM',
                                    style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(prod['price'] ?? 0.0).toInt()} ₫',
                                    style: GoogleFonts.orbitron(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF00E5FF),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Kho: ${prod['stock_quantity'] ?? 0}',
                                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showProductDetailsModal(context, prod['id'], prod['name']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00E5FF).withOpacity(0.12),
                                      foregroundColor: const Color(0xFF00E5FF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'CHI TIẾT',
                                      style: GoogleFonts.orbitron(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Categories Row
  Widget _buildCategoryFilterRow(String selected) {
    final categories = ['Tất cả', 'VIA Facebook', 'Gmail', 'Proxy'];
    
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selected == cat;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                cat,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.white,
                ),
              ),
              selected: isSelected,
              onSelected: (val) {
                ref.read(marketplaceCategoryProvider.notifier).state = cat;
              },
              selectedColor: const Color(0xFF00E5FF),
              backgroundColor: const Color(0xFF161B22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF00E5FF) : Colors.white.withOpacity(0.04),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Premium Product Details Bottom Sheet Modal (Detail, Review, Related)
  void _showProductDetailsModal(BuildContext context, int productId, String productName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0F14),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer(
              builder: (context, ref, child) {
                final detailAsync = ref.watch(productDetailProvider(productId));

                return detailAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF))),
                  error: (e, s) => const Center(child: Text('Lỗi tải chi tiết sản phẩm.')),
                  data: (detail) {
                    final reviews = List<Map<String, dynamic>>.from(detail['reviews'] ?? []);
                    final related = List<Map<String, dynamic>>.from(detail['related'] ?? []);

                    return ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20.0),
                      children: [
                        // Drag Indicator
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Title & Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                (detail['category'] ?? '').toString().toUpperCase(),
                                style: GoogleFonts.orbitron(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF00E5FF),
                                ),
                              ),
                            ),
                            Text(
                              'Kho: ${detail['stock_quantity'] ?? 0} tài khoản',
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          detail['name'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(detail['price'] ?? 0.0).toInt()} ₫',
                          style: GoogleFonts.orbitron(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00E5FF),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 16),

                        // SPECIFICATIONS & DESCRIPTION
                        Text(
                          'MÔ TẢ CHI TIẾT',
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          detail['description'] ?? '',
                          style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5),
                        ),
                        const SizedBox(height: 20),

                        // WARRANTY POLICY
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7000FF).withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF7000FF).withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.gavel_rounded, color: Color(0xFF7000FF), size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'CHÍNH SÁCH BẢO HÀNH VIP',
                                    style: GoogleFonts.orbitron(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF7000FF),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                detail['warranty_policy'] ?? '',
                                style: GoogleFonts.inter(fontSize: 11, color: Colors.white.withOpacity(0.8), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // CUSTOMER REVIEWS (Reviews)
                        Text(
                          'ĐÁNH GIÁ TỪ KHÁCH HÀNG (${reviews.length})',
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (reviews.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Sản phẩm chưa có lượt đánh giá nào.',
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                            ),
                          )
                        else
                          ...reviews.map((rev) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF161B22),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          rev['user_name'] ?? 'Khách ẩn danh',
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (starIndex) => Icon(
                                              Icons.star,
                                              size: 12,
                                              color: starIndex < (rev['rating'] ?? 5) ? Colors.amber : Colors.white10,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      rev['comment'] ?? '',
                                      style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.9)),
                                    ),
                                  ],
                                ),
                              )),
                        const SizedBox(height: 24),

                        // RELATED PRODUCTS (Related products)
                        if (related.isNotEmpty) ...[
                          Text(
                            'SẢN PHẨM CÙNG DANH MỤC',
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: related.length,
                              itemBuilder: (context, index) {
                                final rel = related[index];
                                return InkWell(
                                  onTap: () {
                                    // Đóng modal cũ và mở sản phẩm liên quan mới!
                                    Navigator.pop(context);
                                    _showProductDetailsModal(context, rel['id'], rel['name']);
                                  },
                                  child: Container(
                                    width: 180,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF161B22),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF00E5FF).withOpacity(0.06),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          rel['name'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(rel['price'] ?? 0.0).toInt()} ₫',
                                          style: GoogleFonts.orbitron(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Kho: ${rel['stock_quantity'] ?? 0}',
                                          style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),

                        // PURCHASE ACTION
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Xử lý mua sản phẩm
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          child: const Text('MUA SẢN PHẨM NGAY'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
