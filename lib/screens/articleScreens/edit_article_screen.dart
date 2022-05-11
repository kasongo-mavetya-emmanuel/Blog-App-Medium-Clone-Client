import 'dart:convert';

import 'package:blog_app/provider/homepage_level_provider.dart';
import 'package:blog_app/provider/global_provider.dart';
import 'package:blog_app/services/newtworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'hide Text;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:provider/provider.dart';



class EditArticleScreen extends StatefulWidget {
  var blog;
  bool? readingOnly;
  EditArticleScreen( {Key? key,this.readingOnly=false, required this.blog}) : super(key: key);
  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  get blog => widget.blog;
  QuillController _controller = QuillController.basic();
  @override
  void initState() {
    checkBlogContentExist();
    super.initState();
  }

  Future checkBlogContentExist()async{
    if(blog['blog']['content']==''){
      _controller.clear();
    }

    else{
      print('print${blog['blog']['content']}');

      //var myJSON = await jsonDecode(blog['blog']['content']);
      _controller= QuillController(document:Document.fromJson(blog['blog']['content']) , selection: TextSelection.collapsed(offset: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:
            context.watch<GlobalProvider>().isPatchingArticle==true?Center(child: CircularProgressIndicator(),):
        Column(
          children: [

            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.readingOnly ==true?Container():InkWell(
                  onTap: saveDraft,
                  child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Save',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      )),
                ),
                widget.readingOnly ==true?Container():InkWell(
                  onTap: publish,
                  child: Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Publish',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  )),
                ),
            ],),
            Divider(height: 20,),

            widget.readingOnly ==true?Container(): QuillToolbar.basic(
                controller: _controller,
                onImagePickCallback: _onImagePickCallback,
            ),
            Divider(height: 15,),
            Expanded(
              child: Container(
                child: QuillEditor.basic(
                  controller: _controller,
                  readOnly: widget.readingOnly!, // true for view only mode
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void publish()async{
   // var insertNewLine=  _controller.document.insert(_controller.document.length, {"\n"});
    var json = await jsonEncode(_controller.document.toDelta().toJson());
    var result=  Provider.of<GlobalProvider>(context, listen: false).patchArticle({
      'content':json,
      'published': true,
    }, blog['blog']['_id']);

    if(result['status']=='success'){
      Fluttertoast.showToast(
          msg: 'drafted',
          toastLength: Toast.LENGTH_LONG ,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16,
          timeInSecForIosWeb: 1);
    }

    else if(result['status']=='fail'){
      Fluttertoast.showToast(
          msg: result['data'],
          toastLength: Toast.LENGTH_LONG ,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16,
          timeInSecForIosWeb: 1);
    }

    print('asadasfdg$json');

  }

  void saveDraft()async{
    var json = await jsonEncode(_controller.document.toDelta().toJson());
    var result= await Provider.of<GlobalProvider>(context,listen: false).patchArticle({
      'content':json,
      'published': false,
    }, blog['blog']['_id']);



    if(result['status']=='success'){
      Fluttertoast.showToast(
          msg: 'drafted',
          toastLength: Toast.LENGTH_LONG ,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16,
          timeInSecForIosWeb: 1);
    }

    else if(result['status']=='fail'){
      Fluttertoast.showToast(
          msg: result['data'],
          toastLength: Toast.LENGTH_LONG ,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16,
          timeInSecForIosWeb: 1);
    }

    print('asadasfdg$json');

  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    // final appDocDir = await getApplicationDocumentsDirectory();
    // final copiedFile =
    // await file.copy('${appDocDir.path}/${basename(file.path)}');
    // return copiedFile.path.toString();
     final copiedFile= await Provider.of<GlobalProvider>(context, listen: false).addImage(blog['blog']['_id'], file.path);

       return copiedFile['status']=='success'? NetworkHandler().getImagePath('/blogs/${copiedFile['data']['filename']}') :copiedFile['data'];


  }
}
