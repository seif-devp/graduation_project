import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graduation_project/core/utils/avatar_utils.dart';

void main() {
  group('getSafeAvatarImageProvider', () {
    test('returns null for empty or invalid avatar URLs', () {
      expect(getSafeAvatarImageProvider(null), isNull);
      expect(getSafeAvatarImageProvider(''), isNull);
      expect(getSafeAvatarImageProvider('not-a-url'), isNull);
    });

    test('returns a network image provider for a valid http URL', () {
      final provider =
          getSafeAvatarImageProvider('https://example.com/avatar.png');

      expect(provider, isNotNull);
      expect(provider, isA<NetworkImage>());
    });
  });
}
