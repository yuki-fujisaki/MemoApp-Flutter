import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/memo.dart';

class EditPage extends ConsumerWidget {
  EditPage(this.memo, this.index);
  final Memo memo;
  final int index;

  // DateTime→String
  String getDateTimeToString(DateTime now) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = outputFormat.format(now);
    return date;
  }

  Future<void> _editData(Memo editedMemo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? memoJson = await prefs.getStringList('memo');

    if (memoJson == null || memoJson == []) {
      return;
    }
    memoJson.removeAt(index);
    memoJson.insert(
        index,
        json.encode(editedMemo.toJson(
            getDateTimeToString(editedMemo.createdTime),
            getDateTimeToString(editedMemo.updatedTime))));
    await prefs.setStringList('memo', memoJson);
    print('Edited $memoJson');
    print('Setting json $memoJson');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _myController = TextEditingController(text: memo.content);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Page"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _myController,
          ),
        ),
        height: double.infinity,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Memo editedMemo = Memo(
            content: _myController.text,
            createdTime: memo.createdTime,
            updatedTime: DateTime.now(),
          );
          _editData(editedMemo);
        },
        child: const Text('保存'),
      ),
    );
  }
}
