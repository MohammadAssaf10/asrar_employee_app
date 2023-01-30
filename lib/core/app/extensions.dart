import 'dart:io';

extension NullOrEmpty on String? {
  bool nullOrEmpty() {
    if (this == null || this!.isEmpty) return true;
    return false;
  }
}

extension FileE on File {
  String getExtension() {
     return path.split('.').last;
  }
}
