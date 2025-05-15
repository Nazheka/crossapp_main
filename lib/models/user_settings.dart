class UserSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool isPrivateAccount;

  UserSettings({
    required this.isDarkMode,
    required this.notificationsEnabled,
    required this.isPrivateAccount,
  });

  factory UserSettings.defaultSettings() => UserSettings(
        isDarkMode: true,
        notificationsEnabled: true,
        isPrivateAccount: false,
      );

  UserSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? isPrivateAccount,
  }) {
    return UserSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isPrivateAccount: isPrivateAccount ?? this.isPrivateAccount,
    );
  }

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'notificationsEnabled': notificationsEnabled,
        'isPrivateAccount': isPrivateAccount,
      };

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        isDarkMode: json['isDarkMode'] ?? true,
        notificationsEnabled: json['notificationsEnabled'] ?? true,
        isPrivateAccount: json['isPrivateAccount'] ?? false,
      );
} 