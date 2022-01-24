import 'package:email_validator/email_validator.dart';

abstract class Validator {
  bool validateEmail(String email) {
    return EmailValidator.validate(email);
  }
  //Min 1 Uppercase
  //Min 1 Lowercase
  //Min 1 Numeric Number
  //Min 1 Special
  //Allowed (! @ # $ & * ~ \)
  bool validatePassword(String password){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
  bool validateFirestation(String firestation){
    String pattern = "FF [A-Z][a-z]*";
    RegExp reg = RegExp(pattern);
    return reg.hasMatch(firestation);
  }
}