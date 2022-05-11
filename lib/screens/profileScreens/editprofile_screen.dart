import 'package:blog_app/provider/global_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../services/newtworkHandler.dart';

class EditProfileScreen extends StatefulWidget {
   EditProfileScreen({Key? key, this.details}) : super(key: key);

  var details;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController _name=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _profession=TextEditingController();
  TextEditingController _dob=TextEditingController();
  TextEditingController _title=TextEditingController();
  TextEditingController _about=TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  GlobalKey _formKey= GlobalKey<FormState>();

  @override
  void initState() {
    checkProfileExist();
    super.initState();
  }

  void checkProfileExist(){
    if(widget.details != {}){
      _name.text= widget.details['user']['name'] ?? '';
      _email.text=widget.details['user']['email'] ?? '';
      _profession.text= widget.details['user']['profession'] ?? '';
      _dob.text= widget.details['user']['dob'] ?? '';
      _title.text= widget.details['user']['title'] ?? '';
      _about.text= widget.details['user']['about'] ?? '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<GlobalProvider>(context).isPatchingProfile==true?Center(child: CircularProgressIndicator(),): Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
           children: [
             imageProfile(),
             SizedBox(
               height: 20,
             ),
             nameTextField(),
             SizedBox(
               height: 20,
             ),
             emailTextField(),
             SizedBox(
               height: 20,
             ),
             professionTextField(),
             SizedBox(
               height: 20,
             ),
             dobField(),
             SizedBox(
               height: 20,
             ),
             titleTextField(),
             SizedBox(
               height: 20,
             ),
             aboutTextField(),
             SizedBox(
               height: 20,
             ),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    ),
                    onPressed: ()async{
                         print('ddddddddddddddfffffffffffffffffff${_imageFile!.path}');
                        if(_email.text!=null || _name.text!=null ){
                         Map data= {
                           'name':_name.text,
                           'email':_email.text,
                           'profession':_profession.text,
                           'dob':_dob.text,
                           'title':_title.text,
                           'about':_about.text,
                         };
                         var res= await Provider.of<GlobalProvider>(context, listen: false).patchProfile(data, _imageFile!.path);

                         if(res['status']=='success'){

                           Fluttertoast.showToast(
                               msg: 'Profile Updated',
                               toastLength: Toast.LENGTH_LONG,
                               gravity: ToastGravity.CENTER,
                               backgroundColor: Colors.greenAccent,
                               textColor: Colors.white,
                               fontSize: 16,
                               timeInSecForIosWeb: 1);

                         }
                         else{
                           Fluttertoast.showToast(
                               msg: res['message'],
                               toastLength: Toast.LENGTH_LONG,
                               gravity: ToastGravity.CENTER,
                               backgroundColor: Colors.redAccent,
                               textColor: Colors.white,
                               fontSize: 16,
                               timeInSecForIosWeb: 1);
                         }
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: 'name or email empty',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16,
                              timeInSecForIosWeb: 1);
                                  }

                        }


                    , child: Text('Update')),


        ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile(){
    return Container(
      width: 100,

      child: Center(
        child: Stack(
          children: [

            CircleAvatar(
              radius: 90,
              backgroundImage: _imageFile != null? FileImage(_imageFile!)
                      : widget.details['user']['name']!=null? NetworkImage(NetworkHandler().getImagePath('/users/${widget.details['user']['photo']}'))
                  :AssetImage("assets/google.png") as ImageProvider,
              ),

            Positioned(
                bottom: 0,
                right: 0,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: CircleBorder(),
                       padding: EdgeInsets.all(20)),
                    onPressed: (){
                       showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),

                      );


                    }, child: Icon(Icons.camera_alt,))),


          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    XFile? pickedFile =  await _picker.pickImage(
      source: source,
    );
    if(pickedFile!=null){
      setState(() {
        _imageFile = File(pickedFile.path);

      });
    }


  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Emmauel",
      ),
    );

  }

  Widget emailTextField() {
    return TextFormField(
      controller: _email,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Email",
        helperText: "Email can't be empty",
        hintText: "Eve@gmail.com",
      ),
    );

  }


  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Full Stack Developer",
      ),
    );
  }

  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value!.isEmpty) return "DOB can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Date Of Birth",
        helperText: "Provide DOB on dd/mm/yyyy",
        hintText: "01/01/2020",
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _title,
      validator: (value) {
        if (value!.isEmpty) return "Title can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter Developer",
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black54,
            )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )),
        labelText: "About",
        helperText: "Write about yourself",
        hintText: "I am Dev Stack",
      ),
    );
  }
}
