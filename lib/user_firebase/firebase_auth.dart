import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<bool> registerUser(String email, String password) async {
  try{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch(e) {
    if (e.code == 'weak-password') {
      print('Provided password is weak');
    } else if (e.code == 'email-already-in-use') {
      print('Account already exist on this email');
    }
    return false;
  }
}

Future<String> uploadProfileImage(String image) async {
  try{
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference refer = storage.ref('/profile_pics/');
    firebase_storage.UploadTask uploadTask = (await refer.putFile(File(image))) as firebase_storage.UploadTask;
    Future.value(uploadTask).then((value) {
    });
    String imgUrl = await refer.getDownloadURL();
    return imgUrl.toString();
  }catch(e){
    print(e.toString());
    return null.toString();
  }
}

Future<bool> updateProfile(String username, String birthdate, String imgUrl) async{
  try{
    FirebaseFirestore.instance.runTransaction((transaction) async {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(uid);
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      documentReference.set({
        'User name': username,
        'Date of Birth': birthdate,
        'Profile Pic': imgUrl,
      });
    });
    return true;
  } catch(e){
    print(e.toString());
    return true;
  }
}

Future<bool> signIn(String username, String password) async {
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
    return true;
  }catch(e){
    print(e.toString());
    return false;
  }
}

Future<bool> UpdateProfile(String username, String birthdate, String  url) async {
  try{
    FirebaseFirestore.instance.runTransaction((transaction) async {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(uid);
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      documentReference.update({
        'User name': username,
        'Date of Birth': birthdate,
        'Profile Pic': url,
      });
    });
    return true;
  } catch(e){
    print(e.toString());
    return true;
  }
}

