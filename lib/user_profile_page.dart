import 'dart:convert';

import 'package:api_class_2027/user_model.dart';
import 'package:api_class_2027/user_repo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyUserProfile extends StatefulWidget {
  final UserModel? userModel;
  const MyUserProfile({super.key, this.userModel});

  @override
  State<MyUserProfile> createState() => _MyUserProfileState();
}

class _MyUserProfileState extends State<MyUserProfile> {
  Future<List<UserRepoModel>> getRepos() async {
    try {
      final res = await http.get(Uri.parse(widget.userModel?.reposUrl ?? ""));

      if (res.statusCode == 200) {
        final List<dynamic> json = jsonDecode(res.body);
        return json.map((e) {
          return UserRepoModel.fromJson(e);
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getRepos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${snapshot.data![index].name ?? ""}"),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: snapshot.data?.length ?? 0,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator.partiallyRevealed(),
            );
          } else {
            return Center(child: Text("Empty"));
          }
        },
      ),
    );
  }
}
