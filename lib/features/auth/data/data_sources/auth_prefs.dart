import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/employee.dart';

import '../../domain/entities/permissions.dart';

const String kEmployee = 'Employee';
const String kIsUserLoggedInKey = "is user logged in";
const String kCanWork = "kCanWork";
const String kAddsManagement = "kAddsManagement";
const String kCompanyManagement = "kCompanyManagement";
const String kCoursesManagement = "kCoursesManagement";
const String kEmployeeManagement = "kEmployeeManagement";
const String kNewsManagement = "kNewsManagement";
const String kStoreManagement = "kStoreManagement";
const String kOffersManagement = "kOffersManagement";
const String kIsRejected = "kIsRejected";
const String kTechnicalSupport = "kTechnicalSupport";

class AuthPreferences {
  final SharedPreferences _sharedPreferences;

  AuthPreferences(this._sharedPreferences);

  bool isUserLoggedIn() {
    return _sharedPreferences.getBool(kIsUserLoggedInKey) ?? false;
  }

  void setEmployee(Employee employee) {
    _sharedPreferences.setString(kEmployee, employee.toJson());
  }

  Employee getEmployee(Employee employee) {
    Employee employee;
    employee = Employee.fromJson(_sharedPreferences.getString(kEmployee) ?? '');

    return employee;
  }

  void setUserLoggedIn() {
    _sharedPreferences.setBool(kIsUserLoggedInKey, true);
  }

  void setUserLoggedOut() {
    _sharedPreferences.setBool(kIsUserLoggedInKey, false);
  }

  Future<void> setPermission(Permissions permissions) async {
    await _sharedPreferences.setBool(kCanWork, permissions.canWork);
  }

  bool canWork() {
    return _sharedPreferences.getBool(kCanWork) ?? false;
  }

  bool addsManagement() {
    return (_sharedPreferences.getBool(kAddsManagement) ?? false) && canWork() && !isRejected();
  }

  bool storeManagement() {
    return (_sharedPreferences.getBool(kStoreManagement) ?? false) && canWork() && !isRejected();
  }

  bool companyManagement() {
    return (_sharedPreferences.getBool(kCompanyManagement) ?? false) && canWork() && !isRejected();
  }

  bool coursesManagement() {
    return (_sharedPreferences.getBool(kCoursesManagement) ?? false) && canWork() && !isRejected();
  }

  bool employeeManagement() {
    return (_sharedPreferences.getBool(kEmployeeManagement) ?? false) && canWork() && !isRejected();
  }

  bool newsManagement() {
    return (_sharedPreferences.getBool(kNewsManagement) ?? false) && canWork();
  }

  bool isRejected() {
    return _sharedPreferences.getBool(kIsRejected) ?? false;
  }

  bool offersManagement() {
    return (_sharedPreferences.getBool(kOffersManagement) ?? false) && canWork() && !isRejected();
  }

  bool technicalSupport() {
    return (_sharedPreferences.getBool(kTechnicalSupport) ?? false) && canWork() && !isRejected();
  }
}
