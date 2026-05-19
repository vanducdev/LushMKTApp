<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // JWT Refresh Token lifecycle
            $table->string('refresh_token', 255)->nullable()->after('password');
            $table->timestamp('refresh_token_expired_at')->nullable()->after('refresh_token');

            // OTP Verification
            $table->string('otp_code', 10)->nullable()->after('refresh_token_expired_at');
            $table->timestamp('otp_expired_at')->nullable()->after('otp_code');

            // Biometric / Social login IDs
            $table->string('google_id')->nullable()->unique()->after('otp_expired_at');
            $table->string('apple_id')->nullable()->unique()->after('google_id');
            $table->boolean('face_id_enabled')->default(false)->after('apple_id');
            $table->string('face_id_token')->nullable()->after('face_id_enabled');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'refresh_token',
                'refresh_token_expired_at',
                'otp_code',
                'otp_expired_at',
                'google_id',
                'apple_id',
                'face_id_enabled',
                'face_id_token'
            ]);
        });
    }
};
