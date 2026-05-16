import 'package:untitled/common/managers/session_manager.dart';
import 'package:untitled/models/setting_model.dart';
import 'package:untitled/models/story.dart';

class Registration {
  bool? status;
  String? message;
  User? data;

  Registration({
    this.status,
    this.message,
    this.data,
  });

  factory Registration.fromJson(dynamic json) {
    final data = json is Map ? json : <String, dynamic>{};
    return Registration(
      status: data["status"],
      message: data["message"],
      data: data["data"] is Map ? User.fromJson(data["data"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class User {
  User({
    this.id,
    this.identity,
    this.email,
    this.username,
    this.fullName,
    this.bio,
    this.interestIds,
    this.profile,
    this.backgroundImage,
    this.isPushNotifications,
    this.isInvitedToRoom,
    this.isVerified,
    this.isBlock,
    this.blockUserIds,
    this.following,
    this.followers,
    this.loginType,
    this.deviceType,
    this.isModerator,
    this.roleType,
    this.approvalStatus,
    this.registrationNumber,
    this.department,
    this.batchDuration,
    this.phoneNumber,
    this.gender,
    this.campus,
    this.phoneVerifiedAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectedReason,
    this.emailVerifiedOrApprovalSentAt,
    this.savedMusicIds,
    this.savedReelIds,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.followingStatus,
    this.stories,
    this.interest,
  });

  User.fromJson(dynamic json) {
    if (json is! Map) {
      json = <String, dynamic>{};
    }
    id = json['id'];
    identity = json['identity'];
    email = json['email'];
    username = json['username'];
    fullName = json['full_name'];
    bio = json['bio'];
    interestIds = json['interest_ids'];
    profile = json['profile'];
    backgroundImage = json['background_image'];
    isPushNotifications = json['is_push_notifications'];
    isInvitedToRoom = json['is_invited_to_room'];
    isVerified = json['is_verified'];
    isBlock = json['is_block'];
    blockUserIds = json['block_user_ids'];
    following = json['following'];
    followers = json['followers'];
    loginType = json['login_type'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isModerator = json['is_moderator'];
    roleType = json['role_type'];
    approvalStatus = json['approval_status'];
    registrationNumber = json['registration_number'];
    department = json['department'];
    batchDuration = json['batch_duration'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    campus = json['campus'];
    phoneVerifiedAt = json['phone_verified_at'];
    approvedAt = json['approved_at'];
    approvedBy = json['approved_by'];
    rejectedReason = json['rejected_reason'];
    emailVerifiedOrApprovalSentAt = json['email_verified_or_approval_sent_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    followingStatus = json['followingStatus'];
    savedMusicIds = json['saved_music_ids'];
    savedReelIds = json['saved_reel_ids'];

    if (json['interest'] != null) {
      interest = [];
      json['interest'].forEach((v) {
        if (v is Map) {
          interest?.add(Interest.fromJson(Map<String, dynamic>.from(v)));
        }
      });
    }

    if (json['stories'] != null) {
      stories = [];
      json['stories'].forEach((v) {
        var s = Story.fromJson(v is Map ? Map<String, dynamic>.from(v) : v);
        s.user = this;
        stories?.add(s);
      });
    }
  }

  num? id;
  String? identity;
  String? email;
  String? username;
  String? fullName;
  String? bio;
  String? interestIds;
  String? profile;
  String? backgroundImage;
  num? isPushNotifications;
  num? isInvitedToRoom;
  num? isVerified;
  num? isBlock;
  String? blockUserIds;
  num? following;
  num? followers;
  num? loginType;
  num? deviceType;
  num? isModerator;
  String? roleType;
  String? approvalStatus;
  String? registrationNumber;
  String? department;
  String? batchDuration;
  String? phoneNumber;
  String? gender;
  String? campus;
  String? phoneVerifiedAt;
  String? approvedAt;
  num? approvedBy;
  String? rejectedReason;
  String? emailVerifiedOrApprovalSentAt;
  String? savedMusicIds;
  String? savedReelIds;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;

  num? followingStatus;
  List<Story>? stories;
  List<Interest>? interest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['identity'] = identity;
    map['email'] = email;
    map['username'] = username;
    map['full_name'] = fullName;
    map['bio'] = bio;
    map['interest_ids'] = interestIds;
    map['profile'] = profile;
    map['background_image'] = backgroundImage;
    map['is_push_notifications'] = isPushNotifications;
    map['is_invited_to_room'] = isInvitedToRoom;
    map['is_verified'] = isVerified;
    map['is_block'] = isBlock;
    map['block_user_ids'] = blockUserIds;
    map['following'] = following;
    map['followers'] = followers;
    map['login_type'] = loginType;
    map['device_type'] = deviceType;
    map['device_token'] = deviceToken;
    map['is_moderator'] = isModerator;
    map['role_type'] = roleType;
    map['approval_status'] = approvalStatus;
    map['registration_number'] = registrationNumber;
    map['department'] = department;
    map['batch_duration'] = batchDuration;
    map['phone_number'] = phoneNumber;
    map['gender'] = gender;
    map['campus'] = campus;
    map['phone_verified_at'] = phoneVerifiedAt;
    map['approved_at'] = approvedAt;
    map['approved_by'] = approvedBy;
    map['rejected_reason'] = rejectedReason;
    map['email_verified_or_approval_sent_at'] = emailVerifiedOrApprovalSentAt;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['followingStatus'] = followingStatus;
    map['saved_music_ids'] = savedMusicIds;
    map['saved_reel_ids'] = savedReelIds;
    if (stories != null) {
      map['stories'] = stories?.map((v) => v.toJson()).toList();
    }
    if (interest != null) {
      map['interest'] = interest?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  /// Map-style accessor for backward compatibility: user['id'], user['username']
  dynamic operator [](String key) {
    final map = toJson();
    if (map.containsKey(key)) {
      return map[key];
    }
    switch (key) {
      case 'fullName':
        return fullName;
      case 'backgroundImage':
        return backgroundImage;
      case 'isPushNotifications':
        return isPushNotifications;
      case 'isInvitedToRoom':
        return isInvitedToRoom;
      case 'isVerified':
        return isVerified;
      case 'isBlock':
        return isBlock;
      case 'blockUserIds':
        return blockUserIds;
      case 'savedMusicIds':
        return savedMusicIds;
      case 'savedReelIds':
        return savedReelIds;
      case 'deviceToken':
        return deviceToken;
      case 'createdAt':
        return createdAt;
      case 'updatedAt':
        return updatedAt;
      case 'followingStatus':
        return followingStatus;
      case 'isModerator':
        return isModerator;
      case 'email':
        return email;
      case 'roleType':
        return roleType;
      case 'approvalStatus':
        return approvalStatus;
      case 'registrationNumber':
        return registrationNumber;
      case 'department':
        return department;
      case 'batchDuration':
        return batchDuration;
      case 'phoneNumber':
        return phoneNumber;
      case 'gender':
        return gender;
      case 'campus':
        return campus;
      default:
        return null;
    }
  }

  /// Map-style setter for backward compatibility: user['id'] = value
  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'id':
        id = value;
        break;
      case 'identity':
        identity = value;
        break;
      case 'email':
        email = value;
        break;
      case 'username':
        username = value;
        break;
      case 'full_name':
      case 'fullName':
        fullName = value;
        break;
      case 'bio':
        bio = value;
        break;
      case 'interest_ids':
      case 'interestIds':
        interestIds = value;
        break;
      case 'profile':
        profile = value;
        break;
      case 'background_image':
      case 'backgroundImage':
        backgroundImage = value;
        break;
      case 'is_push_notifications':
      case 'isPushNotifications':
        isPushNotifications = value;
        break;
      case 'is_invited_to_room':
      case 'isInvitedToRoom':
        isInvitedToRoom = value;
        break;
      case 'is_verified':
      case 'isVerified':
        isVerified = value;
        break;
      case 'is_block':
      case 'isBlock':
        isBlock = value;
        break;
      case 'block_user_ids':
      case 'blockUserIds':
        blockUserIds = value;
        break;
      case 'following':
        following = value;
        break;
      case 'followers':
        followers = value;
        break;
      case 'login_type':
      case 'loginType':
        loginType = value;
        break;
      case 'device_type':
      case 'deviceType':
        deviceType = value;
        break;
      case 'device_token':
      case 'deviceToken':
        deviceToken = value;
        break;
      case 'role_type':
      case 'roleType':
        roleType = value;
        break;
      case 'approval_status':
      case 'approvalStatus':
        approvalStatus = value;
        break;
      case 'registration_number':
      case 'registrationNumber':
        registrationNumber = value;
        break;
      case 'department':
        department = value;
        break;
      case 'batch_duration':
      case 'batchDuration':
        batchDuration = value;
        break;
      case 'phone_number':
      case 'phoneNumber':
        phoneNumber = value;
        break;
      case 'gender':
        gender = value;
        break;
      case 'campus':
        campus = value;
        break;
      case 'phone_verified_at':
      case 'phoneVerifiedAt':
        phoneVerifiedAt = value;
        break;
      case 'approved_at':
      case 'approvedAt':
        approvedAt = value;
        break;
      case 'approved_by':
      case 'approvedBy':
        approvedBy = value;
        break;
      case 'rejected_reason':
      case 'rejectedReason':
        rejectedReason = value;
        break;
      case 'email_verified_or_approval_sent_at':
      case 'emailVerifiedOrApprovalSentAt':
        emailVerifiedOrApprovalSentAt = value;
        break;
      case 'created_at':
      case 'createdAt':
        createdAt = value;
        break;
      case 'updated_at':
      case 'updatedAt':
        updatedAt = value;
        break;
      case 'followingStatus':
        followingStatus = value;
        break;
      case 'is_moderator':
      case 'isModerator':
        isModerator = value;
        break;
      case 'saved_music_ids':
      case 'savedMusicIds':
        savedMusicIds = value;
        break;
      case 'saved_reel_ids':
      case 'savedReelIds':
        savedReelIds = value;
        break;
    }
  }

  String firebaseId() {
    return "${id ?? 0}";
  }

  bool isAllStoryShown() {
    var isWatched = true;
    for (var element in (stories ?? [])) {
      if (!element.isWatchedByMe()) {
        isWatched = false;
        break;
      }
    }
    return isWatched;
  }

  bool isBlockedByMe() {
    return SessionManager.shared.getUser()?.blockUserIds?.split(',').contains('$id') ?? false;
  }
}

extension O on User {
  List<String> getInterestsStringList() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests = SessionManager.shared.getSettings()?.interests?.where((element) {
          return arr.contains("${element.id}");
        }).toList() ??
        [];

    return interests.map((e) => e.title ?? "").toList();
  }

  List<Interest> getInterests() {
    List<String> arr = (interestIds ?? '').split(',');
    List<Interest> interests = SessionManager.shared.getSettings()?.interests?.where((element) {
          return arr.contains("${element.id}");
        }).toList() ??
        [];

    return interests;
  }

  List<int> getSavedMusicIdsList() {
    List<String> arr = (savedMusicIds ?? '').split(',');

    return arr.map((e) => int.tryParse(e) ?? 0).toList();
  }

  List<int> getSavedReelIdsList() {
    List<String> arr = (savedReelIds ?? '').split(',');

    return arr.map((e) => int.tryParse(e) ?? 0).toList();
  }

  ///Use this
  FollowStatus get followStatus {
    return FollowStatus.values.firstWhere(
      (element) => element.value == (followingStatus?.toInt() ?? 0),
    );
  }
}

enum FollowStatus {
  noFollowNo(0),
  heFollowsMe(1),
  iFollowHim(2),
  weFollowEachOther(3);

  /// koi ek bija ne follow nathi kartu to 0
  /// same valo mane follow kar che to 1
  /// hu same vala ne follow karu chu to 2
  /// banne ek bija ne follow kare to 3

  final int value;

  const FollowStatus(this.value);
}
