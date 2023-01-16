import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_profiles/user_interfaces/edit_profile.dart';
import 'package:flutter/material.dart';

class ProfileShow extends StatefulWidget {
  const ProfileShow({Key? key}) : super(key: key);

  @override
  State<ProfileShow> createState() => _ProfileShowState();
}

class _ProfileShowState extends State<ProfileShow> {

  bool user = false;

  TextEditingController username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                // style: const TextStyle(color: Colors.white),
                controller: username,
                decoration:  const InputDecoration(
                  hintText: 'search user',
                  hintStyle: TextStyle(color: Colors.white,),
                ),
              ),
            ),
             GestureDetector(
              onTap: (){
                if(username.text != ''){
                  user = true;
                  setState(() {});
                }
                else{
                  user = false;
                  setState(() {});
                }
                },
                child: Icon(Icons.search)),
            const SizedBox(width: 5.0,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileData()));
            },
                child: const Text('Edit Profile',
                  style: TextStyle(
                      color: Colors.white),
                ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
                stream: user == false ? FirebaseFirestore.instance.collection('Users').snapshots()
                : FirebaseFirestore.instance.collection('Users').where('User name', isEqualTo: username.text).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final userSnapshot = snapshot.data?.docs;
                  return ListView.builder(
                    itemCount: userSnapshot?.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 5.0),
                        child: ListTile(
                          title: Text(userSnapshot![index]['User name'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          subtitle: Text(userSnapshot![index]['Date of Birth'],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 40.0,
                            backgroundImage: NetworkImage(userSnapshot![index]['Profile Pic']),
                          ),
                        ),
                      );
                    },
                  );
                }
            ),
          ),
        ),
    );
  }
}

