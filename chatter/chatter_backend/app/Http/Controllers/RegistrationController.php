<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\GlobalFunction;
use App\Models\RegistrationOtp;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Session;
use Illuminate\Support\Facades\Validator;

class RegistrationController extends Controller
{
    private function registrationOtpEnabled(): bool
    {
        $raw = env('REGISTRATION_OTP_ENABLED', 'true');
        if (is_bool($raw)) {
            return $raw;
        }
        $value = strtolower(trim((string) $raw));
        return in_array($value, ['1', 'true', 'yes', 'y', 'on'], true);
    }

    private array $departments = [
        'Computer Science',
        'Software Engineering',
        'Artificial Intelligence',
        'Cyber Security',
        'Electrical Engineering',
        'Computer Engineering',
        'Management Sciences',
        'Mathematics',
        'Physics',
        'Humanities',
    ];

    private array $campuses = [
        'COMSATS University Islamabad',
        'Islamabad',
        'Lahore',
        'Abbottabad',
        'Wah',
        'Attock',
        'Sahiwal',
        'Vehari',
    ];

    public function registrationRequests()
    {
        $pendingCount = User::where('approval_status', 'pending')->count();
        $approvedCount = User::where(function ($query) {
            $query->where('approval_status', 'approved')->orWhereNull('approval_status');
        })->count();
        $rejectedCount = User::where('approval_status', 'rejected')->count();
        $cancelledCount = User::where('approval_status', 'cancelled')->count();

        return view('registrationRequests', compact('pendingCount', 'approvedCount', 'rejectedCount', 'cancelledCount'));
    }

    public function registrationRequestList(Request $request)
    {
        $status = $request->input('status', 'pending');
        $search = trim((string) $request->input('search.value', ''));
        $limit = (int) $request->input('length', 10);
        $start = (int) $request->input('start', 0);
        $orderColumn = $request->input('order.0.column', 0);
        $orderDir = $request->input('order.0.dir', 'DESC');

        $columnMap = [
            0 => 'id',
            1 => 'full_name',
            2 => 'role_type',
            3 => 'registration_number',
            4 => 'department',
            5 => 'batch_duration',
            6 => 'campus',
            7 => 'email',
            8 => 'phone_number',
            9 => 'gender',
            10 => 'created_at',
        ];

        $query = User::query()
            ->where(function ($builder) use ($status) {
                if ($status === 'approved') {
                    $builder->where(function ($q) {
                        $q->where('approval_status', 'approved')->orWhereNull('approval_status');
                    });
                } else {
                    $builder->where('approval_status', $status);
                }
            });

        if ($search !== '') {
            $query->where(function ($builder) use ($search) {
                $builder->where('full_name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone_number', 'like', "%{$search}%")
                    ->orWhere('registration_number', 'like', "%{$search}%")
                    ->orWhere('department', 'like', "%{$search}%");
            });
        }

        $totalData = User::where(function ($builder) use ($status) {
            if ($status === 'approved') {
                $builder->where(function ($q) {
                    $q->where('approval_status', 'approved')->orWhereNull('approval_status');
                });
            } else {
                $builder->where('approval_status', $status);
            }
        })->count();

        $totalFiltered = $query->count();

        $result = $query->orderBy($columnMap[$orderColumn] ?? 'id', $orderDir)
            ->offset($start)
            ->limit($limit)
            ->get();

        $data = [];

        foreach ($result as $item) {
            $role = $item->role_type ? ucfirst($item->role_type) : '-';
            $registrationNumber = $item->role_type === 'student' ? ($item->registration_number ?: '-') : '-';
            $batchDuration = $item->role_type === 'student' ? ($item->batch_duration ?: '-') : '-';
            $submittedAt = $item->created_at ? Carbon::parse($item->created_at)->format('d M Y, h:i A') : '-';
            $phone = $item->phone_number ?: '-';
            $gender = $item->gender ? ucfirst($item->gender) : '-';

            $view = '<a href="#" class="btn btn-info text-white registration-view" rel="' . $item->id . '">View Details</a>';
            $approve = '<a href="#" class="btn btn-success text-white registration-approve ms-2" rel="' . $item->id . '">Approve</a>';
            $reject = '<a href="#" class="btn btn-danger text-white registration-reject ms-2" rel="' . $item->id . '">Reject</a>';
            $cancel = '<a href="#" class="btn btn-secondary text-white registration-cancel ms-2" rel="' . $item->id . '">Cancel</a>';

            $actions = '<div class="d-flex justify-content-end flex-wrap gap-2">' . $view;
            if ($status === 'pending') {
                $actions .= $approve . $reject . $cancel;
            }
            $actions .= '</div>';

            $data[] = [
                e($item->full_name ?: '-'),
                $role,
                e($registrationNumber),
                e($item->department ?: '-'),
                e($batchDuration),
                e($item->campus ?: '-'),
                e($item->email ?: '-'),
                e($phone),
                e($gender),
                e($submittedAt),
                $actions,
            ];
        }

        return response()->json([
            'draw' => (int) $request->input('draw'),
            'recordsTotal' => $totalData,
            'recordsFiltered' => $totalFiltered,
            'data' => $data,
        ]);
    }

