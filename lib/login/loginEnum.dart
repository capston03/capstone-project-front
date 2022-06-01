import 'package:capstone_android/login/signUp.dart';

enum Login {LOGIN_SUCCESS, USER_IS_ALREADY_LOGGED_IN, USER_ACCOUNT_IS_NOT_EXISTED}
enum Logout {LOGOUT_SUCCESS, USER_IS_ALREADY_LOGGED_OUT, USER_ACCOUNT_IS_NOT_EXISTED}
enum Signup {SIGNUP_SUCCESS, NOT_VALID_USER_INFO, NICKNAME_IS_ALREADY_USED,ACCOUNT_IS_ALREADY_EXISTED}
enum Nick {EXISTED, NOT_VALID_USER_INFO, NOT_EXISTED}


extension LoginEnum on Login{
  String get value{
    switch(this){
      case Login.LOGIN_SUCCESS:
        return 'success';
      case Login.USER_IS_ALREADY_LOGGED_IN:
        return 'already_logged_in';
      case Login.USER_ACCOUNT_IS_NOT_EXISTED:
        return 'account_not_existed';
    }
  }
  Login isIt(dynamic value){
    switch(value){
      case 'success':
        return Login.LOGIN_SUCCESS;
      case 'already_logged_in':
        return Login.USER_IS_ALREADY_LOGGED_IN;
      case 'account_not_existed':
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
        return 'account_not_existed';
      case Logout.LOGOUT_SUCCESS:
        return 'success';
      case Logout.USER_IS_ALREADY_LOGGED_OUT:
        return 'already_logged_out';
    }
  }
  Logout isIt(dynamic value){
    switch(value){
      case 'account_not_existed':
        return Logout.USER_ACCOUNT_IS_NOT_EXISTED;
      case 'success':
        return Logout.LOGOUT_SUCCESS;
      case 'already_logged_out':
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
        return 'nickname_already_used';
      case Signup.ACCOUNT_IS_ALREADY_EXISTED:
        return 'gmail_id_already_used';
      case Signup.NOT_VALID_USER_INFO:
        return 'invalid_input';
      case Signup.SIGNUP_SUCCESS:
        return 'success';
    }
  }
  Signup isIt(dynamic value){
    switch(value){
      case 'gmail_id_already_used':
        return Signup.ACCOUNT_IS_ALREADY_EXISTED;
      case 'success':
        return Signup.SIGNUP_SUCCESS;
      case 'nickname_already_used':
        return Signup.NICKNAME_IS_ALREADY_USED;
      case 'invalid_input':
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
        return 'already_used';
      case Nick.NOT_VALID_USER_INFO:
        return 'invalid_input';
      case Nick.NOT_EXISTED:
        return 'valid';

    }
  }
  Nick isIt(dynamic value){
    switch(value){
      case 'valid':
        return Nick.NOT_EXISTED;
      case 'invalid_input':
        return Nick.NOT_VALID_USER_INFO;
      case 'already_used':
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