import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_class_2027/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBot extends StatefulWidget {
  const UserBot({super.key});

  @override
  State<UserBot> createState() => _UserBotState();
}

class _UserBotState extends State<UserBot> {
  String imgUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRydWz3cnW_w7MLBYZWziEXL2jI4xPR8Kwd3MHVpVQVRMRp1W9dYW0rCSBQk5qLXGB9oAur&s";

  final TextEditingController _inputCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> searchBot() async {
    setState(() {
      _isLoading = true;
    });
    final body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": _inputCtrl.text},
          ],
        },
      ],
      "generationConfig": {
        "responseModalities": ["TEXT"],
      },
    };

    chating.add(
      MessageModel(
        role: "user",
        parts: [Parts(text: _inputCtrl.text)],
      ),
    );

    try {
      final res = await http.post(
        Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={{KEY}}",
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body)["candidates"][0]["content"];
        chating.add(MessageModel.fromJson(json));
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<MessageModel> chating = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Git Bot")),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.black.withOpacity(.45),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                // Spacer(),
                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final mess = chating[index];
                      if (mess.role == "user") {
                        return Row(
                          children: [
                            Spacer(),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(mess.parts?.first.text ?? ""),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(mess.parts?.first.text ?? ""),
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: chating.length,
                  ),
                ),
                // Spacer(),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _inputCtrl,
                          readOnly: _isLoading,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          await searchBot();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          height: 52,
                          width: 52,
                          child: _isLoading
                              ? CupertinoActivityIndicator(color: Colors.white)
                              : Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
