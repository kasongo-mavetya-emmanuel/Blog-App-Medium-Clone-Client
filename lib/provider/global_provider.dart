import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/newtworkHandler.dart';

class GlobalProvider extends ChangeNotifier{

  NetworkHandler networkHandler= NetworkHandler();
  final storage = new FlutterSecureStorage();



  decodeResponse(response)async{
    return await json.decode(response.body);
  }



  addImage(String blogId, filepath)async{
    var res=  await networkHandler.patchImage('/blogs/${blogId}', filepath);
    var decoded= decodeResponse(res);
    print('afkaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$decoded');
    if(res.statusCode==200|| res.statusCode==201){

      return decoded;
    }
    else{
      return decoded;
    }
  }


  bool _isPatchingArticle=false;
  get isPatchingArticle=> _isPatchingArticle;


  patchArticle(Map body, String blogId)async{
    _isPatchingArticle=true;
    notifyListeners();
    http.Response _resPatchArticle= await networkHandler.patch('/blogs/${blogId}', body);
    var decoded= decodeResponse(_resPatchArticle);
    _isPatchingArticle=false;
    notifyListeners();

    return decoded;
  }


  bool _isPatchingProfile=false;
  get isPatchingProfile=> _isPatchingProfile;


  patchProfile(Map body, filepath)async{
    _isPatchingProfile=true;
    notifyListeners();
    if(filepath!=null){
      await networkHandler.patchProfileImage('/users/updateMe', filepath);
    }
    http.Response _resPatchProfile= await networkHandler.patch('/users/updateMe', body);
    var decoded= decodeResponse(_resPatchProfile);
    _isPatchingProfile=false;
    notifyListeners();

    return decoded;
  }



  bool _isPatchingPassword=false;
  get isPatchingPassword=> _isPatchingPassword;


  patchPassword(Map body)async{
    _isPatchingPassword=true;
    notifyListeners();
    http.Response _resPatchPassword= await networkHandler.patch('/users/updateMyPassword', body);
    var decoded= await decodeResponse(_resPatchPassword);

    await storage.write(key: 'token', value: decoded['token']);
    _isPatchingPassword=false;
    notifyListeners();

    return decoded;
  }

}
