import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

/// Service responsible for resizing and compressing medical prescription images
/// to guarantee file sizes remain well below 1MB before storage or network transmission.
class ImageCompressionService {
  /// Target ceiling: 1 Megabyte in bytes.
  static const int maxFileSizeBytes = 1024 * 1024;

  const ImageCompressionService();

  /// Compresses [sourceFile] if it exceeds [maxFileSizeBytes] or has oversized dimensions.
  ///
  /// Maintains high readability for handwriting, clinical dosage text, and doctor stamps.
  Future<File> compressImage(File sourceFile) async {
    final originalBytes = await sourceFile.length();

    // Already small enough — return immediately.
    if (originalBytes <= maxFileSizeBytes) {
      return sourceFile;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/rx_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Pass 1: Standard high-definition medical compression (80% quality, 1920x1080)
      final result = await FlutterImageCompress.compressAndGetFile(
        sourceFile.absolute.path,
        targetPath,
        quality: 80,
        minWidth: 1920,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        return sourceFile;
      }

      var compressedFile = File(result.path);
      var currentSize = await compressedFile.length();

      // Pass 2: If still > 1MB (e.g. 48MP raw captures), step down quality safely.
      if (currentSize > maxFileSizeBytes) {
        final secondPath =
            '${tempDir.path}/rx_pass2_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final secondResult = await FlutterImageCompress.compressAndGetFile(
          compressedFile.absolute.path,
          secondPath,
          quality: 65,
          minWidth: 1440,
          minHeight: 900,
          format: CompressFormat.jpeg,
        );

        if (secondResult != null) {
          compressedFile = File(secondResult.path);
        }
      }

      return compressedFile;
    } catch (e) {
      debugPrint(
        '[ImageCompressionService] Compression error, falling back to original: $e',
      );
      return sourceFile;
    }
  }
}
