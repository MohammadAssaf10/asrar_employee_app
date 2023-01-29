import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/employee.dart';
import '../models/requests.dart';

const String employeeCollectionPath = 'Employees';

class FirebaseAuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  }

  Future<void> resetPassword(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
