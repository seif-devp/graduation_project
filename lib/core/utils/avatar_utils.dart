import 'package:flutter/material.dart';

ImageProvider? getSafeAvatarImageProvider(String? avatarUrl) {
  if (avatarUrl == null || avatarUrl.trim().isEmpty) {
    return null;
  }

  final normalizedUrl = avatarUrl.trim();
  final isRemote = normalizedUrl.startsWith('http://') ||
      normalizedUrl.startsWith('https://');

  if (!isRemote) {
    return null;
  }

  return NetworkImage(normalizedUrl);
}
