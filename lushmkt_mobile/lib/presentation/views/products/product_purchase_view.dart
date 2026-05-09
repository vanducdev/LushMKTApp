import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/social_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../../data/models/social_models.dart';

class ProductPurchaseView extends StatefulWidget {
  const ProductPurchaseView({super.key});

  @override
  State<ProductPurchaseView> createState() => _ProductPurchaseViewState();
}

class _ProductPurchaseViewState extends State<ProductPurchaseView> {
  final SettingsController _settingsController = Get.find<SettingsController>();
  final SocialController _socialController = Get.find<SocialController>();
  final AuthController _authController = Get.find<AuthController>();

  final _searchController = TextEditingController();
  String _selectedCategory = 'Tất cả';

  // Forms controllers for adding/editing products
  final _prodNameController = TextEditingController();
  final _prodDescController = TextEditingController();
  final _prodTypeController = TextEditingController();
  final _prodCategoryController = TextEditingController();
  final _prodPriceController = TextEditingController();
  final _prodFileUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _settingsController.isDarkMode.value;
      final Color textColor = isDark ? Colors.white : Colors.black87;
      final Color cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

      // Filter products
      final filteredProducts = _socialController.storeProducts.where((p) {
        final matchesSearch = p.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            p.description.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == 'Tất cả' || p.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0D0F14) : const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text(
            'LushMKT STORE',
            style: _settingsController.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
          backgroundColor: isDark ? const Color(0xFF0D0F14) : Colors.white,
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              onPressed: () => _showAddProductDialog(context),
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('ĐĂNG BÁN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                textStyle: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            // 1. SEARCH & CATEGORY FILTER HEADER
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF00E5FF)),
                      hintText: 'Tìm kiếm phần mềm, scripts, tools...',
                      hintStyle: _settingsController.getTextStyle(fontSize: 12, color: Colors.grey),
                      fillColor: cardColor,
                    ),
                    style: _settingsController.getTextStyle(fontSize: 13, color: textColor),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryFilterRow(textColor),
                ],
              ),
            ),

            // 2. STUNNING DIGITAL PRODUCTS LIST
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: Text('Không tìm thấy sản phẩm nào.', style: _settingsController.getTextStyle(fontSize: 13, color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final prod = filteredProducts[index];
                        final isMyProduct = prod.authorName == (_authController.currentUser.value?.name ?? '');

                        return Card(
                          color: cardColor,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildFileTypeBadge(prod.fileType),
                                    Text(
                                      prod.category.toUpperCase(),
                                      style: _settingsController.getTextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(prod.name, style: _settingsController.getTextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(height: 6),
                                Text(
                                  prod.description,
                                  style: _settingsController.getTextStyle(fontSize: 12, color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Divider(color: isDark ? Colors.white10 : Colors.black12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('GIÁ BÁN', style: _settingsController.getTextStyle(fontSize: 9, color: Colors.grey)),
                                        Text(
                                          prod.price > 0 ? '${prod.price.toInt()}đ' : 'MIỄN PHÍ',
                                          style: _settingsController.getTextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF00E5FF)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        if (isMyProduct) ...[
                                          IconButton(
                                            icon: const Icon(Icons.edit_note, color: Colors.orangeAccent),
                                            onPressed: () => _showEditProductDialog(context, prod),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                                            onPressed: () => _socialController.deleteStoreProduct(prod.id),
                                          ),
                                        ],
                                        ElevatedButton(
                                          onPressed: () => _showProductDetailsDialog(context, prod),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: Text('CHI TIẾT', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor)),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      );
    });
  }

  // File type design badges
  Widget _buildFileTypeBadge(String type) {
    Color badgeColor = Colors.grey;
    if (type == '.exe') badgeColor = Colors.blueAccent;
    if (type == '.py') badgeColor = Colors.green;
    if (type == '.ipa') badgeColor = Colors.purpleAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.toUpperCase(),
        style: _settingsController.getTextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
      ),
    );
  }

  // Category filter list
  Widget _buildCategoryFilterRow(Color textColor) {
    final categories = ['Tất cả', 'Tool Nuôi Account', 'Python Scripts', 'iOS Applications'];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat, style: _settingsController.getTextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.black : textColor)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              selectedColor: const Color(0xFF00E5FF),
              backgroundColor: _settingsController.isDarkMode.value ? const Color(0xFF161B22) : Colors.white,
            ),
          );
        },
      ),
    );
  }

  // Details dialog
  void _showProductDetailsDialog(BuildContext context, DigitalResourceModel prod) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _settingsController.isDarkMode.value ? const Color(0xFF161B22) : Colors.white,
          title: Text(prod.name, style: _settingsController.getTextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mô tả chi tiết:', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 6),
                Text(prod.description, style: _settingsController.getTextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                Text('Định dạng:', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                _buildFileTypeBadge(prod.fileType),
                const SizedBox(height: 16),
                Text('Tác giả:', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(prod.authorName, style: _settingsController.getTextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Đường dẫn tải xuống (Download Link):', style: _settingsController.getTextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(prod.fileUrl ?? 'N/A', style: _settingsController.getTextStyle(fontSize: 12, color: const Color(0xFF00E5FF))),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('ĐÓNG', style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: () => Get.back(),
            )
          ],
        );
      },
    );
  }

  // Add Product Dialog Form
  void _showAddProductDialog(BuildContext context) {
    _prodNameController.clear();
    _prodDescController.clear();
    _prodTypeController.text = '.exe';
    _prodCategoryController.text = 'Tool Nuôi Account';
    _prodPriceController.clear();
    _prodFileUrlController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _settingsController.isDarkMode.value ? const Color(0xFF161B22) : Colors.white,
          title: Text('ĐĂNG BÁN SẢN PHẨM MỚI', style: _settingsController.getTextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _prodNameController, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                const SizedBox(height: 12),
                TextField(controller: _prodDescController, decoration: const InputDecoration(labelText: 'Mô tả chi tiết')),
                const SizedBox(height: 12),
                TextField(controller: _prodTypeController, decoration: const InputDecoration(labelText: 'Định dạng (Ví dụ: .exe, .py, .ipa)')),
                const SizedBox(height: 12),
                TextField(controller: _prodCategoryController, decoration: const InputDecoration(labelText: 'Danh mục')),
                const SizedBox(height: 12),
                TextField(controller: _prodPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giá bán (VND)')),
                const SizedBox(height: 12),
                TextField(controller: _prodFileUrlController, decoration: const InputDecoration(labelText: 'Đường dẫn file (Download Link)')),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('HỦY', style: _settingsController.getTextStyle(fontSize: 12, color: Colors.redAccent)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('ĐĂNG BÁN', style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: () {
                final name = _prodNameController.text.trim();
                final price = double.tryParse(_prodPriceController.text) ?? 0.0;

                if (name.isEmpty) return;

                _socialController.addStoreProduct(
                  name: name,
                  description: _prodDescController.text,
                  fileType: _prodTypeController.text,
                  category: _prodCategoryController.text,
                  price: price,
                  fileUrl: _prodFileUrlController.text,
                );
                Get.back();
              },
            )
          ],
        );
      },
    );
  }

  // Edit Product Dialog Form
  void _showEditProductDialog(BuildContext context, DigitalResourceModel prod) {
    _prodNameController.text = prod.name;
    _prodDescController.text = prod.description;
    _prodTypeController.text = prod.fileType;
    _prodCategoryController.text = prod.category;
    _prodPriceController.text = prod.price.toInt().toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _settingsController.isDarkMode.value ? const Color(0xFF161B22) : Colors.white,
          title: Text('SỬA THÔNG TIN SẢN PHẨM', style: _settingsController.getTextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: _prodNameController, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                const SizedBox(height: 12),
                TextField(controller: _prodDescController, decoration: const InputDecoration(labelText: 'Mô tả chi tiết')),
                const SizedBox(height: 12),
                TextField(controller: _prodTypeController, decoration: const InputDecoration(labelText: 'Định dạng')),
                const SizedBox(height: 12),
                TextField(controller: _prodCategoryController, decoration: const InputDecoration(labelText: 'Danh mục')),
                const SizedBox(height: 12),
                TextField(controller: _prodPriceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Giá bán (VND)')),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('HỦY', style: _settingsController.getTextStyle(fontSize: 12, color: Colors.redAccent)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: Text('CẬP NHẬT', style: _settingsController.getTextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              onPressed: () {
                final name = _prodNameController.text.trim();
                final price = double.tryParse(_prodPriceController.text) ?? 0.0;

                if (name.isEmpty) return;

                _socialController.updateStoreProduct(
                  prod.id,
                  name: name,
                  description: _prodDescController.text,
                  fileType: _prodTypeController.text,
                  category: _prodCategoryController.text,
                  price: price,
                );
                Get.back();
              },
            )
          ],
        );
      },
    );
  }
}
