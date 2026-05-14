<?php

namespace App\Http\Controllers;
use App\Models\Admin;
use App\Models\GlobalFunction;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Crypt;

class LoginController extends Controller
{

    function login()
    {
        try {
            $setting = Setting::first();
            if ($setting) {
                Session::put('app_name', $setting->app_name);
            }
        } catch (\Exception $e) {
            // DB unavailable — proceed with default app name so login page still renders
            if (!Session::has('app_name')) {
                Session::put('app_name', 'CUI_CHAT');
            }
        }

        // If already logged in, go straight to dashboard
        if (Session::get('user_name')) {
            return redirect('/dashboard');
        }

        return view('login');
    }

    public function checklogin(Request $request)
    {
        \Log::info('Login attempt', [
            'username' => $request->user_name,
            'has_password' => !empty($request->user_password)
        ]);

        $data = Admin::where('user_name', $request->user_name)->first();

        if ($data) {
            \Log::info('User found', ['id' => $data->id, 'user_type' => $data->user_type]);
            
            $inputPassword = $request->user_password;
            $storedPassword = $data->user_password;
            $matched = false;

            // First, try to decrypt (for already-encrypted passwords)
            try {
                $decryptedPassword = Crypt::decrypt($storedPassword);
                if ($inputPassword === $decryptedPassword) {
                    $matched = true;
                    \Log::info('Password matched (encrypted)');
                }
            } catch (\Exception $e) {
                \Log::info('Decryption failed, trying plain text');
            }

            // Fallback: if the DB still has plain text (from imported SQL), match directly
            if (!$matched && $inputPassword === $storedPassword) {
                $matched = true;
                \Log::info('Password matched (plain text)');
                // Upgrade to encrypted storage so future logins stay secure
                try {
                    $data->user_password = Crypt::encrypt($storedPassword);
                    $data->save();
                    \Log::info('Password encrypted and saved');
                } catch (\Exception $e) {
                    \Log::error('Failed to encrypt password: ' . $e->getMessage());
                }
            }

            if ($matched) {
                $request->session()->put('user_name', $data->user_name);
                $request->session()->put('user_type', $data->user_type ?? 0);

                \Log::info('Login successful', ['username' => $data->user_name]);
                return GlobalFunction::sendDataResponse(true, 'Login Successfully.', $data);
            }
            
            \Log::warning('Password mismatch');
        } else {
            \Log::warning('User not found', ['username' => $request->user_name]);
        }

        return GlobalFunction::sendSimpleResponse(false, 'Wrong credentials.');
    }

    public function logout(Request $request)
    {
        $request->session()->invalidate();
        $request->session()->regenerateToken();
        Session::flush();

        return redirect('/');
    }

    public function forgotPasswordForm(Request $request)
    {
        $databaseUsername = env('DB_USERNAME');
        $databasePassword = env('DB_PASSWORD');

        if ($request->database_username == $databaseUsername && $request->database_password == $databasePassword) {

            $encryptedPassword = Crypt::encrypt($request->new_password);

            $admin = Admin::where('user_name', 'admin')->first();

            if (!$admin) {
                return GlobalFunction::sendSimpleResponse(false, 'Admin user not found.');
            }

            $admin->user_password = $encryptedPassword;
            $admin->save();

            return GlobalFunction::sendSimpleResponse(true, 'Password updated successfully.');
        } else {
            return GlobalFunction::sendSimpleResponse(false, 'Wrong credentials.');
        }
    }

}
