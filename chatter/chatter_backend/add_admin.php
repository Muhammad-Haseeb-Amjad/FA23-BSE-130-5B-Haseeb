<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\Admin;

// Create new admin user
$admin = new Admin();
$admin->user_name = 'admin';
$admin->user_password = 'admin123';  // Plain text - will be auto-encrypted on first login
$admin->user_type = 1;  // 1 = full admin, 0 = tester/moderator
$admin->save();

echo "Admin user created successfully!\n";
echo "Username: " . $admin->user_name . "\n";
echo "Password: admin123\n";
echo "User Type: " . $admin->user_type . "\n";
echo "ID: " . $admin->id . "\n";
