<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RegistrationOtp extends Model
{
    use HasFactory;

    protected $table = 'registration_otps';

    protected $fillable = [
        'phone_number',
        'otp_code',
        'otp_expires_at',
        'verified_at',
        'consumed_at',
    ];

    protected $casts = [
        'otp_expires_at' => 'datetime',
        'verified_at' => 'datetime',
        'consumed_at' => 'datetime',
    ];
}