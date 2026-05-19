<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class SellerController extends Controller
{
    /**
     * Get Seller Dashboard Analytics & Revenue statistics.
     */
    public function getAnalytics(Request $request)
    {
        $user = $request->user();

        // Mẫu phản hồi cao cấp mô tả đầy đủ hiệu năng kinh doanh của Merchant
        return response()->json([
            'status' => 'success',
            'data' => [
                'shop_name' => $user->name . ' MMO Store',
                'balance' => $user->balance, // Số dư khả dụng có thể rút
                'total_revenue' => 14850000, // Tổng doanh thu tích lũy
                'active_products' => 8,
                'total_sold_orders' => 195,
                'recent_sales' => [
                    ['month' => 'Jan', 'sales' => 1200000],
                    ['month' => 'Feb', 'sales' => 2400000],
                    ['month' => 'Mar', 'sales' => 1800000],
                    ['month' => 'Apr', 'sales' => 4500000],
                    ['month' => 'May', 'sales' => 4950000]
                ],
                'verification_status' => $user->seller_verified_status ?? 'approved', // approved, pending, none
            ]
        ], 200);
    }

    /**
     * Manage orders sold by the seller.
     */
    public function getOrders(Request $request)
    {
        // Mock các đơn hàng mà khách đã mua của Seller này
        return response()->json([
            'status' => 'success',
            'data' => [
                [
                    'id' => 101,
                    'order_code' => 'BUYX82KD9S',
                    'product_name' => 'VIA Facebook Cổ kháng 2FA',
                    'quantity' => 10,
                    'total_price' => 450000,
                    'status' => 'completed',
                    'buyer_name' => 'Nguyễn Đức',
                    'created_at' => '2026-05-18T12:00:00Z'
                ],
                [
                    'id' => 102,
                    'order_code' => 'BUYJ129SD8',
                    'product_name' => 'Gmail Ngoại Cổ (Reg 2020)',
                    'quantity' => 50,
                    'total_price' => 600000,
                    'status' => 'completed',
                    'buyer_name' => 'Quốc Khánh',
                    'created_at' => '2026-05-17T09:30:00Z'
                ]
            ]
        ], 200);
    }

    /**
     * Upload / Add a new resource product into marketplace as a seller.
     */
    public function uploadProduct(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'stock_quantity' => 'required|integer|min:0',
            'category' => 'required|string',
            'description' => 'nullable|string',
            'warranty_policy' => 'nullable|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        // Trong thực tế sẽ insert: DB::table('products')->insert([...]);
        return response()->json([
            'status' => 'success',
            'message' => 'Đăng bán sản phẩm tài nguyên MMO thành công! Đang chờ Admin phê duyệt.',
            'data' => array_merge($request->all(), ['id' => rand(100, 999)])
        ], 201);
    }

    /**
     * Submit verification documents for Seller status (Avatar, Citizen ID, Approval state).
     */
    public function verifySeller(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'avatar_url' => 'required|string',
            'document_url' => 'required|string',
            'shop_name' => 'required|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = $request->user();

        // Cập nhật trạng thái duyệt người bán thành 'pending' chờ phê duyệt
        DB::table('users')->where('id', $user->id)->update([
            'name' => $request->shop_name,
            // Trình diễn thực tế: cập nhật cột trạng thái
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Hồ sơ xác minh người bán đã được gửi lên hệ thống thành công. Trạng thái hiện tại: CHỜ DUYỆT (PENDING).',
            'data' => [
                'shop_name' => $request->shop_name,
                'avatar_url' => $request->avatar_url,
                'document_url' => $request->document_url,
                'status' => 'pending'
            ]
        ], 200);
    }

    /**
     * Check current Verification status.
     */
    public function getVerificationStatus(Request $request)
    {
        $user = $request->user();
        return response()->json([
            'status' => 'success',
            'data' => [
                'status' => $user->seller_verified_status ?? 'approved', //approved, pending, none
                'shop_name' => $user->name,
            ]
        ], 200);
    }

    /**
     * Request withdrawal of seller balance to bank account.
     */
    public function withdrawFunds(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:50000',
            'bank_name' => 'required|string',
            'bank_account_number' => 'required|string',
            'bank_account_name' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => $validator->errors()->first()
            ], 422);
        }

        $user = $request->user();

        if ($user->balance < $request->amount) {
            return response()->json([
                'status' => 'error',
                'message' => 'Số dư ví người bán không đủ để thực hiện yêu cầu rút tiền.'
            ], 400);
        }

        // DB Transaction khấu trừ số dư
        return DB::transaction(function () use ($user, $request) {
            DB::table('users')->where('id', $user->id)->decrement('balance', $request->amount);

            // Log Transaction
            DB::table('transactions')->insert([
                'user_id' => $user->id,
                'transaction_code' => 'WDR' . strtoupper(Str::random(10)),
                'type' => 'withdraw',
                'amount' => $request->amount,
                'status' => 'pending', // Rút tiền cần phê duyệt duyệt thủ công
                'description' => "Rút tiền về tài khoản ngân hàng {$request->bank_name} ({$request->bank_account_number})",
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Yêu cầu rút tiền trị giá ' . number_format($request->amount) . 'đ đã được tạo thành công và đang chờ xử lý chuyển khoản.',
                'remaining_balance' => $user->balance - $request->amount
            ], 200);
        });
    }
}
