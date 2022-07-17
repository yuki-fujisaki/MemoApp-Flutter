import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memo_app_flutter/edit.dart';
import 'package:memo_app_flutter/model/memo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myController = TextEditingController();
  // データ格納用リスト
  List<Memo> _memos = [];

  @override
  void initState() {
    super.initState();
    _getData();
    print('Geiitng memos $_memos');
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  void _addItem(String _inputtext) {
    setState(() {
      Memo memo = Memo(
        content: _inputtext,
        createdTime: DateTime.now(),
      );
      _memos.add(memo);
      _saveData();
    });
  }

  void _deleteItem(_i) {
    setState(() {
      _memos.removeAt(_i);
      _saveData();
    });
  }

  // DateTime→String
  String getDateTimeToString(DateTime now) {
    DateFormat outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String date = outputFormat.format(now);
    return date;
  }

// ##############################################################
// ローカルストレージで永続化(Shared_Preferences)

// データの保存
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> memoJson = _memos
        .map((e) => json.encode(e.toJson(getDateTimeToString(e.createdTime))))
        .toList();
    print('Setting json $memoJson');
    await prefs.setStringList('memo', memoJson);
  }

// データの取得
  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? memoJson = await prefs.getStringList('memo');

    if (memoJson == null || memoJson == []) {
      _memos = [];
      return;
    }
    List<Memo> decodedJson = memoJson
        .map((e) => Memo.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
    setState(() {
      _memos = decodedJson;
    });
    print('Geiitng json $memoJson');
    print('Setting memos $_memos');
  }
  // ##############################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo App'),
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // テキストフィールド
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _myController,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _memos.length,
                itemBuilder: (_, int index) {
                  final item = _memos[index];

                  return Dismissible(
                    key: ObjectKey(item),
                    onDismissed: (direction) {
                      _deleteItem(index);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(_memos[index].content),
                        trailing: Text('${item.createdTime}'),
                        onTap: () async {
                          await Navigator.push(
                              _,
                              MaterialPageRoute(
                                builder: (context) => EditPage(item, index),
                              ));
                          _getData();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(_myController.text);
          _myController.clear();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
