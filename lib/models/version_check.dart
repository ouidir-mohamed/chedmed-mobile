import 'dart:convert';

class VersionCheckResponse {
  final int valid;
  VersionCheckResponse({
    required this.valid,
  });

  Map<String, dynamic> toMap() {
    return {
      'valid': valid,
    };
  }

  factory VersionCheckResponse.fromJson(Map<String, dynamic> map) {
    return VersionCheckResponse(
      valid: map['valid']?.toInt() ?? 0,
    );
  }

  VersionCheck getVersionCheck() {
    switch (valid) {
      case 0:
        return VersionCheck.REQUIRED;
      case 1:
        return VersionCheck.OPTIONAL;
      case 2:
        return VersionCheck.UP_TO_DATE;
      default:
        return VersionCheck.UP_TO_DATE;
    }
  }
}

class VersionCheckRequest {
  final int buildNumber;
  VersionCheckRequest({
    required this.buildNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'buildNumber': buildNumber,
    };
  }
}

enum VersionCheck { UP_TO_DATE, OPTIONAL, REQUIRED }
