import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/newtworkHandler.dart';



class LoginRegisterProvider extends ChangeNotifier{
  String? _token;
  get token=> _token;

  NetworkHandler networkHandler= NetworkHandler();
  final storage = new FlutterSecureStorage();

  bool _isloading =false;
  get isloading => _isloading;

  Future<void> writeTokenToLocal(String value)async{
    await storage.write(key: 'token', value: value );
  }

  loginOrRegister(String url, Map<String, String> data)async {
    _isloading = true;
    notifyListeners();
    http.Response _responseLoginOrRegister = await networkHandler.post1(url, data);
    var resData = await json.decode(_responseLoginOrRegister.body);
    if (_responseLoginOrRegister.statusCode == 200 ||
        _responseLoginOrRegister.statusCode == 201) {
      await writeTokenToLocal(resData['token']);
      _token= await networkHandler.readTokenFromLocal();
      notifyListeners();

      _isloading = false;
      notifyListeners();

      return resData;
    }
    else{
      _isloading = false;
      notifyListeners();

      return resData;
    }
  }
}