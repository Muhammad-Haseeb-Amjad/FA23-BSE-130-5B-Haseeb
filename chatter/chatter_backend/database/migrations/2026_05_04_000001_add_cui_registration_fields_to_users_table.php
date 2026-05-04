<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role_type', 20)->nullable()->after('full_name');
            $table->string('approval_status', 20)->nullable()->default('pending')->after('role_type');
            $table->string('registration_number')->nullable()->unique()->after('approval_status');
            $table->string('department')->nullable()->after('registration_number');
            $table->string('batch_duration')->nullable()->after('department');
            $table->string('phone_number')->nullable()->unique()->after('batch_duration');
            $table->string('gender', 20)->nullable()->after('phone_number');
            $table->string('campus')->nullable()->default('COMSATS University Islamabad')->after('gender');
            $table->timestamp('phone_verified_at')->nullable()->after('campus');
            $table->string('otp_code')->nullable()->after('phone_verified_at');
            $table->timestamp('otp_expires_at')->nullable()->after('otp_code');
            $table->timestamp('approved_at')->nullable()->after('otp_expires_at');
            $table->unsignedBigInteger('approved_by')->nullable()->after('approved_at');
            $table->text('rejected_reason')->nullable()->after('approved_by');
            $table->timestamp('email_verified_or_approval_sent_at')->nullable()->after('rejected_reason');
        });

        DB::table('users')
            ->whereNull('approval_status')
            ->update([
                'approval_status' => 'approved',
                'approved_at' => now(),
            ]);
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'role_type',
                'approval_status',
                'registration_number',
                'department',
                'batch_duration',
                'phone_number',
                'gender',
                'campus',
                'phone_verified_at',
                'otp_code',
                'otp_expires_at',
                'approved_at',
                'approved_by',
                'rejected_reason',
                'email_verified_or_approval_sent_at',
            ]);
        });
    }
};