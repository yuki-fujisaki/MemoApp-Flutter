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
  bool isEditing = false;

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
        updatedTime: DateTime.now(),
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

  void _deleteSelectedItem() {
    setState(() {
      _memos = _memos.where((e) => !e.isSelected).toList();
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
        .map((e) => json.encode(e.toJson(getDateTimeToString(e.createdTime),
            getDateTimeToString(e.updatedTime))))
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

// データの全削除
  Future<void> _deleteData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('memo');
  }
  // ##############################################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo App'),
        actions: [
          TextButton(
            child: isEditing
                ? const Text(
                    'キャンセル',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                : const Text(
                    '選択',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
            onPressed: () {
              print('クリックされました');
              setState(() => isEditing = !isEditing);
              print('${isEditing}');
            },
          )
        ],
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
                decoration: InputDecoration(
                  hintText: "投稿する文字を入力してください",
                ),
              ),
            ),
            // 検索用テキストフィールド
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: search,
                decoration: InputDecoration(
                  hintText: "検索する文字を入力してください",
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('作成日時'),
                ElevatedButton(
                  child: const Text('昇順'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _memos.sort(
                          (a, b) => a.createdTime.compareTo(b.createdTime));
                      print('sorted');
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('降順'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _memos.sort(
                          (a, b) => b.createdTime.compareTo(a.updatedTime));
                      print('sorted');
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('編集日時'),
                ElevatedButton(
                  child: const Text('昇順'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _memos.sort(
                          (a, b) => a.updatedTime.compareTo(b.updatedTime));
                      print('sorted');
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('降順'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _memos.sort(
                          (a, b) => b.updatedTime.compareTo(a.updatedTime));
                      print('sorted');
                    });
                  },
                ),
              ],
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
                      child: isEditing
                          ? CheckboxListTile(
                              title: Text('${item.content}'),
                              value: item.isSelected,
                              onChanged: (value) {
                                setState(() {
                                  item.isSelected = value!;
                                  print('${item.isSelected}');
                                });
                              },
                            )
                          : ListTile(
                              title: Text('${item.content}'),
                              trailing: Text('${item.createdTime}'),
                              onTap: () async {
                                await Navigator.push(
                                    _,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditPage(item, index),
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
      floatingActionButton: Column(
        verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            // onPressedでボタンが押されたらテキストフィールドの内容を取得して、アイテムに追加
            onPressed: () {
              _addItem(_myController.text);
              // テキストフィールドの内容をクリア
              _myController.clear();
            },
            child: const Icon(Icons.add),
          ),
          isEditing
              ? Container(
                  // 余白のためContainerでラップ
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Icon(Icons.remove),
                      onPressed: _deleteSelectedItem,
                      onLongPress: () {
                        setState(() {
                          _memos = [];
                          _deleteData();
                        });
                      }),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
