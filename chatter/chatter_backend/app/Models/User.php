<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    public $table = "users";

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'identity',
        'username',
        'full_name',
        'bio',
        'interest_ids',
        'profile',
        'background_image',
        'is_push_notifications',
        'is_invited_to_room',
        'is_verified',
        'is_block',
        'block_user_ids',
        'saved_music_ids',
        'saved_reel_ids',
        'following',
        'followers',
        'is_moderator',
        'login_type',
        'device_type',
        'device_token',
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
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
        'otp_code',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'phone_verified_at' => 'datetime',
        'otp_expires_at' => 'datetime',
        'approved_at' => 'datetime',
        'email_verified_or_approval_sent_at' => 'datetime',
    ];

    public function post()
    {
        return $this->hasMany(Post::class, 'user_id', 'id');
    }
    
    public function stories()
    {
        return $this->hasMany(Story::class, 'user_id', 'id');
    }
    

}
