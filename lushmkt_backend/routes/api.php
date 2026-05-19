<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ServiceController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\SellerController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Public Authentication Routes
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/refresh', [AuthController::class, 'refresh']);
Route::post('/auth/send-otp', [AuthController::class, 'sendOtp']);
Route::post('/auth/verify-otp', [AuthController::class, 'verifyOtp']);
Route::post('/auth/social-login', [AuthController::class, 'socialLogin']);
Route::post('/auth/faceid-login', [AuthController::class, 'faceIdLogin']);

// Public Browsing Routes
Route::get('/home/banners', [ProductController::class, 'getBanners']);
Route::get('/categories', [ProductController::class, 'getCategories']);
Route::get('/services', [ServiceController::class, 'index']);
Route::get('/products', [ProductController::class, 'index']);
Route::get('/product/{id}', [ProductController::class, 'show']);

// Protected User Routes (Requires Sanctum Token)
Route::middleware('auth:sanctum')->group(function () {
    
    // User Profile
    Route::get('/user/profile', [AuthController::class, 'profile']);
    Route::post('/user/avatar', [AuthController::class, 'updateAvatar']);
    Route::post('/auth/logout', [AuthController::class, 'logout']);

    // Order Placement (Services and Products)
    Route::post('/orders/service', [OrderController::class, 'createServiceOrder']);
    Route::post('/orders/product', [OrderController::class, 'createProductOrder']);
    Route::get('/orders/history', [OrderController::class, 'history']);

    // Payment & Transactions
    Route::post('/deposit/vietqr', [PaymentController::class, 'createVietQR']);
    Route::post('/deposit/crypto', [PaymentController::class, 'createCryptoDeposit']);
    Route::post('/deposit/vnpay', [PaymentController::class, 'createVNPayDeposit']);
    Route::post('/deposit/momo', [PaymentController::class, 'createMomoDeposit']);
    Route::post('/deposit/simulate/{code}', [PaymentController::class, 'simulatePaymentCallback']);
    Route::get('/transactions', [PaymentController::class, 'transactions']);

    // Support Tickets
    Route::post('/tickets', [OrderController::class, 'createTicket']);
    Route::get('/notifications', [AuthController::class, 'getNotifications']);

    // Seller Center Operations (GIAI ĐOẠN 8)
    Route::get('/seller/analytics', [SellerController::class, 'getAnalytics']);
    Route::get('/seller/orders', [SellerController::class, 'getOrders']);
    Route::post('/seller/products', [SellerController::class, 'uploadProduct']);
    Route::post('/seller/verify', [SellerController::class, 'verifySeller']);
    Route::get('/seller/status', [SellerController::class, 'getVerificationStatus']);
    Route::post('/seller/withdraw', [SellerController::class, 'withdrawFunds']);
});

// Admin-Only Routes
Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    Route::get('/stats', [OrderController::class, 'adminStats']);
    Route::post('/services/store', [ServiceController::class, 'store']);
    Route::post('/products/store', [ProductController::class, 'store']);
});
