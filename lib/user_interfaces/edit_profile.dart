import 'package:community_profiles/user_firebase/firebase_auth.dart';
import 'package:community_profiles/user_interfaces/profile_show.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileData extends StatefulWidget {
  const EditProfileData({Key? key}) : super(key: key);

  @override
  State<EditProfileData> createState() => _EditProfileDataState();
}

class _EditProfileDataState extends State<EditProfileData> {

  TextEditingController username = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  String url = '';
  String uid = FirebaseAuth.instance.currentUser!.uid;

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
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Users').doc(uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const CircularProgressIndicator();
                // }
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  username.text = data['User name'];
                  birthdate.text = data['Date of Birth'];
                  url = data['Profile Pic'];
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Text('Edit your Profile',
                          style: TextStyle(color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/35),
                      Container(
                        width: MediaQuery.of(context).size.width/1.3,
                        child: Center(
                          child: CircleAvatar(
                            radius: 75.0,
                            backgroundImage: NetworkImage(url!),
                            backgroundColor: Colors.blue[400],
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
                            ),
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
                            ),
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
                          bool isUpdated = await UpdateProfile(username.text, birthdate.text, url);
                          if(isUpdated == true){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileShow()));
                          }
                        },
                          child: const Text('Update Profile'),
                        ),
                      ),
                    ]
                );
              }),
        ),
      ),
    );
  }
}