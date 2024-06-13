/*chat gpt used*/

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<double> compareImages(String path1, String path2) async {

  log('$path1, $path2 이거 왜 안돼냐고요');
  // Load images asynchronously from asset bundle
  final imageBytes1 = await loadImageFileAsUint8List(path1);
  final imageBytes2 = await loadImageFileAsUint8List(path2);

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

Future<Uint8List> loadImageFileAsUint8List(String imagePath) async {
  // Read file as bytes
  File imageFile = File(imagePath);
  Uint8List bytes = await imageFile.readAsBytes();

  return bytes;
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
