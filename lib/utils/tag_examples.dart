/// Examples of valid and invalid tags for international tag system
///
/// This file demonstrates the tag validation rules with examples
/// from different languages and scripts.
class TagExamples {
  /// Valid tag examples from different languages
  static const List<String> validTags = [
    // English and European languages
    'flutter',
    'mobile_app',
    'tech2024',
    'café',
    'naïve',
    'Zürich',

    // Chinese (Simplified and Traditional)
    '移动应用',
    '技术',
    '程序员',
    '開發者',
    '軟體工程',
    'app中文',

    // Japanese (Hiragana, Katakana, Kanji)
    'プログラミング',
    'アプリ開発',
    'こんにちは',
    'モバイル',
    'flutter日本語',

    // Korean (Hangul)
    '프로그래밍',
    '앱개발',
    '모바일',
    '한국어',
    'flutter한글',

    // Arabic
    'البرمجة',
    'تطبيق',
    'تقنية',
    'flutter_عربي',

    // Cyrillic (Russian, Bulgarian, etc.)
    'программирование',
    'приложение',
    'технологии',
    'flutter_русский',

    // Devanagari (Hindi, Sanskrit)
    'प्रोग्रामिंग',
    'ऐप',
    'तकनीक',
    'flutter_हिंदी',

    // Thai
    'โปรแกรมมิง',
    'แอปพลิเคชัน',
    'flutter_ไทย',

    // Greek
    'προγραμματισμός',
    'εφαρμογή',
    'flutter_ελληνικά',

    // Hebrew
    'תכנות',
    'יישום',
    'flutter_עברית',

    // Mixed scripts (common in modern usage)
    'flutter中文',
    'app日本語',
    'tech한국어',
    'mobile_عربي',
    'code_русский',

    // With numbers
    'flutter2024',
    'app版本2',
    'プログラム123',
    'tech_v1',

    // With underscores
    'mobile_app',
    'flutter_dev',
    'tech_2024',
    'open_source',
  ];

  /// Invalid tag examples that will fail validation
  static const List<String> invalidTags = [
    // Empty or whitespace
    '',
    ' ',
    '   ',

    // Contains spaces
    'mobile app',
    'flutter dev',
    'hello world',
    '移动 应用',
    'プログラミング 開発',

    // Contains hash symbol
    '#flutter',
    '#移动应用',
    '#プログラミング',

    // Only numbers
    '123',
    '2024',
    '999',

    // Only underscores and numbers
    '123_456',
    '_999_',
    '___',

    // Contains invalid punctuation
    'flutter!',
    'app@dev',
    'tech\$money',
    'mobile%app',
    'flutter.dart',
    'app,dev',
    'tech;code',
    'flutter:dart',
    'app"name"',
    "app'name'",
    'flutter(dev)',
    'app[name]',
    'tech{code}',
    'flutter<dart>',
    'app|dev',
    'tech\\code',
    'flutter/dart',
    'app=dev',
    'tech+plus',
    'flutter-dart',
    'app*star',
    'tech^power',
    'flutter&dart',

    // Contains newlines or tabs
    'flutter\ndev',
    'app\tname',
    'tech\r\ncode',

    // Too long (over 100 characters)
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    '移动应用开发技术栈包括前端后端数据库服务器部署运维测试自动化持续集成持续部署微服务架构云原生容器化技术移动应用开发技术栈包括前端后端数据库服务器部署运维测试',
  ];

  /// Get a random valid tag example
  static String getRandomValidTag() {
    return validTags[(DateTime.now().millisecondsSinceEpoch) %
        validTags.length];
  }

  /// Get examples for a specific language/script
  static List<String> getExamplesForScript(String script) {
    switch (script.toLowerCase()) {
      case 'chinese':
      case 'zh':
        return validTags
            .where((tag) => RegExp(r'[\u4e00-\u9fff]').hasMatch(tag))
            .toList();

      case 'japanese':
      case 'ja':
        return validTags
            .where(
              (tag) => RegExp(
                r'[\u3040-\u309f\u30a0-\u30ff\u4e00-\u9fff]',
              ).hasMatch(tag),
            )
            .toList();

      case 'korean':
      case 'ko':
        return validTags
            .where((tag) => RegExp(r'[\uac00-\ud7af]').hasMatch(tag))
            .toList();

      case 'arabic':
      case 'ar':
        return validTags
            .where((tag) => RegExp(r'[\u0600-\u06ff]').hasMatch(tag))
            .toList();

      case 'russian':
      case 'cyrillic':
      case 'ru':
        return validTags
            .where((tag) => RegExp(r'[\u0400-\u04ff]').hasMatch(tag))
            .toList();

      case 'hindi':
      case 'devanagari':
      case 'hi':
        return validTags
            .where((tag) => RegExp(r'[\u0900-\u097f]').hasMatch(tag))
            .toList();

      default:
        return validTags
            .where((tag) => RegExp(r'^[a-zA-Z]').hasMatch(tag))
            .toList();
    }
  }
}
