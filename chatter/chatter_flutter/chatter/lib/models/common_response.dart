class CommonResponse {
  CommonResponse({
    bool? status,
    String? message,
    String? otp,
    String? debugNote,
  }) {
    _status = status;
    _message = message;
    _otp = otp;
    _debugNote = debugNote;
  }

  CommonResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _otp = json['otp']?.toString();
    _debugNote = json['debug_note']?.toString();
  }
  bool? _status;
  String? _message;
  String? _otp;
  String? _debugNote;

  CommonResponse copyWith({
    bool? status,
    String? message,
    String? otp,
    String? debugNote,
  }) =>
      CommonResponse(
        status: status ?? _status,
        message: message ?? _message,
        otp: otp ?? _otp,
        debugNote: debugNote ?? _debugNote,
      );
  bool? get status => _status;
  String? get message => _message;
  /// OTP returned by backend in debug mode (APP_DEBUG=true).
  /// null in production.
  String? get otp => _otp;
  String? get debugNote => _debugNote;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_otp != null) map['otp'] = _otp;
    if (_debugNote != null) map['debug_note'] = _debugNote;
    return map;
  }
}
