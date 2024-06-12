import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

Future<double> compareImages(String path1, String path2) async {
  // Load images asynchronously from asset bundle
  final imageBytes1 = await loadImageBytes(path1);
  final imageBytes2 = await loadImageBytes(path2);

  // Decode images
  img.Image image1 = img.decodeImage(imageBytes1.buffer.asUint8List())!;
  img.Image image2 = img.decodeImage(imageBytes2.buffer.asUint8List())!;

  // Ensure images have the same dimensions
  if (image1.width != image2.width || image1.height != image2.height) {
    print('Images must have the same dimensions for comparison.');
    return 0.0;
  }

  // Calculate pixel difference
  int pixelDiff = calculatePixelDifference(image1, image2);

  // Calculate total pixels
  int totalPixels = image1.width * image1.height;

  // Calculate similarity ratio
  double similarity = 1 - (pixelDiff / (totalPixels * 3 * 255)); // Adjust for RGB channels

  // Print or use the similarity result
  print('Image similarity: ${(similarity * 100).toStringAsFixed(2)}%');

  return similarity;
}

Future<ByteData> loadImageBytes(String assetPath) async {
  ByteData byteData = await rootBundle.load(assetPath);
  return byteData;
}

int calculatePixelDifference(img.Image image1, img.Image image2) {
  int pixelDiff = 0;

  for (int y = 0; y < image1.height; y++) {
    for (int x = 0; x < image1.width; x++) {
      int pixel1 = image1.getPixel(x, y);
      int pixel2 = image2.getPixel(x, y);

      // Calculate RGB differences
      int rDiff = img.getRed(pixel1) - img.getRed(pixel2);
      int gDiff = img.getGreen(pixel1) - img.getGreen(pixel2);
      int bDiff = img.getBlue(pixel1) - img.getBlue(pixel2);

      // Accumulate total difference
      pixelDiff += (rDiff.abs() + gDiff.abs() + bDiff.abs());
    }
  }

  return pixelDiff;
}
