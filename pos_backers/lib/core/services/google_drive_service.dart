import 'dart:convert';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'local_database_service.dart';

class GoogleDriveService {
  GoogleDriveService._();
  static final GoogleDriveService instance = GoogleDriveService._();

  late GoogleSignIn _googleSignIn;
  ga.DriveApi? _driveApi;
  GoogleSignInAccount? _currentUser;

  Future<void> initialize() async {
    // appDataFolder access needs driveAppdataScope; driveFileScope allows
    // read/write of app-created files. driveScope alone blocks appDataFolder.
    _googleSignIn = GoogleSignIn(
      scopes: [ga.DriveApi.driveAppdataScope, ga.DriveApi.driveFileScope],
    );
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      if (account != null) {
        _initDriveApi(account);
      }
    });
  }

  Future<void> _initDriveApi(GoogleSignInAccount account) async {
    final headers = await account.authHeaders;
    final authenticateClient = _AuthenticateClient(headers);
    _driveApi = ga.DriveApi(authenticateClient);
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      // already signed in
      if (_currentUser != null) return _currentUser;

      // try silent first
      final silent = await _googleSignIn.signInSilently();
      if (silent != null) {
        await _initDriveApi(silent);
        _currentUser = silent;
        return silent;
      }

      // interactive sign-in
      final account = await _googleSignIn.signIn();
      if (account != null) {
        await _initDriveApi(account);
        _currentUser = account;
      }
      return account;
    } catch (e) {
      print('Google Sign-In error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _driveApi = null;
  }

  Future<String?> backupToGoogleDrive() async {
    try {
      if (_driveApi == null || _currentUser == null) {
        final account = await signIn();
        if (account == null) {
          throw Exception('Failed to sign in to Google');
        }
        if (_driveApi == null) {
          throw Exception('Drive API not initialized after sign-in');
        }
      }

      final db = LocalDatabaseService.instance;

      // Backup all tables
      final backup = {
        'timestamp': DateTime.now().toIso8601String(),
        'products': await db.queryAll('products'),
        'customers': await db.queryAll('customers'),
        'sales': await db.queryAll('sales'),
        'wastage_logs': await db.queryAll('wastage_logs'),
        'stock_operations': await db.queryAll('stock_operations'),
      };

      final jsonContent = jsonEncode(backup);
      final fileName =
          'pos_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      // Upload to Drive
      final driveFile = ga.File();
      driveFile.name = fileName;
      driveFile.parents = ['appDataFolder'];

      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: ga.Media(
          Stream.value(utf8.encode(jsonContent)),
          jsonContent.length,
        ),
      );

      return result.id;
    } catch (e) {
      print('Backup to Google Drive failed: $e');
      return null;
    }
  }

  Future<List<ga.File>> listBackups() async {
    if (_driveApi == null) {
      final account = await signIn();
      if (account == null) return [];
    }

    try {
      const q = "name contains 'pos_backup'";
      final result = await _driveApi!.files.list(q: q, spaces: 'appDataFolder');
      return result.files ?? [];
    } catch (e) {
      print('Failed to list backups: $e');
      return [];
    }
  }

  Future<String?> downloadBackup(String fileId) async {
    if (_driveApi == null) {
      final account = await signIn();
      if (account == null) return null;
    }

    try {
      final media =
          await _driveApi!.files.get(
                fileId,
                downloadOptions: ga.DownloadOptions.fullMedia,
              )
              as ga.Media;

      final bytes = await media.stream.toList();
      final content = utf8.decode(bytes.expand((b) => b).toList());
      return content;
    } catch (e) {
      print('Failed to download backup: $e');
      return null;
    }
  }
}

class _AuthenticateClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  _AuthenticateClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
