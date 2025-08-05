import 'package:flutter_test/flutter_test.dart';
import 'package:diaryx/utils/tag_validator.dart';

void main() {
  group('TagValidator International Tests', () {
    group('Valid Tags', () {
      test('should accept English tags', () {
        expect(TagValidator.validateTag('flutter'), isNull);
        expect(TagValidator.validateTag('mobile_app'), isNull);
        expect(TagValidator.validateTag('tech2024'), isNull);
      });

      test('should accept Chinese tags', () {
        expect(TagValidator.validateTag('移动应用'), isNull);
        expect(TagValidator.validateTag('技术'), isNull);
        expect(TagValidator.validateTag('程序员'), isNull);
        expect(TagValidator.validateTag('開發者'), isNull);
        expect(TagValidator.validateTag('軟體工程'), isNull);
      });

      test('should accept Japanese tags', () {
        expect(TagValidator.validateTag('プログラミング'), isNull);
        expect(TagValidator.validateTag('アプリ開発'), isNull);
        expect(TagValidator.validateTag('こんにちは'), isNull);
        expect(TagValidator.validateTag('モバイル'), isNull);
      });

      test('should accept Korean tags', () {
        expect(TagValidator.validateTag('프로그래밍'), isNull);
        expect(TagValidator.validateTag('앱개발'), isNull);
        expect(TagValidator.validateTag('모바일'), isNull);
        expect(TagValidator.validateTag('한국어'), isNull);
      });

      test('should accept Arabic tags', () {
        expect(TagValidator.validateTag('البرمجة'), isNull);
        expect(TagValidator.validateTag('تطبيق'), isNull);
        expect(TagValidator.validateTag('تقنية'), isNull);
      });

      test('should accept Cyrillic tags', () {
        expect(TagValidator.validateTag('программирование'), isNull);
        expect(TagValidator.validateTag('приложение'), isNull);
        expect(TagValidator.validateTag('технологии'), isNull);
      });

      test('should accept Hindi/Devanagari tags', () {
        expect(TagValidator.validateTag('प्रोग्रामिंग'), isNull);
        expect(TagValidator.validateTag('ऐप'), isNull);
        expect(TagValidator.validateTag('तकनीक'), isNull);
      });

      test('should accept mixed language tags', () {
        expect(TagValidator.validateTag('flutter中文'), isNull);
        expect(TagValidator.validateTag('app日本語'), isNull);
        expect(TagValidator.validateTag('tech한국어'), isNull);
        expect(TagValidator.validateTag('mobile_عربي'), isNull);
      });

      test('should accept tags with numbers', () {
        expect(TagValidator.validateTag('flutter2024'), isNull);
        expect(TagValidator.validateTag('app版本2'), isNull);
        expect(TagValidator.validateTag('プログラム123'), isNull);
      });

      test('should accept tags with underscores', () {
        expect(TagValidator.validateTag('mobile_app'), isNull);
        expect(TagValidator.validateTag('flutter_dev'), isNull);
        expect(TagValidator.validateTag('tech_2024'), isNull);
      });
    });

    group('Invalid Tags', () {
      test('should reject empty tags', () {
        expect(TagValidator.validateTag(''), isNotNull);
        expect(TagValidator.validateTag(' '), isNotNull);
        expect(TagValidator.validateTag('   '), isNotNull);
      });

      test('should reject tags with spaces', () {
        expect(TagValidator.validateTag('mobile app'), isNotNull);
        expect(TagValidator.validateTag('flutter dev'), isNotNull);
        expect(TagValidator.validateTag('移动 应用'), isNotNull);
        expect(TagValidator.validateTag('プログラミング 開発'), isNotNull);
      });

      test('should reject tags with hash symbols', () {
        expect(TagValidator.validateTag('#flutter'), isNotNull);
        expect(TagValidator.validateTag('#移动应用'), isNotNull);
        expect(TagValidator.validateTag('#プログラミング'), isNotNull);
      });

      test('should reject tags with only numbers', () {
        expect(TagValidator.validateTag('123'), isNotNull);
        expect(TagValidator.validateTag('2024'), isNotNull);
        expect(TagValidator.validateTag('999'), isNotNull);
      });

      test('should reject tags with only numbers and underscores', () {
        expect(TagValidator.validateTag('123_456'), isNotNull);
        expect(TagValidator.validateTag('_999_'), isNotNull);
        expect(TagValidator.validateTag('___'), isNotNull);
      });

      test('should reject tags with invalid punctuation', () {
        expect(TagValidator.validateTag('flutter!'), isNotNull);
        expect(TagValidator.validateTag('app@dev'), isNotNull);
        expect(TagValidator.validateTag('tech\$money'), isNotNull);
        expect(TagValidator.validateTag('mobile%app'), isNotNull);
        expect(TagValidator.validateTag('flutter.dart'), isNotNull);
        expect(TagValidator.validateTag('app,dev'), isNotNull);
      });

      test('should reject tags that are too long', () {
        final longTag = 'a' * 101;
        expect(TagValidator.validateTag(longTag), isNotNull);
      });

      test('should reject tags with whitespace characters', () {
        expect(TagValidator.validateTag('flutter\ndev'), isNotNull);
        expect(TagValidator.validateTag('app\tname'), isNotNull);
        expect(TagValidator.validateTag('tech\r\ncode'), isNotNull);
      });
    });

    group('Sanitization', () {
      test('should sanitize tags by removing invalid characters', () {
        expect(TagValidator.sanitizeTag('flutter!@#'), equals('flutter'));
        expect(TagValidator.sanitizeTag('#移动应用'), equals('移动应用'));
        expect(TagValidator.sanitizeTag('プログラミング!!!'), equals('プログラミング'));
        expect(TagValidator.sanitizeTag('app dev'), equals('appdev'));
      });

      test('should return null for unsanitizable tags', () {
        expect(TagValidator.sanitizeTag('123!@#'), isNull);
        expect(TagValidator.sanitizeTag('___!!!'), isNull);
        expect(TagValidator.sanitizeTag(''), isNull);
      });
    });

    group('Convenience Methods', () {
      test('isValidTag should work correctly', () {
        expect(TagValidator.isValidTag('flutter'), isTrue);
        expect(TagValidator.isValidTag('移动应用'), isTrue);
        expect(TagValidator.isValidTag('プログラミング'), isTrue);
        expect(TagValidator.isValidTag('mobile app'), isFalse);
        expect(TagValidator.isValidTag('#flutter'), isFalse);
        expect(TagValidator.isValidTag('123'), isFalse);
      });
    });
  });
}
