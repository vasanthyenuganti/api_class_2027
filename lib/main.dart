import 'dart:convert';

import 'package:api_class_2027/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyUserProfile(),
    );
  }
}


class MyUserProfile extends StatefulWidget {
  const MyUserProfile({super.key});

  @override
  State<MyUserProfile> createState() => _MyUserProfileState();
}

class _MyUserProfileState extends State<MyUserProfile> {

  bool isLoading = false;
  UserModel? userModel;


  void fetchUserProfile() async {
    // Implementation for fetching user profile will go here

    setState(() {
      isLoading = true;
    });
    try {
      final res = await http.get(Uri.parse('https://api.github.com/users/vasanthyenuganti'));
      if(res.statusCode == 200){
        userModel = UserModel.fromJson(jsonDecode(res.body));
        debugPrint("User Model: $userModel");
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        
        child: isLoading ? CircularProgressIndicator() : Column(
          children: [
            Image(image: NetworkImage(userModel?.avatarUrl ?? ''),height: 200,width: 200,),
            Text("${userModel?.id ?? ''}"),

          ],
        ),),
    );
  }
}
