import 'package:get/get_navigation/src/root/internacionalization.dart';

class TranslateText extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          // 공통으로 사용됨
          'mainHomeTitle': '메인 화면',
          'language_ko': '한국어',
          'language_en': '영어',
          'language_ja': '일본어',

          // Menu Text
          'QrReader': 'QR 리더',

          // Button Text
          'close': '닫기',
          'accessSite': '사이트 접속',

          // QR Reader Screen
          'qrReaderTitle': 'QR 리더',
          'qrReaderDescription': 'QR 코드를 스캔하여 정보를 확인하세요.',
          'qrModalTitle': 'QR코드를 감지하였습니다',
          'qrModalDescription': '사이트를 이동하시기전에 주소를 확인해주세요',
        },
        'ja_JP': {
          // 공통으로 사용됨
          'mainHomeTitle': 'メイン画面',
          'language_ko': '韓国語',
          'language_en': '英語',
          'language_ja': '日本語',

          // Menu Text
          'QrReader': 'QRリーダー',

          // Button Text
          'close': '閉じる',
          'accessSite': 'サイトアクセス',

          // QR Reader Screen
          'qrReaderTitle': 'QRリーダー',
          'qrReaderDescription': 'QRコードをスキャンして情報を確認してください。',
          'qrModalTitle': 'QRコードを検出しました',
          'qrModalDescription': 'アクセスする前にアドレスを確認してください',
        },
        'en_US': {
          // 공통으로 사용됨
          'mainHomeTitle': 'Main Screen',
          'language_ko': 'Korean',
          'language_en': 'English',
          'language_ja': 'Japanese',

          // Menu Text
          'QrReader': 'QR Reader',

          // Button Text
          'close': 'Close',
          'accessSite': 'Access Site',

          // QR Reader Screen
          'qrReaderTitle': 'QR Reader',
          'qrReaderDescription': 'Scan the QR code to check the information.',
          'qrModalTitle': 'Barcode Detected',
          'qrModalDescription': 'Please check the address before accessing the site.',
        },
      };
}
