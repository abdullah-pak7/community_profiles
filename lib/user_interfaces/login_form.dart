import 'package:community_profiles/user_firebase/firebase_auth.dart';
import 'package:community_profiles/user_interfaces/profile_show.dart';
import 'package:community_profiles/user_interfaces/registration_form.dart';
import 'package:flutter/material.dart';

class UserAuth extends StatefulWidget {
  const UserAuth({super.key});

  @override
  State<UserAuth> createState() => _UserAuthState();
}

class _UserAuthState extends State<UserAuth> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.3,
              child: Text('Welcome to Community',
              style: TextStyle(color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
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
          SizedBox(height: MediaQuery.of(context).size.height/25),
          Container(
          width: MediaQuery.of(context).size.width/1.4,
          height: 40.0,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          ),
          child: MaterialButton(onPressed: () async {
            bool shouldNavigate = await signIn(username.text, password.text);
            if(shouldNavigate){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileShow()));
            }
          },
          child: const Text('Login Here'),
          ),
        ),
          SizedBox(height: MediaQuery.of(context).size.height/35),
          Container(
          width: MediaQuery.of(context).size.width/1.4,
          height: 40.0,
          child: TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser()));
          },
          child: Text('Join Community / Register Here',
            style: TextStyle(
            color: Colors.white,
            ),
          ),
        ),
        ),
        ]),
        ),
      ),
    );
  }
}
