import 'package:meta/meta.dart';
import '../provider/callApi.dart';

class LoginRepository{
  final CallApi callapi;
  LoginRepository({required this.callapi});
  RequestHttp(uri,map) async {
    return await callapi.RequestHttp(uri, map);
  }
}