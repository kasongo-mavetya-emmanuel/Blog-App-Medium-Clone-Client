import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../provider/global_provider.dart';

class EditPassWordScreen extends StatefulWidget {
   EditPassWordScreen({Key? key, this.userId}) : super(key: key);
  var userId;

  @override
  _EditPassWordScreenState createState() => _EditPassWordScreenState();
}

class _EditPassWordScreenState extends State<EditPassWordScreen> {
  TextEditingController _currentpassword=TextEditingController();
  TextEditingController _newpassword=TextEditingController();
  TextEditingController _confirmpassword=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(

              children: [
                SizedBox(height: 100,),
                Text('Change Password',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                Divider(
                  height: 20,
                ),
                currentpasswordTextField(),
                SizedBox(
                  height: 20,
                ),
                newpasswordTextField(),
                SizedBox(
                  height: 20,
                ),
                confirmpasswTextField(),
                SizedBox(
                  height: 20,
                ),

                Provider.of<GlobalProvider>(context).isPatchingPassword==true? Center(child: CircularProgressIndicator(),):ElevatedButton(
                    style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                    onPressed: ()async{



                      if(_currentpassword.text!=null || _newpassword.text!=null || _confirmpassword.text!=null ){
                        Map data={
                          'passwordCurrent': _currentpassword.text,
                          "password": _newpassword.text,
                          "passwordConfirm": _confirmpassword.text,
                        };
                        var res= await Provider.of<GlobalProvider>(context,listen: false).patchPassword(data);

                        if(res['status']=='success'){

                          Fluttertoast.showToast(
                              msg: 'Password Updated',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.greenAccent,
                              textColor: Colors.white,
                              fontSize: 16,
                              timeInSecForIosWeb: 1);

                          _confirmpassword.clear();
                          _currentpassword.clear();
                          _newpassword.clear();
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
                            msg: 'All fields should have data',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16,
                            timeInSecForIosWeb: 1);
                      }

                    }, child: Text('Update')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget currentpasswordTextField() {
    return TextFormField(
      controller: _currentpassword,
      validator: (value) {
        if (value!.isEmpty) return "CurrentPassword can't be empty";
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
          Icons.password,
          color: Colors.green,
        ),
        labelText: "currentpassord",
        helperText: "currentPassword can't be empty",
        hintText: "current password",
      ),
    );

  }

  Widget newpasswordTextField() {
    return TextFormField(
      controller: _newpassword,
      validator: (value) {
        if (value!.isEmpty) return "newPassword can't be empty";
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
          Icons.password,
          color: Colors.green,
        ),
        labelText: "New Password",
        helperText: "New Password can't be empty",
        hintText: "NewPassword",
      ),
    );

  }
  Widget confirmpasswTextField() {
    return TextFormField(
      controller: _confirmpassword,
      validator: (value) {
        if (value!.isEmpty) return "CurrentPassword can't be empty";
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
          Icons.password,
          color: Colors.green,
        ),
        labelText: "Confirm New Password",
        helperText: "Confirm New Password can't be empty",
        hintText: "Confirm New password",
      ),
    );

  }
}
