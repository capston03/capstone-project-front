import 'package:capstone_android/login/signUp.dart';

enum Login {LOGIN_SUCCESS, USER_IS_ALREADY_LOGGED_IN, USER_ACCOUNT_IS_NOT_EXISTED}
enum Logout {LOGOUT_SUCCESS, USER_IS_ALREADY_LOGGED_OUT, USER_ACCOUNT_IS_NOT_EXISTED}
enum Signup {SIGNUP_SUCCESS, NOT_VALID_USER_INFO, NICKNAME_IS_ALREADY_USED,ACCOUNT_IS_ALREADY_EXISTED}
enum Nick {EXISTED, NOT_VALID_USER_INFO, NOT_EXISTED}


extension LoginEnum on Login{
  String get value{
    switch(this){
      case Login.LOGIN_SUCCESS:
        return 'LOGIN_SUCCESS';
      case Login.USER_IS_ALREADY_LOGGED_IN:
        return 'USER_IS_ALREADY_LOGGED_IN';
      case Login.USER_ACCOUNT_IS_NOT_EXISTED:
        return 'USER_ACCOUNT_IS_NOT_EXISTED';
    }
  }
  Login isIt(dynamic value){
    switch(value){
      case 'LOGIN_SUCCESS':
        return Login.LOGIN_SUCCESS;
      case 'USER_IS_ALREADY_LOGGED_IN':
        return Login.USER_IS_ALREADY_LOGGED_IN;
      case 'USER_ACCOUNT_IS_NOT_EXISTED':
        return Login.USER_ACCOUNT_IS_NOT_EXISTED;

    }
    return Login.LOGIN_SUCCESS;
  }
  bool isEqual(dynamic value){
    if(value is String){
      return this.value == value;
    }
    return false;
  }
}
extension LogoutEnum on Logout{
  String get value{
    switch(this){
      case Logout.USER_ACCOUNT_IS_NOT_EXISTED:
        return 'USER_ACCOUNT_IS_NOT_EXISTED';
      case Logout.LOGOUT_SUCCESS:
        return 'LOGOUT_SUCCESS';
      case Logout.USER_IS_ALREADY_LOGGED_OUT:
        return 'USER_IS_ALREADY_LOGGED_OUT';
    }
  }
  Logout isIt(dynamic value){
    switch(value){
      case 'USER_ACCOUNT_IS_NOT_EXISTED':
        return Logout.USER_ACCOUNT_IS_NOT_EXISTED;
      case 'LOGOUT_SUCCESS':
        return Logout.LOGOUT_SUCCESS;
      case 'USER_IS_ALREADY_LOGGED_OUT':
        return Logout.USER_IS_ALREADY_LOGGED_OUT;

    }
    return Logout.LOGOUT_SUCCESS;
  }
  bool isEqual(dynamic value){
    if(value is String){
      return this.value == value;
    }
    return false;
  }
}

extension SignupEnum on Signup{
  String get value{
    switch(this){
      case Signup.NICKNAME_IS_ALREADY_USED:
        return 'NICKNAME_IS_ALREADY_USED';
      case Signup.ACCOUNT_IS_ALREADY_EXISTED:
        return 'ACCOUNT_IS_ALREADY_EXISTED';
      case Signup.NOT_VALID_USER_INFO:
        return 'NOT_VALID_USER_INFO';
      case Signup.SIGNUP_SUCCESS:
        return 'SIGNUP_SUCCESS';
    }
  }
  Signup isIt(dynamic value){
    switch(value){
      case 'ACCOUNT_IS_ALREADY_EXISTED':
        return Signup.ACCOUNT_IS_ALREADY_EXISTED;
      case 'SIGNUP_SUCCESS':
        return Signup.SIGNUP_SUCCESS;
      case 'NICKNAME_IS_ALREADY_USED':
        return Signup.NICKNAME_IS_ALREADY_USED;
      case 'NOT_VALID_USER_INFO':
        return Signup.NOT_VALID_USER_INFO;

    }
    return Signup.SIGNUP_SUCCESS;
  }
  bool isEqual(dynamic value){
    if(value is String){
      return this.value == value;
    }
    return false;
  }
}

extension NickEnum on Nick{
  String get value{
    switch(this){
      case Nick.EXISTED:
        return 'EXISTED';
      case Nick.NOT_VALID_USER_INFO:
        return 'NOT_VALID_USER_INFO';
      case Nick.NOT_EXISTED:
        return 'NOT_EXISTED';

    }
  }
  Nick isIt(dynamic value){
    switch(value){
      case 'NOT_EXISTED':
        return Nick.NOT_EXISTED;
      case 'NOT_VALID_USER_INFO':
        return Nick.NOT_VALID_USER_INFO;
      case 'EXISTED':
        return Nick.EXISTED;

    }
    return Nick.EXISTED;
  }
  bool isEqual(dynamic value){
    if(value is String){
      return this.value == value;
    }
    return false;
  }
}