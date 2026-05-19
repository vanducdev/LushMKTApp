<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProductController extends Controller
{
    /**
     * Get list of all products.
     */
    public function index()
    {
        // For production: DB::table('products')->where('is_active', true)->get();
        // Return mock products matching the mobile client
        return response()->json([
            'status' => 'success',
            'data' => [
                [
                    'id' => 1,
                    'name' => 'VIA Facebook Cổ kháng 2FA',
                    'price' => 45000,
                    'stock' => 124,
                    'category' => 'VIA Facebook',
                    'description' => 'Tài khoản FB từ 2012-2020 chất lượng cao.',
                    'rating' => 4.8,
                    'review_count' => 42
                ],
                [
                    'id' => 3,
                    'name' => 'Gmail Ngoại Cổ (Đã ngâm 1 năm)',
                    'price' => 8500,
                    'stock' => 430,
                    'category' => 'Gmail',
                    'description' => 'Gmail cổ ngâm, đã ver Phone sạch.',
                    'rating' => 4.7,
                    'review_count' => 95
                ],
                [
                    'id' => 5,
                    'name' => 'Proxy IPv4 Sạch Tốc độ cao',
                    'price' => 22000,
                    'stock' => 99,
                    'category' => 'Proxy',
                    'description' => 'Proxy IPv4 Việt Nam hạn sử dụng 30 ngày.',
                    'rating' => 4.6,
                    'review_count' => 37
                ]
            ]
        ], 200);
    }

    /**
     * Get home page banners.
     */
    public function getBanners()
    {
        return response()->json([
            'status' => 'success',
            'data' => [
                [
                    'id' => 1,
                    'title' => 'KHUYẾN MÃI NẠP TIỀN 10%',
                    'subtitle' => 'Áp dụng tự động MB Bank',
                    'image' => 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80'
                ]
            ]
        ], 200);
    }

    /**
     * Get product categories.
     */
    public function getCategories()
    {
        return response()->json([
            'status' => 'success',
            'data' => [
                ['id' => 1, 'name' => 'VIA Facebook', 'icon' => 'facebook', 'count' => 12],
                ['id' => 2, 'name' => 'Gmail', 'icon' => 'email', 'count' => 8],
                ['id' => 3, 'name' => 'Proxy', 'icon' => 'vpn_lock', 'count' => 5]
            ]
        ], 200);
    }

    /**
     * Get details of a single product with reviews and related items.
     */
    public function show($id)
    {
        // For production: $product = DB::table('products')->where('id', $id)->first();
        // Here we build a premium mock responsive payload representing full detailed properties:
        $products = [
            1 => [
                'id' => 1,
                'name' => 'VIA Facebook Cổ kháng 2FA',
                'price' => 45000,
                'stock' => 124,
                'category' => 'VIA Facebook',
                'description' => 'Tài khoản FB cổ được tạo từ năm 2012-2020 chất lượng cao. Đã ngâm IP sạch, thích hợp chạy quảng cáo Ads trâu bò.',
                'rating' => 4.8,
                'review_count' => 3,
                'warranty_policy' => 'Bảo hành sai thông tin đăng nhập trong vòng 24h kể từ khi mua. Không bảo hành khi đã lên camp hoặc đổi thông tin.',
                'reviews' => [
                    ['id' => 1, 'user_name' => 'Nguyễn Đức', 'rating' => 5, 'comment' => 'Acc cực kỳ trâu, ngâm lên camp phát ăn ngay!', 'created_at' => '2026-05-18T12:00:00Z'],
                    ['id' => 2, 'user_name' => 'Quốc Khánh', 'rating' => 4, 'comment' => 'Khá tốt, mua 5 acc đều login mượt mà.', 'created_at' => '2026-05-17T09:30:00Z']
                ],
                'related' => [
                    ['id' => 2, 'name' => 'VIA Facebook Ngoại Cổ kháng BM', 'price' => 120000, 'stock' => 15, 'category' => 'VIA Facebook']
                ]
            ],
            3 => [
                'id' => 3,
                'name' => 'Gmail Ngoại Cổ (Đã ngâm 1 năm)',
                'price' => 8500,
                'stock' => 430,
                'category' => 'Gmail',
                'description' => 'Gmail đăng ký từ năm 2022 ngoại quốc, đã được ngâm và tương tác sạch. An toàn liên kết MMO.',
                'rating' => 4.7,
                'review_count' => 1,
                'warranty_policy' => 'Bảo hành login lần đầu tiên, không bảo hành nếu spam hoặc vi phạm chính sách Google.',
                'reviews' => [
                    ['id' => 1, 'user_name' => 'Hoàng Anh', 'rating' => 5, 'comment' => 'Sử dụng làm kênh YouTube cực tốt, reg kênh cực bền.', 'created_at' => '2026-05-15T08:00:00Z']
                ],
                'related' => [
                    ['id' => 4, 'name' => 'Gmail Việt New (Chưa Add SĐT)', 'price' => 2500, 'stock' => 1500, 'category' => 'Gmail']
                ]
            ]
        ];

        $product = $products[$id] ?? [
            'id' => $id,
            'name' => 'Tài nguyên MMO Đặc biệt',
            'price' => 50000,
            'stock' => 10,
            'category' => 'Khác',
            'description' => 'Mô tả chi tiết sản phẩm tài nguyên MMO chất lượng cao.',
            'rating' => 5.0,
            'review_count' => 0,
            'warranty_policy' => 'Bảo hành lỗi 1 đổi 1 trong vòng 24 giờ.',
            'reviews' => [],
            'related' => []
        ];

        return response()->json([
            'status' => 'success',
            'data' => $product
        ], 200);
    }

    /**
     * Store new product (Admin Only).
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'category' => 'required|string',
            'description' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        // For production, insert into database:
        // DB::table('products')->insert([...]);

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo sản phẩm tài nguyên MMO thành công!',
            'data' => $request->all()
        ], 201);
    }
}
