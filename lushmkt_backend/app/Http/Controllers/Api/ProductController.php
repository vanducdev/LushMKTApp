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
