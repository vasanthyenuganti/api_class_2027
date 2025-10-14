import 'dart:convert';

import 'package:api_class_2027/user_bot.dart';
import 'package:api_class_2027/user_model.dart';
import 'package:api_class_2027/user_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  bool isUserId = false;
  bool isLoading = false;
  UserModel? userModel;
  TextEditingController _inputCtrl = TextEditingController();
  final _key = GlobalKey<FormState>();

  Future fetchUserProfile() async {
    // Implementation for fetching user profile will go here

    setState(() {
      isLoading = true;
      userModel = null;
    });
    try {
      final res = await http.get(
        Uri.parse(
          isUserId
              ? 'https://api.github.com/user/${_inputCtrl.text}'
              : 'https://api.github.com/users/${_inputCtrl.text}',
        ),
      );
      if (res.statusCode == 200) {
        userModel = UserModel.fromJson(jsonDecode(res.body));
        debugPrint("User Model: $userModel");
      } else {
        debugPrint(res.body);
      }
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void clear() {
    setState(() {
      userModel = null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: NetworkImage(
                  "https://devtools.in/wp-content/uploads/2022/10/GitHub.png",
                ),
                width: 150,
                height: 150,
              ),
            ),
            TextFormField(
              controller: _inputCtrl,
              cursorColor: Colors.black,
              validator: (value) => value!.isEmpty
                  ? "Please enter the ${isUserId ? "User Id" : "User Name"}"
                  : null,
              decoration: InputDecoration(
                labelText: isUserId ? "User Id" : "User Name",
                hintText: isUserId ? "86598859" : "vasanthyenuganti",
                constraints: BoxConstraints(maxWidth: 380, minWidth: 280),
                suffixIcon: CupertinoSwitch(
                  value: isUserId,
                  activeTrackColor: Colors.black,
                  onChanged: (val) {
                    setState(() {
                      isUserId = val;
                    });
                  },
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                if (_key.currentState!.validate()) {
                  if (!isLoading) {
                    await fetchUserProfile();
                  }
                  if (!isLoading && userModel != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyUserProfile(userModel: userModel),
                      ),
                    );
                  }
                }
              },
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(isLoading ? 90 : 8),
                ),
                constraints: !isLoading
                    ? BoxConstraints(
                        minHeight: 60,
                        maxHeight: 60,
                        minWidth: 280,
                        maxWidth: 380,
                      )
                    : BoxConstraints(
                        minHeight: 60,
                        maxHeight: 60,
                        minWidth: 60,
                        maxWidth: 60,
                      ),
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: isLoading
                      ? CupertinoActivityIndicator(color: Colors.white)
                      : Text(
                          "SEARCH",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserBot()),
          );
        },
      ),
    );
  }
}
