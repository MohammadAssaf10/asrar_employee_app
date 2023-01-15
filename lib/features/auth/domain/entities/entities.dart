import 'dart:io';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class EmployeeImages {
  File? id;
  File? address;
  File? personal;
  File? bankIBAN;
  File? commercial;
  File? headquarters;

  bool isAllFieldsFiled() {
    if (id != null &&
        address != null &&
        personal != null &&
        bankIBAN != null &&
        commercial != null &&
        headquarters != null) return true;

    return false;
  }

  @override
  String toString() {
    return 'EmployeeImages(id: $id, address: $address, personal: $personal, bankIBAN: $bankIBAN, commercial: $commercial, headquarters: $headquarters)';
  }
}

class EmployeeTextFields {
  String? name;
  String? phonNumber;
  String? email;
  String? password;
  String? idNumber;
  String? national;

  bool isAllFieldsFiled() {
    if (name != null &&
        phonNumber != null &&
        email != null &&
        password != null &&
        idNumber != null &&
        national != null) {
      return true;
    }

    return false;
  }
}
