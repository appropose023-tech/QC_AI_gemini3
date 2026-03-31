import 'dart:ui';

class DefectBox {
  final double x, y, w, h;

  static const double backendWidth = 3679;
  static const double backendHeight = 1717;

  DefectBox(this.x, this.y, this.w, this.h);

  Rect scale(double previewW, double previewH) {
    double scaleX = previewW / backendWidth;
    double scaleY = previewH / backendHeight;

    return Rect.fromLTWH(
      x * scaleX,
      y * scaleY,
      w * scaleX,
      h * scaleY,
    );
  }
}
