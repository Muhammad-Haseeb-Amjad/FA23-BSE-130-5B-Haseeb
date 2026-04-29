import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

// Run with: dart run tool/check_image.dart
// This is a standalone script — it reads the PNG directly without Flutter.

void main() async {
  final file = File('lib/assets/tasbeeh.png');
  if (!file.existsSync()) {
    print('File not found: lib/assets/tasbeeh.png');
    exit(1);
  }

  final bytes = file.readAsBytesSync();
  print('File size: ${bytes.length} bytes');

  // Read PNG IHDR for dimensions
  // PNG signature: 8 bytes, then IHDR chunk: 4 len + 4 type + 13 data
  // Width at offset 16, Height at offset 20
  final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
  final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
  print('PNG dimensions: ${width}x${height}');
  print('Aspect ratio: ${(width / height).toStringAsFixed(4)}');
  print('');
  print('Since the image is ${width}x${height} and the container is square,');
  print('BoxFit.contain will scale to fit the smaller dimension.');
  if (width < height) {
    final scale = 1.0;
    final letterboxTop = (1.0 - width / height) / 2;
    print('Image is taller than wide. Letterboxing on left/right.');
    print('Opaque rect approx: left=${((1.0 - width/height)/2).toStringAsFixed(4)} top=0.0 right=${(1.0 - (1.0 - width/height)/2).toStringAsFixed(4)} bottom=1.0');
  } else if (height < width) {
    final letterboxTop = (1.0 - height / width) / 2;
    print('Image is wider than tall. Letterboxing on top/bottom.');
    print('Opaque rect approx: left=0.0 top=${letterboxTop.toStringAsFixed(4)} right=1.0 bottom=${(1.0 - letterboxTop).toStringAsFixed(4)}');
  } else {
    print('Image is square. No letterboxing. Opaque rect = (0,0,1,1)');
  }
}
