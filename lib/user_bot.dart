import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserBot extends StatefulWidget {
  const UserBot({super.key});

  @override
  State<UserBot> createState() => _UserBotState();
}

class _UserBotState extends State<UserBot> {
  bool _isLoading = false;
  String data = "";

  final String endPoint =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?key={{KEY}}";

  final header = {"Content-Type": "application/json"};

  final body = {
    "contents": [
      {
        "role": "user",
        "parts": [
          {"text": "What is flutter"},
        ],
      },
    ],
    "generationConfig": {
      "responseModalities": ["TEXT"],
    },
  };

  Future<void> _triggeBot() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final res = await http.post(
        Uri.parse(endPoint),
        headers: header,
        body: jsonEncode(body),
      );
      if (res.statusCode == 200) {
        data = jsonDecode(
          res.body,
        )[0]["candidates"][0]["content"]["parts"][0]["text"];
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _triggeBot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Bot")),
      body: Center(
        child: _isLoading ? CupertinoActivityIndicator() : Text("$data"),
      ),
    );
  }
}
