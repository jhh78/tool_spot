import 'package:get/get_navigation/src/root/internacionalization.dart';

class TranslateText extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          'mainHomeTitle': '메인 화면',
          'language_ko': '한국어',
          'language_en': '영어',
          'language_ja': '일본어',
        },
        'ja_JP': {
          'mainHomeTitle': 'メイン画面',
          'language_ko': '韓国語',
          'language_en': '英語',
          'language_ja': '日本語',
        },
        'en_US': {
          'mainHomeTitle': 'Main Screen',
          'language_ko': 'Korean',
          'language_en': 'English',
          'language_ja': 'Japanese',
        },
      };
}
