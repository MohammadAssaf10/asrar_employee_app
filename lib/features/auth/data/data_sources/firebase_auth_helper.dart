import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/repo/storage_file_repository_impl.dart';
import '../../domain/entities/employee.dart';
import '../models/requests.dart';

const String employeeCollectionPath = 'Employees';

class FirebaseAuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageFileRepository _fileRepository = StorageFileRepository();

  Future<Employee> login(LoginRequest loginRequest) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: loginRequest.email, password: loginRequest.password);

    return await getEmployee(loginRequest.email);
  }

  Future<Employee> getEmployee(String email) async {
    final employeeMap =
        (await _firestore.collection(employeeCollectionPath).doc(email).get())
            .data();

    if (employeeMap == null) {
      throw FirebaseAuthException(code: "auth/user-not-found");
    }

    return Employee.fromMap(employeeMap);
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<Employee> register(RegisterRequest registerRequest) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: registerRequest.email, password: registerRequest.password);

    await _firestore
        .collection(employeeCollectionPath)
        .doc(registerRequest.email)
        .set({
      "name": registerRequest.name,
      "phonNumber": registerRequest.phonNumber,
      "email": registerRequest.email,
      "idNumber": registerRequest.idNumber,
      "national": registerRequest.national,
    });

    return await getEmployee(registerRequest.email);

// todo delete this
    // await _fileRepository.uploadFile(registerRequest.id,
    //     '$employees/$thisEmployeePath/id.${registerRequest.id.getExtension()}');
    // await _fileRepository.uploadFile(registerRequest.address,
    //     '$employees/$thisEmployeePath/address.${registerRequest.address.getExtension()}');
    // await _fileRepository.uploadFile(registerRequest.personal,
    //     '$employees/$thisEmployeePath/personal.${registerRequest.personal.getExtension()}');
    // await _fileRepository.uploadFile(registerRequest.bankIBAN,
    //     '$employees/$thisEmployeePath/bankIBAN.${registerRequest.bankIBAN.getExtension()}');
    // await _fileRepository.uploadFile(registerRequest.commercial,
    //     '$employees/$thisEmployeePath/commercial.${registerRequest.commercial.getExtension()}');
    // await _fileRepository.uploadFile(registerRequest.headquarters,
    //     '$employees/$thisEmployeePath/headquarters.${registerRequest.headquarters.getExtension()}');
  }

  Future<void> resetPassword(String email) async {
    throw UnimplementedError();
  }
}
