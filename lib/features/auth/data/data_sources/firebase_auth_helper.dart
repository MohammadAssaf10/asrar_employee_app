import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/employee.dart';
import '../models/requests.dart';

const String employeeCollectionPath = 'Employees';

class FirebaseAuthHelper {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<Employee> login(LoginRequest loginRequest) async {
    final employee= (await _firebaseAuth.signInWithEmailAndPassword(
            email: loginRequest.email, password: loginRequest.password))
        .user;
    return await getEmployee(employee!.uid);
  }

  Future<Employee> getEmployee(String id) async {
    final employeeMap =
        (await _firestore.collection(employeeCollectionPath).doc(id).get())
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
    var firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: registerRequest.email, password: registerRequest.password);

    List<String> employeeTokenList = await addUserToken(firebaseUser.user!.uid);
    registerRequest = registerRequest.copyWith(
        employeeID: firebaseUser.user!.uid,
        employeeTokenList: employeeTokenList);

    await _firestore
        .collection(employeeCollectionPath)
        .doc(registerRequest.employeeID)
        .set(registerRequest.toMap());

    return await getEmployee(registerRequest.employeeID);
  }

  Future<void> resetPassword(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteUser() async {
    User? user = getCurrentUser();

    if (user != null) {
      return await user.delete();
    }
  }

  Future<void> deleteEmployeeData(String id) async {
    return await _firestore
        .collection(employeeCollectionPath)
        .doc(id)
        .delete();
  }

  Future<void> deleteEmployeeImages(String email) async {
    var t = (await _storage.ref('employees/$email').listAll()).items;
    for (var i in t) {
      await i.delete();
    }
  }

  Future<List<String>> createAndAddToEmployeeListToken(
      String employeeID, String? token) async {
    List<String> employeeTokenList = [];
    if (token != null) employeeTokenList.add(token);
    await _firestore
        .collection(employeeCollectionPath)
        .doc(employeeID)
        .set({'employeeTokenList': employeeTokenList});

    return employeeTokenList;
  }

  Future<List<String>> addUserToken(String employeeID) async {
    final String? userToken = await _messaging.getToken();
    final userDoc = await _firestore
        .collection(employeeCollectionPath)
        .doc(employeeID)
        .get();

    try {
      final List<String> employeeTokenList =
          userDoc['employeeTokenList']?.cast<String>() ?? [];

      if (userToken != null && !employeeTokenList.contains(userToken)) {
        employeeTokenList.add(userToken);
        await _firestore
            .collection(employeeCollectionPath)
            .doc(employeeID)
            .update({"employeeTokenList": employeeTokenList});
      }

      return employeeTokenList;
    } catch (e) {
      return createAndAddToEmployeeListToken(employeeID, userToken);
    }
  }

  Future<void> deleteUserToken(String employeeID) async {
    final String? employeeToken = await _messaging.getToken();
    if (employeeToken != null) {
      final userDoc = await _firestore
          .collection(employeeCollectionPath)
          .doc(employeeID)
          .get();
      final List employeeTokenList = userDoc['employeeTokenList'];
      if (employeeTokenList.contains(employeeToken)) {
        employeeTokenList.remove(employeeToken);
        await _firestore
            .collection(employeeCollectionPath)
            .doc(employeeID)
            .update({"employeeTokenList": employeeTokenList});
      }
    }
  }
}
