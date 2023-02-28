import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/entities.dart';

class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequest {
  String employeeID;
  String name;
  String phoneNumber;
  String email;
  String password;
  String idNumber;
  String national;

  File idImage;
  File address;
  File personal;
  File bankIBAN;
  File commercial;
  File headquarters;

  RegisterRequest(
    this.employeeID,
    this.name,
    this.phoneNumber,
    this.email,
    this.password,
    this.idNumber,
    this.national,
    this.idImage,
    this.address,
    this.personal,
    this.bankIBAN,
    this.commercial,
    this.headquarters,
  );

  RegisterRequest.forTest(this.email, File file)
      : employeeID = '',
        name = '',
        phoneNumber = '',
        password = '123456',
        idNumber = '',
        national = '',
        idImage = file,
        address = file,
        personal = file,
        bankIBAN = file,
        commercial = file,
        headquarters = file;

  RegisterRequest.fromObject(EmployeeTextFields textFields, EmployeeImages images)
      : employeeID = '',
        name = textFields.name!,
        phoneNumber = textFields.phonNumber!,
        email = textFields.email!,
        password = textFields.password!,
        idNumber = textFields.idNumber!,
        national = textFields.national!,
        idImage = images.id!,
        address = images.address!,
        personal = images.personal!,
        bankIBAN = images.bankIBAN!,
        commercial = images.commercial!,
        headquarters = images.headquarters!;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'employeeID': employeeID});
    result.addAll({'name': name});
    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'email': email});
    result.addAll({'password': password});
    result.addAll({'idNumber': idNumber});
    result.addAll({'national': national});

    return result;
  }

  RegisterRequest copyWith({
    String? employeeID,
    String? name,
    String? phoneNumber,
    String? email,
    String? password,
    String? idNumber,
    String? national,
    File? idImage,
    File? address,
    File? personal,
    File? bankIBAN,
    File? commercial,
    File? headquarters,
  }) {
    return RegisterRequest(
      employeeID ?? this.employeeID,
      name ?? this.name,
      phoneNumber ?? this.phoneNumber,
      email ?? this.email,
      password ?? this.password,
      idNumber ?? this.idNumber,
      national ?? this.national,
      idImage ?? this.idImage,
      address ?? this.address,
      personal ?? this.personal,
      bankIBAN ?? this.bankIBAN,
      commercial ?? this.commercial,
      headquarters ?? this.headquarters,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(employeeID: $employeeID, name: $name, phoneNumber: $phoneNumber, email: $email, password: $password, idNumber: $idNumber, national: $national, idImage: $idImage, address: $address, personal: $personal, bankIBAN: $bankIBAN, commercial: $commercial, headquarters: $headquarters)';
  }
}
