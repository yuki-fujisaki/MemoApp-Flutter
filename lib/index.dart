import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myController = TextEditingController();
  // データ格納用リスト
  List<String> _items = [];

  void _addItem(String inputtext) {
    setState(() {
      _items.add(inputtext);
      print(_items);
    });
  }

  @override
  // widgetの破棄時にコントローラも破棄する
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
