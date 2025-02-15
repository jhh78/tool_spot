import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PictureToPdfScreen extends StatefulWidget {
  @override
  _PictureToPdfScreenState createState() => _PictureToPdfScreenState();
}

class _PictureToPdfScreenState extends State<PictureToPdfScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _convertImageToPdf() async {
    if (_image == null) return;

    final pdf = pw.Document();
    final image = pw.MemoryImage(_image!.readAsBytesSync());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    // 권한 요청
    if (await _requestPermissions()) {
      // 공용 사진 폴더 경로 가져오기
      final directory = await getExternalStorageDirectory();
      final downloadDirectory = Directory('${directory!.path}/Download');
      final file = File("${downloadDirectory.path}/example.pdf");

      // 다운로드 폴더가 없으면 생성
      if (!await downloadDirectory.exists()) {
        await downloadDirectory.create(recursive: true);
      }

      await file.writeAsBytes(await pdf.save());

      print('PDF saved to ${file.path}');
    } else {
      print('Permission denied');
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image to PDF'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Container(
                    width: 300, // 원하는 너비로 조정
                    height: 300, // 원하는 높이로 조정
                    child: Image.file(
                      _image!,
                      fit: BoxFit.contain, // 이미지를 컨테이너 크기에 맞게 조정
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertImageToPdf,
              child: Text('Convert to PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
