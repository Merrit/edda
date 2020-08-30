import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:reader/helpers/check_file_type.dart';

void main() {
  group('file with extension', () {
    test(
      "epub",
      () {
        var file =
            File('assets/Lewis Carroll - Alices Adventures in Wonderland.epub');
        String result = checkFileType(file);
        expect(result, '.epub');
      },
    );
    test(
      "webp",
      () {
        var file = File('assets/cover.webp');
        String result = checkFileType(file);
        expect(result, '.webp');
      },
    );
  });
  test('file with no extension', () {});
}
