<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class PaymentController extends Controller
{
    /**
     * Generate VietQR specifications for deposit
     */
    public function createVietQR(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:10000',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = $request->user();
        $transactionCode = 'LUSH' . rand(10000, 99999);

        // Record a pending transaction
        $transaction = Transaction::create([
            'user_id' => $user->id,
            'transaction_code' => $transactionCode,
            'type' => 'deposit',
            'amount' => $request->amount,
            'payment_method' => 'bank',
            'status' => 'pending',
            'description' => "Nạp tiền tự động qua VietQR tài khoản LUSH {$transactionCode}",
        ]);

        // Generate VietQR dynamic payload parameters
        $bankBin = "970422"; // MB Bank BIN
        $accountNo = "1903561728394";
        $amount = $request->amount;
        
        // standard VietQR Link format
        $qrUrl = "https://img.vietqr.io/image/MB-{$accountNo}-compact2.png?amount={$amount}&addInfo=" . urlencode($transactionCode) . "&accountName=" . urlencode("CONG TY LUSHMKT");

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo yêu cầu nạp VietQR thành công.',
            'data' => [
                'transaction_code' => $transactionCode,
                'amount' => $amount,
                'note' => $transactionCode,
                'qr_url' => $qrUrl,
                'payment_method' => 'bank',
                'account_no' => $accountNo,
                'bank_name' => 'MB Bank',
                'account_name' => 'CONG TY LUSHMKT',
                'transaction' => $transaction
            ]
        ]);
    }

    /**
     * Generate Crypto (USDT TRC-20) specifications for deposit
     */
    public function createCryptoDeposit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount_usd' => 'required|numeric|min:2',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = $request->user();
        $transactionCode = 'USDT' . rand(10000, 99999);
        
        // Tỷ giá quy đổi giả định: 1 USD = 25,000 VND
        $exchangeRate = 25000;
        $vndEquivalent = $request->amount_usd * $exchangeRate;

        // Ghi nhận giao dịch đang chờ
        $transaction = Transaction::create([
            'user_id' => $user->id,
            'transaction_code' => $transactionCode,
            'type' => 'deposit',
            'amount' => $vndEquivalent,
            'payment_method' => 'crypto',
            'status' => 'pending',
            'description' => "Nạp tiền Crypto USDT TRC-20 trị giá {$request->amount_usd} USD",
        ]);

        $usdtAddress = "TWeB9Hh7rZfJn3a1v9B5aH9c7z2W1Q2L4X"; // Địa chỉ USDT TRC-20 của công ty

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo yêu cầu nạp Crypto thành công.',
            'data' => [
                'transaction_code' => $transactionCode,
                'amount_usd' => $request->amount_usd,
                'exchange_rate' => $exchangeRate,
                'vnd_equivalent' => $vndEquivalent,
                'crypto_address' => $usdtAddress,
                'crypto_network' => 'TRC-20 (TRON)',
                'payment_method' => 'crypto',
                'transaction' => $transaction
            ]
        ]);
    }

    /**
     * Generate VNPay checkout specifications
     */
    public function createVNPayDeposit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:20000',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = $request->user();
        $transactionCode = 'VNP' . rand(10000, 99999);

        $transaction = Transaction::create([
            'user_id' => $user->id,
            'transaction_code' => $transactionCode,
            'type' => 'deposit',
            'amount' => $request->amount,
            'payment_method' => 'vnpay',
            'status' => 'pending',
            'description' => "Nạp tiền tự động qua VNPay cổng thanh toán {$transactionCode}",
        ]);

        // Tạo đường dẫn checkout VNPay giả định
        $checkoutUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=" . ($request->amount * 100) . "&vnp_TxnRef=" . $transactionCode;

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo yêu cầu nạp VNPay thành công.',
            'data' => [
                'transaction_code' => $transactionCode,
                'amount' => $request->amount,
                'checkout_url' => $checkoutUrl,
                'payment_method' => 'vnpay',
                'transaction' => $transaction
            ]
        ]);
    }

    /**
     * Generate Momo Wallet deposit checkout specifications
     */
    public function createMomoDeposit(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'amount' => 'required|numeric|min:10000',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = $request->user();
        $transactionCode = 'MOM' . rand(10000, 99999);

        $transaction = Transaction::create([
            'user_id' => $user->id,
            'transaction_code' => $transactionCode,
            'type' => 'deposit',
            'amount' => $request->amount,
            'payment_method' => 'momo',
            'status' => 'pending',
            'description' => "Nạp tiền tự động qua ví MoMo {$transactionCode}",
        ]);

        // Đường dẫn ví Momo giả lập thanh toán nhanh
        $checkoutUrl = "https://test-payment.momo.vn/v2/gateway/api/create?partnerCode=MOMO&orderId=" . $transactionCode;

        return response()->json([
            'status' => 'success',
            'message' => 'Tạo yêu cầu nạp Momo thành công.',
            'data' => [
                'transaction_code' => $transactionCode,
                'amount' => $request->amount,
                'checkout_url' => $checkoutUrl,
                'payment_method' => 'momo',
                'transaction' => $transaction
            ]
        ]);
    }

    /**
     * Webhook/Callback simulation: Immediately credit a user's wallet (Demo Sandbox Tool)
     */
    public function simulatePaymentCallback(Request $request, $code)
    {
        return DB::transaction(function () use ($code) {
            $transaction = Transaction::where('transaction_code', $code)->first();

            if (!$transaction) {
                return response()->json(['status' => 'error', 'message' => 'Không tìm thấy mã giao dịch.'], 404);
            }

            if ($transaction->status === 'success') {
                return response()->json(['status' => 'error', 'message' => 'Giao dịch đã được duyệt trước đó.'], 400);
            }

            // 1. Cập nhật trạng thái giao dịch
            $transaction->update(['status' => 'success']);

            // 2. Cộng tiền vào tài khoản user
            DB::table('users')->where('id', $transaction->user_id)->increment('balance', $transaction->amount);

            return response()->json([
                'status' => 'success',
                'message' => 'Mô phỏng thanh toán callback thành công! Tài khoản đã được cộng ' . number_format($transaction->amount) . 'đ.',
                'transaction' => $transaction
            ]);
        });
    }

    /**
     * Retrieve user transaction history
     */
    public function transactions(Request $request)
    {
        $transactions = Transaction::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->paginate(15);

        return response()->json($transactions);
    }
}
