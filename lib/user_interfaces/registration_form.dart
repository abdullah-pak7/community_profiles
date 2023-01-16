import 'dart:io';
import 'package:community_profiles/user_firebase/firebase_auth.dart';
import 'package:community_profiles/user_interfaces/profile_show.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

   XFile? imagefile;
   final ImagePicker picker = ImagePicker();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController birthdate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blueAccent[400],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: Text('Registred in Community',
                  style: TextStyle(color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/25),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 75.0,
                        backgroundImage: imagefile == null ? AssetImage('assets/images/demo_profile.png'): FileImage(File(imagefile!.path)) as ImageProvider,
                        backgroundColor: Colors.blue[400],
                      ),
                      Positioned(
                        bottom: 20.0,
                          right: 20.0,
                          child: GestureDetector(
                            onTap: (){
                              bottomSheet();
                            },
                            child: Icon(Icons.camera_alt,
                            color: Colors.blue[700],),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/35),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: email,
                  decoration: const InputDecoration(
                      hintText: 'something@email.com',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/35),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/35),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: username,
                  decoration: const InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/35),
              Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: birthdate,
                  decoration: const InputDecoration(
                      hintText: '01-01-2000',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelText: 'Date of Birth',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/25),
              Container(
                width: MediaQuery.of(context).size.width/1.4,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                ),
                child: MaterialButton(onPressed: () async {
                  bool isRegister = await registerUser(email.text, password.text);
                  if(isRegister){
                    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
                    firebase_storage.Reference refer = storage.ref('/profile_pics/'+DateTime.now().toString());
                    firebase_storage.UploadTask uploadTask = refer.putFile(File(imagefile!.path));
                    Future.value(uploadTask).then((value) async {
                      String profileImageUrl = await refer.getDownloadURL();
                      print(profileImageUrl);
                      bool isProfile = await updateProfile(username.text, birthdate.text, profileImageUrl);
                      if(isRegister && isProfile){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileShow()));
                      }
                    });
                   }
                  },
                  child: const Text('Register Here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void bottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
        child: Column(
          children:  [
            const Text('Chose Profile Pic',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                ),
                TextButton.icon(onPressed: (){
                  takePhoto(ImageSource.gallery);
                },
                  icon: Icon(Icons.image),
                  label: Text('Gallery'),
                ),
              ],
            ),
           ],
        ),
      );}
    );
  }
  void takePhoto(ImageSource source) async {

    final XFile pickFile = (await picker.pickImage(source: source,) as XFile);
    setState(() {
      imagefile = pickFile;
      print(imagefile?.path);
    });
  }
}