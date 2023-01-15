import 'package:image_picker/image_picker.dart';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class EmployeeImages {
  XFile? id;
  XFile? address;
  XFile? personal;
  XFile? bankIBAN;
  XFile? commercial;
  XFile? headquarters;
}
