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
          'showAdDescription': '광고를 시청하면 포인트를 얻을 수 있습니다\n광고를 시청하시겠습니까?',
          'showAd': '광고보기',
          'copiedText': '복사되었습니다',

          // errors
          'error': '오류가 발생하였습니다',
          'lackPoints': '포인트가 부족합니다',
          'requiredData': '테이터를 입력해주세요',
          'translateError': '번역에 실패하였습니다\n올바른 주소를 입력해주세요',
          'duplicateData': '중복입력입니다.',

          // setting menu
          'pointAdd': '포인트 추가',

          // Button Text
          'close': '닫기',
          'accessSite': '사이트 접속',
          'detailInfo': '상세정보',

          // QR Reader Screen
          'qrReaderTitle': 'QR스캔',
          'qrModalTitle': 'QR코드를 감지하였습니다',
          'qrModalDescription': '사이트를 이동하시기전에 주소를 확인해주세요',

          // Todo Screen
          'todoTitle': '할일',

          // Address Translate Screen
          'addressTranslate': '주소변환',
          'addressTextFieldHinttext': '변환할 주소를 입력해주세요',
          'translateButton': '변환하기(-20pt)',

          // 근무표
          'timeSheet': '근무표',
          'workSummary': '근무내역',
          'workStart': '출근',
          'workEnd': '퇴근',
          'workRefresh': '휴식',
          'workRefreshTimeSetting': '휴식시간 설정',
          'workGraph': '통계',
          'workTotal': '총시간',
          'workTimeUpdateFail': '출근시간이 없거나\n퇴근시간이 존재합니다',
          'workTimeDetail': '시간변경',
          'workTimeUpdateFormUpdate': '근무시간 수정하기',
        },
        'ja_JP': {
          // 공통으로 사용됨
          'mainHomeTitle': 'メイン画面',
          'language_ko': '韓国語',
          'language_en': '英語',
          'language_ja': '日本語',
          'showAdDescription': '広告を見るとポイントを獲得できます。\n広告を見ますか？',
          'showAd': '広告を見る',
          'copiedText': 'コピーされました',

          // errors
          'error': 'エラーが発生しました',
          'lackPoints': 'ポイントが足りないです',
          'requiredData': 'データを入力してください',
          'translateError': '翻訳に失敗しました\n正しいアドレスを入力してください',
          'duplicateData': '重複入力です',

          // setting menu
          'pointAdd': 'ポイント追加',

          // Menu Text
          'QrReader': 'QRリーダー',
          'Todo': 'やること',

          // Button Text
          'close': '閉じる',
          'accessSite': 'サイトアクセス',
          'detailInfo': '詳細情報',

          // QR Reader Screen
          'qrReaderTitle': 'QRリーダー',
          'qrModalTitle': 'QRコードを検出しました',
          'qrModalDescription': 'アクセスする前にアドレスを確認してください',

          // Todo Screen
          'todoTitle': 'やること',

          // Address Translate Screen
          'addressTranslate': '住所変換',
          'addressTextFieldHinttext': '変換する住所を入力してください',
          'translateButton': '変換する（-20pt）',

          // 勤務表
          'timeSheet': '勤務表',
          'workSummary': '勤務履歴',
          'workStart': '出勤',
          'workEnd': '退勤',
          'workRefresh': '休憩',
          'workRefreshTimeSetting': '休憩時間設定',
          'workGraph': '統計',
          'workTotal': '合計',
          'workTimeUpdateFail': '出勤時間がないか\n退勤時間が存在します',
          'workTimeDetail': '時間変更',
          'workTimeUpdateFormUpdate': '勤務時間変更',
        },
        'en_US': {
          // 공통으로 사용됨
          'mainHomeTitle': 'Main Screen',
          'language_ko': 'Korean',
          'language_en': 'English',
          'language_ja': 'Japanese',
          'showAdDescription': 'You can earn points by watching ads.\nWould you like to watch an ad?',
          'showAd': 'Watch Ad',
          'copiedText': 'Copied',

          // errors
          'error': 'An error occurred',
          'lackPoints': 'Lack of points',
          'requiredData': 'Please enter the data',
          'translateError': 'Translation failed\nPlease enter a valid address',
          'duplicateData': 'Duplicate input',

          // setting menu
          'pointAdd': 'Add Point',

          // Menu Text
          'QrReader': 'QR Reader',
          'Todo': 'Todo',

          // Button Text
          'close': 'Close',
          'accessSite': 'Access Site',
          'detailInfo': 'Detail Info',

          // QR Reader Screen
          'qrReaderTitle': 'QR Reader',
          'qrModalTitle': 'Barcode Detected',
          'qrModalDescription': 'Please check the address before accessing the site.',

          // Todo Screen
          'todoTitle': 'Todo',

          // Address Translate Screen
          'addressTranslate': 'Address Translate',
          'addressTextFieldHinttext': 'Enter the address to convert',
          'translateButton': 'Translate(-20pt)',

          // time sheet
          'timeSheet': 'time sheet',
          'workSummary': 'work summary',
          'workStart': 'work start',
          'workEnd': 'work end',
          'workRefresh': 'work refresh',
          'workRefreshTimeSetting': 'time setting',
          'workGraph': 'work graph',
          'workTotal': 'total',
          'workTimeUpdateFail': 'There is no start time\nor there is an end time',
          'workTimeDetail': 'time detail',
          'workTimeUpdateFormUpdate': 'work time update',
        },
      };
}
