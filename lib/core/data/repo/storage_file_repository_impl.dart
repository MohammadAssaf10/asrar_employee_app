import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../exception_handler.dart';
import '../failure.dart';

class StorageFileRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;

  /// upload file to firebase storage
  ///
  /// the [path] will be the full path in firebase storage including the name and the type of file
  Future<Either<Failure, TaskSnapshot>> uploadFile(
      File file, String path) async {
    try {
      return Right(await storage.ref(path).putFile(file));
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}
