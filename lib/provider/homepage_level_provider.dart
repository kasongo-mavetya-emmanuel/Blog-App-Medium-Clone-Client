import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../services/newtworkHandler.dart';

class HomePageLevelProvider extends ChangeNotifier {

  HomePageLevelProvider() {
    otherBlogs();
    getBookMarks();
    fetchProfileData();
    fetchMyBlogs();

  }

  NetworkHandler networkHandler = NetworkHandler();


  decodeResponse(response) async {
    return await json.decode(response.body);
  }


  //PROFILE FUNCTIONS

  var _profileDetails = {};

  get profileDetails => _profileDetails;

  fetchProfileData() async {
    http.Response res = await this.networkHandler.get('/users/me');
    var decoded = await this.decodeResponse(res);

    print('fgdfsgrwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$decoded');

    if (res.statusCode == 200 || res.statusCode == 201) {
      _profileDetails = decoded;
      notifyListeners();
    }
    else {
      _profileDetails = decoded;
      notifyListeners();
    }
  }

  bool _isCreating = false;
  get isCreating => _isCreating;

  createArticle() async {
    _isCreating = true;
    notifyListeners();
    http.Response res = await networkHandler.post('/blogs/', {});
    Map decoded = await decodeResponse(res);
    print('woewqqqqqqqqqqqqqqqqqqqqqqqq$decoded');
    if (res.statusCode == 200 || res.statusCode == 201) {
      _isCreating = false;
      notifyListeners();
      return decoded;
    }
    else {
      _isCreating = false;
      notifyListeners();
      return decoded;
    }
  }



  var _myDraftedBlogs= {'status':'','message':'', 'content':[]};
  var _myPublishedBlogs= {'status':'','message':'', 'content':[]};
  get myDraftedBlogs => _myDraftedBlogs;
  get myPublishedBlogs => _myPublishedBlogs;

  bool _isLoadingMyBlogs=false;
  get isLoadingMyBlogs =>_isLoadingMyBlogs;

  fetchMyBlogs() async {
    _isLoadingMyBlogs=true;
    notifyListeners();
    http.Response res = await this.networkHandler.get('/blogs/Myblogs');
    print('fgdfsgffffffffffffffffffffffffffffffwww${res.body}');

    var decoded = await this.decodeResponse(res);

    print('fgdfsgffffffffffffffffffffffffffffffwww$decoded');

    if (res.statusCode == 200 || res.statusCode == 201) {
      List drafted=[];
      List published=[];
      for(Map e in decoded['data']['blogs']){
        if(e['published']==false){
          e['content']=await jsonDecode(e['content']);
          drafted.add(e);
          notifyListeners();
        }
        else if(e['published']==true){
          e['content']=await jsonDecode(e['content']);
          published.add(e);
          notifyListeners();
        }
      }
      _myPublishedBlogs['content']=published;
      notifyListeners();
      _myDraftedBlogs['content']=drafted;
      notifyListeners();
      _isLoadingMyBlogs=false;
      notifyListeners();

    }
    else {

      _myDraftedBlogs ['status']= decoded['status'];
      _myDraftedBlogs ['message']= decoded['message'];
      notifyListeners();
      _myPublishedBlogs ['status']= decoded['status'];
      _myPublishedBlogs ['message']= decoded['message'];
      notifyListeners();
      _isLoadingMyBlogs=false;
      notifyListeners();
    }
  }


  var _otherBlogs={};
  get otherblogs => _otherBlogs;

  bool _isLoadingOtherBlog=false;
  get isLoadingOtherBlog =>_isLoadingOtherBlog;


  otherBlogs() async {
    _isLoadingOtherBlog=true;
    notifyListeners();
    http.Response res = await this.networkHandler.get('/blogs/');

    var decoded = await this.decodeResponse(res);


    if (res.statusCode == 200 || res.statusCode == 201) {

      for(int i=0; i<decoded['data']['blogs'].length; i++){

        decoded['data']['blogs'][i]['content'] =await jsonDecode( decoded['data']['blogs'][i]['content']);

      }

      _otherBlogs=await decoded;

      notifyListeners();

      _isLoadingOtherBlog=false;
         notifyListeners();


    }
    else {

      _otherBlogs=decoded;
      notifyListeners();
      _isLoadingOtherBlog=false;
      notifyListeners();

    }
  }
  
  Map _bookMarks={};
  get bookMarks=> _bookMarks;

  bool _isLoadingBookMarks=false;
  get isLoadingBookMarks=> _isLoadingBookMarks;
  
  getBookMarks()async{
    _isLoadingBookMarks=true;
    notifyListeners();
    http.Response res= await networkHandler.get('/bookMarks/');
    var decoded= await decodeResponse(res);
    print('fgdfsgrwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$decoded');

    if(res.statusCode==200|| res.statusCode==201){

      for(int i=0; i<decoded['data']['bookMarks'].length; i++){
        decoded['data']['bookMarks'][i]['blog']['content'] =await jsonDecode( decoded['data']['bookMarks'][i]['blog']['content']);
      }
      print('fgdfsgrwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww$decoded');

      _bookMarks=decoded;
      notifyListeners();
      _isLoadingBookMarks=false;
      notifyListeners();
    }else{
      _bookMarks= decoded;
      _isLoadingBookMarks=false;
      notifyListeners();
    }
  }

  bool _isCreatingBookMarks=false;
  get isCreatingBookMarks=> _isCreatingBookMarks;
  
  createBookMark(String blogId)async{
    http.Response res= await networkHandler.post('/bookMarks/${blogId}',{});
    var resData= await decodeResponse(res);

    if(res.statusCode==200|| res.statusCode==201){
      _isCreatingBookMarks=false;
      notifyListeners();
        print('dsjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj$resData');
      return resData;
    }else{

      _isCreatingBookMarks=false;
      notifyListeners();
      return resData;
    }
  }

}

