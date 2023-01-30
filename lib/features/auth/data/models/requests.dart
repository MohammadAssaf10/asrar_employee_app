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
  String name;
  String phonNumber;
  String email;
  String password;
  String idNumber;
  String national;

  File id;
  File address;
  File personal;
  File bankIBAN;
  File commercial;
  File headquarters;

  RegisterRequest(
    this.name,
    this.phonNumber,
    this.email,
    this.password,
    this.idNumber,
    this.national,
    this.id,
    this.address,
    this.personal,
    this.bankIBAN,
    this.commercial,
    this.headquarters,
  );

  RegisterRequest.fromObject(EmployeeTextFields textFields, EmployeeImages images)
      : name = textFields.name!,
        phonNumber = textFields.phonNumber!,
        email = textFields.email!,
        password = textFields.password!,
        idNumber = textFields.idNumber!,
        national = textFields.national!,
        id = images.id!,
        address = images.address!,
        personal = images.personal!,
        bankIBAN = images.bankIBAN!,
        commercial = images.commercial!,
        headquarters = images.headquarters!;
}
