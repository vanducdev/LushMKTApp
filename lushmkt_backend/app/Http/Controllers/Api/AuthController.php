<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Carbon\Carbon;

class AuthController extends Controller
{
    /**
     * Helper to generate a new pair of access & refresh tokens
     */
    private function generateTokenPair(User $user, $message = 'Thành công.')
    {
        // 1. Tạo Access Token (Sanctum) ngắn hạn (mô phỏng hoặc thực tế qua Sanctum)
        $user->tokens()->delete(); // Dọn dẹp token cũ để bảo mật
        $accessToken = $user->createToken('access_token', ['*'])->plainTextToken;

        // 2. Tạo Refresh Token dài hạn (30 ngày)
        $refreshToken = Str::random(64);
        $user->refresh_token = $refreshToken;
        $user->refresh_token_expired_at = Carbon::now()->addDays(30);
        $user->save();

        return response()->json([
            'message' => $message,
            'access_token' => $accessToken,
            'refresh_token' => $refreshToken,
            'token_type' => 'Bearer',
            'expires_in' => 3600, // 1 giờ hoạt động của Access Token
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'balance' => $user->balance ?? 0.00,
                'role' => $user->role ?? 'user',
                'api_key' => $user->api_key,
                'face_id_enabled' => (bool)$user->face_id_enabled,
                'avatar' => $user->avatar
            ]
        ]);
    }

    /**
     * POST /auth/register - Đăng ký tài khoản mới
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'balance' => 0.00,
            'role' => 'user',
            'api_key' => 'lush_mkt_' . Str::random(32),
        ]);

        return $this->generateTokenPair($user, 'Đăng ký tài khoản thành công.');
    }

    /**
     * POST /auth/login - Đăng nhập tài khoản & cấp JWT + Refresh Token
     */
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Thông tin đăng nhập không chính xác.'], 401);
        }

        return $this->generateTokenPair($user, 'Đăng nhập thành công.');
    }

    /**
     * POST /auth/refresh - Gia hạn Access Token sử dụng Refresh Token
     */
    public function refresh(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'refresh_token' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        // Tìm User khớp với Refresh Token còn hiệu lực
        $user = User::where('refresh_token', $request->refresh_token)
                    ->where('refresh_token_expired_at', '>', Carbon::now())
                    ->first();

        if (!$user) {
            return response()->json(['error' => 'Refresh Token không hợp lệ hoặc đã hết hạn.'], 401);
        }

        return $this->generateTokenPair($user, 'Làm mới Token thành công.');
    }

    /**
     * POST /auth/send-otp - Tạo và gửi mã xác thực OTP qua Email/SMS
     */
    public function sendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json(['error' => 'Không tìm thấy tài khoản email này.'], 404);
        }

        // Tạo mã OTP 6 số ngẫu nhiên có hiệu lực trong 5 phút
        $otp = rand(100000, 999999);
        $user->otp_code = $otp;
        $user->otp_expired_at = Carbon::now()->addMinutes(5);
        $user->save();

        // MOCK gửi mail hệ thống (In ra log để lập trình viên theo dõi ở Console)
        error_log("LUSH-MKT OTP ALERT: User {$user->email} has OTP: $otp");

        return response()->json([
            'message' => 'Mã xác thực OTP đã được gửi về email của bạn.',
            'expires_in_minutes' => 5
        ]);
    }

    /**
     * POST /auth/verify-otp - Xác thực OTP đăng nhập
     */
    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'otp' => 'required|string|size:6',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('otp_code', $request->otp)
                    ->where('otp_expired_at', '>', Carbon::now())
                    ->first();

        if (!$user) {
            return response()->json(['error' => 'Mã OTP không chính xác hoặc đã hết hạn.'], 400);
        }

        // Xóa OTP sau khi dùng xong
        $user->otp_code = null;
        $user->otp_expired_at = null;
        $user->save();

        return $this->generateTokenPair($user, 'Xác minh OTP thành công.');
    }

    /**
     * POST /auth/social-login - Đăng nhập MXH (Google & Apple ID)
     */
    public function socialLogin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'provider' => 'required|string|in:google,apple',
            'social_id' => 'required|string',
            'email' => 'required|string|email',
            'name' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $provider = $request->provider;
        $socialId = $request->social_id;

        // Tìm kiếm User theo social_id tương ứng
        $user = null;
        if ($provider === 'google') {
            $user = User::where('google_id', $socialId)->first();
        } else {
            $user = User::where('apple_id', $socialId)->first();
        }

        // Nếu chưa tồn tại -> Tự động đăng ký mới (Provisioning)
        if (!$user) {
            // Check trùng email đăng ký truyền thống
            $user = User::where('email', $request->email)->first();
            
            if ($user) {
                // Liên kết tài khoản có sẵn với MXH mới
                if ($provider === 'google') {
                    $user->google_id = $socialId;
                } else {
                    $user->apple_id = $socialId;
                }
                $user->save();
            } else {
                // Tạo mới tài khoản hoàn toàn
                $user = User::create([
                    'name' => $request->name,
                    'email' => $request->email,
                    'password' => Hash::make(Str::random(16)), // Mật khẩu ngẫu nhiên
                    'balance' => 0.00,
                    'role' => 'user',
                    'api_key' => 'lush_mkt_' . Str::random(32),
                    'google_id' => $provider === 'google' ? $socialId : null,
                    'apple_id' => $provider === 'apple' ? $socialId : null,
                ]);
            }
        }

        return $this->generateTokenPair($user, 'Đăng nhập mạng xã hội thành công.');
    }

    /**
     * POST /auth/faceid-login - Đăng nhập sinh trắc học Face ID
     */
    public function faceIdLogin(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'face_id_token' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = User::where('email', $request->email)
                    ->where('face_id_enabled', true)
                    ->where('face_id_token', $request->face_id_token)
                    ->first();

        if (!$user) {
            return response()->json(['error' => 'Xác minh Face ID không hợp lệ hoặc sinh trắc học chưa được đăng ký.'], 401);
        }

        return $this->generateTokenPair($user, 'Đăng nhập sinh trắc học thành công.');
    }

    /**
     * GET /user/profile - Lấy thông tin cá nhân
     */
    public function profile(Request $request)
    {
        return response()->json($request->user());
    }

    /**
     * POST /user/avatar - Cập nhật ảnh đại diện
     */
    public function updateAvatar(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'avatar' => 'required|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()->first()], 422);
        }

        $user = $request->user();

        if ($request->hasFile('avatar')) {
            $imageName = time() . '.' . $request->avatar->extension();
            $request->avatar->move(public_path('avatars'), $imageName);
            
            $user->avatar = '/avatars/' . $imageName;
            $user->save();
        }

        return response()->json([
            'message' => 'Cập nhật ảnh đại diện thành công.',
            'avatar_url' => $user->avatar
        ]);
    }

    /**
     * GET /user/notifications - Lấy danh sách thông báo
     */
    public function getNotifications(Request $request)
    {
        $notifications = [
            [
                'id' => 1,
                'title' => 'Khuyến mãi nạp thẻ',
                'content' => 'Hệ thống đang khuyến mãi 10% giá trị nạp tiền qua tài khoản VietQR ngân hàng tự động.',
                'created_at' => now()->subHours(2)->toIso8601String(),
            ],
            [
                'id' => 2,
                'title' => 'Tăng tương tác thành công',
                'content' => 'Đơn hàng buff 1000 Like Facebook bài viết của bạn đã được hoàn thành.',
                'created_at' => now()->subDays(1)->toIso8601String(),
            ]
        ];

        return response()->json($notifications);
    }

    /**
     * POST /auth/logout - Đăng xuất tài khoản
     */
    public function logout(Request $request)
    {
        $user = $request->user();
        
        // Thu hồi token hiện tại
        $user->currentAccessToken()->delete();
        
        // Xóa Refresh Token lưu trữ
        $user->refresh_token = null;
        $user->refresh_token_expired_at = null;
        $user->save();

        return response()->json(['message' => 'Đăng xuất tài khoản thành công.']);
    }
}
