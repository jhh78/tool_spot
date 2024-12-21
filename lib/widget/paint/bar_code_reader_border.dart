import 'package:flutter/material.dart';

class BarCodeReaderBorder extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double cornerLength = 20;

    // Draw barcode icon in the center
    const icon = Icons.format_align_justify_outlined;
    final textStyle = TextStyle(
      fontSize: 40,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage,
      color: Colors.white.withAlpha(150),
    );
    final textSpan = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Save the current canvas state
    canvas.save();

    // Translate to the center of the icon
    canvas.translate(offset.dx + textPainter.width / 2, offset.dy + textPainter.height / 2);

    // Rotate the canvas by 90 degrees (π/2 radians)
    canvas.rotate(90 * 3.1415927 / 180);

    // Translate back to the original position
    canvas.translate(-textPainter.width / 2, -textPainter.height / 2);

    // Draw the icon
    textPainter.paint(canvas, Offset.zero);

    // Restore the canvas to its original state
    canvas.restore();

    // textPainter.paint(canvas, offset);

    // Top-left corner
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-left corner
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
