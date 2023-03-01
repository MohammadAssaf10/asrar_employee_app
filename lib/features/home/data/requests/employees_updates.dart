import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeUpdatesRequest {
  String employeeID;
  Timestamp timeStamp;
  String oldName;
  String newName;
  String oldPhoneNumber;
  String newPhoneNumber;
  String oldImageName;
  String newImageName;
  String oldImageURL;
  String newImageURL;

  EmployeeUpdatesRequest({
    required this.employeeID,
    required this.timeStamp,
    this.oldName='',
    this.newName='',
    this.oldPhoneNumber='',
    this.newPhoneNumber='',
    this.oldImageName='',
    this.newImageName='',
    this.oldImageURL='',
    this.newImageURL='',
  });

  Map<String, dynamic> toMap() {
    return {
      'employeeID': employeeID,
      'timeStamp': timeStamp,
      'oldName': oldName,
      'newName': newName,
      'oldPhoneNumber': oldPhoneNumber,
      'newPhoneNumber': newPhoneNumber,
      'oldImageName': oldImageName,
      'newImageName': newImageName,
      'oldImageURL': oldImageURL,
      'newImageURL': newImageURL,
    };
  }

  EmployeeUpdatesRequest copyWith({
    String? employeeID,
    Timestamp? timeStamp,
    String? oldName,
    String? newName,
    String? oldPhoneNumber,
    String? newPhoneNumber,
    String? oldImageName,
    String? newImageName,
    String? oldImageURL,
    String? newImageURL,
  }) {
    return EmployeeUpdatesRequest(
      employeeID: employeeID ?? this.employeeID,
      timeStamp: timeStamp ?? this.timeStamp,
      oldName: oldName ?? this.oldName,
      newName: newName ?? this.newName,
      oldPhoneNumber: oldPhoneNumber ?? this.oldPhoneNumber,
      newPhoneNumber: newPhoneNumber ?? this.newPhoneNumber,
      oldImageName: oldImageName ?? this.oldImageName,
      newImageName: newImageName ?? this.newImageName,
      oldImageURL: oldImageURL ?? this.oldImageURL,
      newImageURL: newImageURL ?? this.newImageURL,
    );
  }
}
