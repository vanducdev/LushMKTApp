<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ServiceController extends Controller
{
    /**
     * Get list of all available Facebook services.
     */
    public function index()
    {
        return response()->json([
            'status' => 'success',
            'data' => [
                [
                    'id' => 1,
                    'category_id' => 1,
                    'name' => 'Tăng Like Facebook Bài Viết (Tốc độ cao)',
                    'code' => 'fb_like_speed',
                    'price_per_one' => 4.0,
                    'min_quantity' => 100,
                    'max_quantity' => 50000,
                    'description' => 'Tốc độ lên nhanh cực đại, an toàn cho nick.',
                    'is_active' => true
                ],
                [
                    'id' => 2,
                    'category_id' => 1,
                    'name' => 'Tăng Follow Trang Cá Nhân VIP',
                    'code' => 'fb_follow_vip',
                    'price_per_one' => 12.0,
                    'min_quantity' => 500,
                    'max_quantity' => 100000,
                    'description' => 'Sub thật chất lượng cao có bảo hành tụt 30 ngày.',
                    'is_active' => true
                ],
                [
                    'id' => 3,
                    'category_id' => 1,
                    'name' => 'Buff Comment Facebook Động',
                    'code' => 'fb_comment_custom',
                    'price_per_one' => 8.0,
                    'min_quantity' => 10,
                    'max_quantity' => 5000,
                    'description' => 'Tự soạn nội dung viết mỗi bình luận một dòng mới.',
                    'is_active' => true
                ]
            ]
        ], 200);
    }

    /**
     * Store new Facebook service (Admin Only).
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'code' => 'required|string|unique:services,code',
            'price_per_one' => 'required|numeric|min:0',
            'min_quantity' => 'required|integer|min:1',
            'max_quantity' => 'required|integer|min:1',
            'description' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'errors' => $validator->errors()
            ], 422);
        }

        // For production, insert into database:
        // DB::table('services')->insert([...]);

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo gói dịch vụ tương tác FB thành công!',
            'data' => $request->all()
        ], 201);
    }
}