    public function registrationRequestDetail(Request $request, int $id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['status' => false, 'message' => 'Registration request not found.']);
        }

        return response()->json([
            'status' => true,
            'message' => 'Registration request fetched successfully.',
            'data' => $user->makeVisible(['university_card_image']),
        ]);
    }

    public function approveRegistrationRequest(Request $request, int $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['status' => false, 'message' => 'User not found.']);
        }

        $adminId = Admin::where('user_name', Session::get('user_name'))->value('id');
        $user->approval_status = 'approved';
        $user->approved_at = now();
        $user->approved_by = $adminId;
        $user->rejected_reason = null;
        $user->email_verified_or_approval_sent_at = now();
        $user->save();

        $this->sendApprovalEmail($user);

        return response()->json(['status' => true, 'message' => 'Registration request approved successfully.']);
    }

    public function rejectRegistrationRequest(Request $request, int $id)
    {
        $validator = Validator::make($request->all(), [
            'rejected_reason' => 'required|string|max:2000',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $user = User::find($id);
        if (!$user) {
            return response()->json(['status' => false, 'message' => 'User not found.']);
        }

        $user->approval_status = 'rejected';
        $user->rejected_reason = $request->rejected_reason;
        $user->approved_at = null;
        $user->approved_by = null;
        $user->email_verified_or_approval_sent_at = now();
        $user->save();

        $this->sendRejectionEmail($user, $request->rejected_reason);

        return response()->json(['status' => true, 'message' => 'Registration request rejected successfully.']);
    }

    public function cancelRegistrationRequest(Request $request, int $id)
    {
        $user = User::find($id);
        if (!$user) {
            return response()->json(['status' => false, 'message' => 'User not found.']);
        }

        $user->approval_status = 'cancelled';
        $user->approved_at = null;
        $user->approved_by = null;
        $user->save();

        return response()->json(['status' => true, 'message' => 'Registration request cancelled successfully.']);
    }

    public function sendRegisterOtp(Request $request)
    {
        if (!$this->registrationOtpEnabled()) {
            return response()->json([
                'status' => false,
                'message' => 'OTP verification is temporarily disabled. Please submit registration directly.',
            ]);
        }

        $request->merge(['phone_number' => $this->normalizePhoneNumber((string) $request->phone_number)]);

        $validator = Validator::make($request->all(), [
            'phone_number' => ['required', 'regex:/^03\d{9}$/'],
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $phoneNumber = $this->normalizePhoneNumber($request->phone_number);

        if (User::where('phone_number', $phoneNumber)->exists()) {
            return response()->json(['status' => false, 'message' => 'Phone number is already registered.']);
        }

        $otp = (string) random_int(100000, 999999);

        RegistrationOtp::updateOrCreate(
            ['phone_number' => $phoneNumber],
            [
                'otp_code' => Hash::make($otp),
                'otp_expires_at' => now()->addMinutes(10),
                'verified_at' => null,
                'consumed_at' => null,
            ]
        );

        Log::info('CUI registration OTP generated', [
            'phone_number' => $phoneNumber,
            'otp' => $otp,
            'expires_at' => now()->addMinutes(10)->toDateTimeString(),
        ]);

        $response = [
            'status' => true,
            'message' => 'OTP sent successfully',
        ];

        if (config('app.debug')) {
            $response['otp'] = $otp;
        }

        return response()->json($response);
    }

    public function verifyRegisterOtp(Request $request)
    {
        if (!$this->registrationOtpEnabled()) {
            return response()->json([
                'status' => false,
                'message' => 'OTP verification is temporarily disabled.',
            ]);
        }

        $request->merge(['phone_number' => $this->normalizePhoneNumber((string) $request->phone_number)]);

        $validator = Validator::make($request->all(), [
            'phone_number' => ['required', 'regex:/^03\d{9}$/'],
            'otp' => ['required', 'digits:6'],
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $phoneNumber = $this->normalizePhoneNumber($request->phone_number);
        $record = RegistrationOtp::where('phone_number', $phoneNumber)->first();

        if (!$record) {
            return response()->json(['status' => false, 'message' => 'OTP not found. Please request a new one.']);
        }

        if ($record->consumed_at) {
            return response()->json(['status' => false, 'message' => 'OTP already used. Please request a new one.']);
        }

        if (!$record->otp_expires_at || $record->otp_expires_at->isPast()) {
            return response()->json(['status' => false, 'message' => 'OTP has expired. Please request a new one.']);
        }

        if (!Hash::check($request->otp, $record->otp_code)) {
            return response()->json(['status' => false, 'message' => 'Invalid OTP.']);
        }

        $record->verified_at = now();
        $record->save();

        return response()->json(['status' => true, 'message' => 'Phone number verified']);
    }

    public function register(Request $request)
    {
        $request->merge(['phone_number' => $this->normalizePhoneNumber((string) $request->phone_number)]);

        $validator = Validator::make($request->all(), [
            'role_type' => 'required|in:student,faculty',
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone_number' => ['required', 'regex:/^03\d{9}$/', 'unique:users,phone_number'],
            'department' => 'required|string|max:255',
            'gender' => 'required|in:male,female,other',
            'password' => 'required|string|min:6|confirmed',
            'campus' => 'nullable|string|max:255',
            'registration_number' => 'required_if:role_type,student|nullable|string|max:255|unique:users,registration_number',
            'batch_duration' => 'required_if:role_type,student|nullable|string|max:255',
            'university_card_image' => 'required|image|mimes:jpg,jpeg,png|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $phoneNumber = $this->normalizePhoneNumber($request->phone_number);

        $otpEnabled = $this->registrationOtpEnabled();
        // Request-level override (used by the mobile app to temporarily bypass OTP).
        // When set, it takes precedence over env('REGISTRATION_OTP_ENABLED').
        $overrideRaw = $request->input('registration_otp_enabled');
        if ($overrideRaw !== null) {
            $overrideValue = strtolower(trim((string) $overrideRaw));
            $otpEnabled = in_array($overrideValue, ['1', 'true', 'yes', 'y', 'on'], true);
        }
        $record = null;
        if ($otpEnabled) {
            $record = RegistrationOtp::where('phone_number', $phoneNumber)->first();
            if (!$record || !$record->verified_at) {
                return response()->json(['status' => false, 'message' => 'Please verify your phone number first.']);
            }

            if ($record->consumed_at) {
                return response()->json(['status' => false, 'message' => 'This verification has already been used.']);
            }

            if (!$record->otp_expires_at || $record->otp_expires_at->isPast()) {
                return response()->json(['status' => false, 'message' => 'Phone verification expired. Please verify again.']);
            }
        }

        $cardImagePath = GlobalFunction::saveFileAndGivePath($request->file('university_card_image'));

        $user = new User();
        $user->identity = $request->email;
        $user->email = $request->email;
        $user->password = Hash::make($request->password);
        $user->full_name = $request->full_name;
        $user->role_type = $request->role_type;
        $user->approval_status = 'pending';
        $user->registration_number = $request->role_type === 'student' ? $request->registration_number : null;
        $user->department = $request->department;
        $user->batch_duration = $request->role_type === 'student' ? $request->batch_duration : null;
        $user->phone_number = $phoneNumber;
        $user->gender = $request->gender;
        $user->campus = $request->campus ?: 'COMSATS University Islamabad';
        $user->university_card_image = $cardImagePath;
        $user->phone_verified_at = $otpEnabled ? now() : null;
        $user->approved_at = null;
        $user->approved_by = null;
        $user->rejected_reason = null;
        $user->email_verified_or_approval_sent_at = null;
        $user->login_type = 2;
        $user->device_type = (int) ($request->device_type ?? 0);
        $user->device_token = $request->device_token;
        $user->save();

        if ($otpEnabled && $record) {
            $record->consumed_at = now();
            $record->save();
        }

        return response()->json([
            'status' => true,
            'message' => 'Registration request submitted successfully. Please wait for admin approval.',
            'data' => $this->privateUserPayload($user, true),
        ]);
    }

    private function normalizePhoneNumber(string $phoneNumber): string
    {
        $phoneNumber = trim($phoneNumber);
        if (str_starts_with($phoneNumber, '+92')) {
            return '0' . substr($phoneNumber, 3);
        }

        return $phoneNumber;
    }

    private function privateUserPayload(User $user, bool $includePrivate = false): array
    {
        $payload = [
            'id' => $user->id,
            'identity' => $user->identity,
            'username' => $user->username,
            'full_name' => $user->full_name,
            'email' => $user->email ?? $user->identity,
            'profile' => $user->profile,
            'role_type' => $user->role_type,
            'approval_status' => $user->approval_status ?? 'approved',
            'registration_number' => $user->registration_number,
            'department' => $user->department,
            'batch_duration' => $user->batch_duration,
            'campus' => $user->campus,
        ];

        if ($includePrivate) {
            $payload['phone_number'] = $user->phone_number;
            $payload['gender'] = $user->gender;
        }

        return $payload;
    }

    private function sendApprovalEmail(User $user): void
    {
        try {
            Mail::raw("Hello {$user->full_name},\n\nYour CUI Chatter account has been approved.\nYou can now sign in using your registered email.\n\nRegards,\nCUI Chatter Team", function ($message) use ($user) {
                $message->to($user->email ?? $user->identity)
                    ->subject('CUI Chatter Account Approved');
            });
        } catch (\Throwable $throwable) {
            Log::error('Approval email failed: ' . $throwable->getMessage());
        }
    }

    private function sendRejectionEmail(User $user, string $reason): void
    {
        try {
            Mail::raw("Hello {$user->full_name},\n\nYour registration request has been rejected.\nReason: {$reason}\n\nRegards,\nCUI Chatter Team", function ($message) use ($user) {
                $message->to($user->email ?? $user->identity)
                    ->subject('CUI Chatter Registration Update');
            });
        } catch (\Throwable $throwable) {
            Log::error('Rejection email failed: ' . $throwable->getMessage());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // FORGOT PASSWORD — step 1: generate OTP and send to email
    // ─────────────────────────────────────────────────────────────────────────
    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $email = strtolower(trim($request->email));

        // Find approved user (case-insensitive)
        $user = User::whereRaw('LOWER(email) = ?', [$email])
            ->orWhereRaw('LOWER(identity) = ?', [$email])
            ->first();

        if (!$user) {
            return response()->json(['status' => false, 'message' => 'No account found with this email address.']);
        }

        $approvalStatus = strtolower($user->approval_status ?? 'approved');
        if ($approvalStatus === 'pending') {
            return response()->json(['status' => false, 'message' => 'Your account is pending admin approval. You cannot reset your password yet.']);
        }
        if ($approvalStatus === 'rejected' || $approvalStatus === 'cancelled') {
            return response()->json(['status' => false, 'message' => 'Your account is not active. Please contact admin.']);
        }

        // Generate 6-digit OTP
        $otp = (string) random_int(100000, 999999);
        $user->otp_code = Hash::make($otp);
        $user->otp_expires_at = now()->addMinutes(15);
        $user->save();

        Log::info('Password reset OTP generated', [
            'email' => $email,
            'expires_at' => $user->otp_expires_at->toDateTimeString(),
        ]);

        // Send OTP email
        try {
            Mail::raw(
                "Hello {$user->full_name},\n\nYour password reset OTP is: {$otp}\n\nThis OTP is valid for 15 minutes.\n\nIf you did not request this, please ignore this email.\n\nRegards,\nCUI Chatter Team",
                function ($message) use ($user) {
                    $message->to($user->email ?? $user->identity)
                        ->subject('CUI Chatter — Password Reset OTP');
                }
            );
        } catch (\Throwable $throwable) {
            Log::error('Password reset email failed: ' . $throwable->getMessage());
            // Still return success — OTP is stored, user can try again or contact admin
        }

        $response = [
            'status' => true,
            'message' => 'A password reset OTP has been sent to your email address.',
        ];

        // Expose OTP in debug mode only (never in production)
        if (config('app.debug')) {
            $response['otp'] = $otp;
        }

        return response()->json($response);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // RESET PASSWORD — step 2: verify OTP and set new password
    // ─────────────────────────────────────────────────────────────────────────
    public function resetPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'otp'      => 'required|digits:6',
            'password' => 'required|string|min:6|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => false, 'message' => $validator->errors()->first()]);
        }

        $email = strtolower(trim($request->email));

        $user = User::whereRaw('LOWER(email) = ?', [$email])
            ->orWhereRaw('LOWER(identity) = ?', [$email])
            ->first();

        if (!$user) {
            return response()->json(['status' => false, 'message' => 'No account found with this email address.']);
        }

        if (!$user->otp_code || !$user->otp_expires_at) {
            return response()->json(['status' => false, 'message' => 'No password reset was requested. Please request a new OTP.']);
        }

        if ($user->otp_expires_at->isPast()) {
            return response()->json(['status' => false, 'message' => 'OTP has expired. Please request a new one.']);
        }

        if (!Hash::check($request->otp, $user->otp_code)) {
            return response()->json(['status' => false, 'message' => 'Invalid OTP. Please check and try again.']);
        }

        // OTP valid — update password and clear OTP
        $user->password = Hash::make($request->password);
        $user->otp_code = null;
        $user->otp_expires_at = null;
        $user->save();

        Log::info('Password reset successful', ['email' => $email]);

        return response()->json(['status' => true, 'message' => 'Password reset successfully. You can now sign in with your new password.']);
    }
}