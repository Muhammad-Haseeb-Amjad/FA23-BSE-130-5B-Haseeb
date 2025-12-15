<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;

// Simulate login request
$username = 'admin';
$password = 'admin123';

echo "Testing login for: $username / $password\n\n";

$data = Admin::where('user_name', $username)->first();

if ($data) {
    echo "User found in database:\n";
    echo "ID: " . $data->id . "\n";
    echo "Username: " . $data->user_name . "\n";
    echo "Stored password: " . $data->user_password . "\n";
    echo "User type: " . ($data->user_type ?? 'NULL') . "\n\n";
    
    $inputPassword = $password;
    $storedPassword = $data->user_password;
    $matched = false;

    // First, try to decrypt (for already-encrypted passwords)
    try {
        $decryptedPassword = Crypt::decrypt($storedPassword);
        if ($inputPassword === $decryptedPassword) {
            $matched = true;
            echo "✓ Password matched (encrypted)\n";
        }
    } catch (\Exception $e) {
        echo "✗ Decryption failed: " . $e->getMessage() . "\n";
    }

    // Fallback: if the DB still has plain text (from imported SQL), match directly
    if (!$matched && $inputPassword === $storedPassword) {
        $matched = true;
        echo "✓ Password matched (plain text)\n";
    }

    if ($matched) {
        echo "\n✓✓✓ LOGIN SUCCESSFUL ✓✓✓\n";
    } else {
        echo "\n✗✗✗ LOGIN FAILED - Wrong credentials ✗✗✗\n";
    }
} else {
    echo "✗ User not found in database\n";
}
