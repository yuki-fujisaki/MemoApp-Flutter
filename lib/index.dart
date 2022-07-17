import 'package:flutter/material.dart';
import 'package:memo_app_flutter/model/memo.dart';

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

  void _addItem(String _inputtext) {
    setState(() {
      Memo memo = Memo(
        content: _inputtext,
        createdTime: DateTime.now(),
      );
      _memos.add(memo);
    });
  }

  void _deleteItem(_i) {
    setState(() {
      _memos.removeAt(_i);
    });
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

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
