import 'package:get/get_navigation/src/root/internacionalization.dart';

class TranslateText extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          // 공통으로 사용됨
          'mainHomeTitle': '메인 화면',
          'showAdDescription': '광고를 시청하면 포인트를 얻을 수 있습니다\n광고를 시청하시겠습니까?',
          'showAd': '광고보기',
          'copiedText': '복사되었습니다',
          'dataNotFound': '데이터가 없습니다',

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

          // 나라별 휴일
          'holidayCalender': '휴일',
          'holidayCalenderTitle': '국가별 휴일',
          'holidayCalenderNeedCountry': '휴일을 확인하려면 나라를 선택해주세요',
          'holidayCalenderPrev': '작년',
          'holidayCalenderNext': '내년',

          // zip code search
          'zipcodeSearchTitle': '우편번호검색',
          'zipcodeSearchHintText': '하이픈(-)을 제외한 숫자만 입력해주세요',
          'zipcodeSearchHelperText': '우편번호를 입력해주세요',

          // 알람
          'alarm': '알람',
          'alarmTitle': '인실좃알람',
        },
        'ja_JP': {
          // 공통으로 사용됨
          'mainHomeTitle': 'メイン画面',
          'showAdDescription': '広告を見るとポイントを獲得できます。\n広告を見ますか？',
          'showAd': '広告を見る',
          'copiedText': 'コピーされました',
          'dataNotFound': 'データがありません',

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

          // 나라별 휴일
          'holidayCalender': '休日',
          'holidayCalenderTitle': '国別休日',
          'holidayCalenderNeedCountry': '休日を確認するには国を選択してください',
          'holidayCalenderPrev': '去年',
          'holidayCalenderNext': '来年',

          // zip code search
          'zipcodeSearchTitle': '郵便番号検索',
          'zipcodeSearchHintText': 'ハイフン（-）を除いた数字のみを入力してください',
          'zipcodeSearchHelperText': '郵便番号を入力してください',

          // 알람
          'alarm': 'アラーム',
          'alarmTitle': '命懸アラーム',
        },
        'en_US': {
          // 공통으로 사용됨
          'mainHomeTitle': 'Main Screen',
          'showAdDescription': 'You can earn points by watching ads.\nWould you like to watch an ad?',
          'showAd': 'Watch Ad',
          'copiedText': 'Copied',
          'dataNotFound': 'No data',

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

          // 나라별 휴일
          'holidayCalender': 'Holiday',
          'holidayCalenderTitle': 'Holiday Calender',
          'holidayCalenderNeedCountry': 'Please select a country to check the holiday',
          'holidayCalenderPrev': 'Prev',
          'holidayCalenderNext': 'Next',

          // zip code search
          'zipcodeSearchTitle': 'Zip Code Search',
          'zipcodeSearchHintText': 'Enter only numbers excluding hyphens (-)',
          'zipcodeSearchHelperText': 'Enter the zip code',

          // 알람
          'alarm': 'Alarm',
          'alarmTitle': 'Life Alarm',
        },
      };
}
