import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart'as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
//import 'package:http_parser/http_parser.dart';


class NetworkHandler{
  var baseUrl="http://192.168.43.212:3000/api/v1";

  final storage = new FlutterSecureStorage();

  String formater(String url){
    return baseUrl+url;
  }

  Future readTokenFromLocal()async{
    String? token= await storage.read(key: 'token');

    print(token);
    return token;
  }



  Future<dynamic> get(String url)async{
    String? token= await storage.read(key: 'token');
     if(token!=null){
       http.Response response= await http.get(Uri.parse(formater(url)),headers: {
         "Content-type": "application/json",
         "Authorization": "Bearer $token"
       },);
       print(token);
       print('dssfggggggggggggggrrrrrrrrrcccccccccc$response');

       return response;
     }


  }

  Future<dynamic> post(String url, Map<String, String > body)async
  {
    String? token= await storage.read(key: 'token');

    http.Response response= await http.post(Uri.parse(formater(url)),
      headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
      },
      body: json.encode(body), );
      return response;


  }

  Future<http.Response> post1(String url, Map body) async {
    url = formater(url);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-type": "application/json",
      },
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> patchImage(String url, String filepath) async {
    String? token= await storage.read(key: 'token');
    print('aaaadlccccccccccccccccccccccc$token');
    print('aaaadlccccccccccccccccccccccc$url');
    print('aaaadlccccccccccccccccccccccc$filepath');
    url = formater(url);
    final  mimeTypeData= lookupMimeType(filepath)!.split('/');
    print('aaaadlccccccccccccccccccccccc$mimeTypeData');
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("image", filepath, contentType:MediaType(mimeTypeData[0], mimeTypeData[1])));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = await request.send();
    var res= await http.Response.fromStream(response);
    print('aaaadlccccccccccccccccccccccc${res.body}');
    return res;
  }

  Future patchProfileImage(String url, filepath) async {
    String? token= await storage.read(key: 'token');
    print('aaaadlccccccccccccccccccccccc$token');
    print('aaaadlccccccccccccccccccccccc$url');
    print('aaaadlccccccccccccccccccccccc$filepath');
    url = formater(url);
    final  mimeTypeData= lookupMimeType(filepath)!.split('/');
    print('aaaadlccccccccccccccccccccccc$mimeTypeData');
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("photo", filepath, contentType:MediaType(mimeTypeData[0], mimeTypeData[1])));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = await request.send();
    print('aaaadlccccccccccccccccccccccc$response');
    return response;
  }

  Future<http.Response> patch(String url, Map body) async {
    String? token= await storage.read(key: 'token');
    print('aaaadlccccccccccccccccccccccc$token');
    print('aaaadlccccccccccccccccccccccc$body');
    print('aaaadlccccccccccccccccccccccc$url');
    var response = await http.patch(
      Uri.parse(formater(url)),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body),
    );
    return response;
  }

   getImagePath(String imageName){
    return 'http://192.168.43.212:3000/img/$imageName';
   }




}