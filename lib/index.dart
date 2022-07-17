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

  void _deleteItem(_i) {
    setState(() {
      _items.removeAt(_i);
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
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, int index) {
                  final item = _items[index];

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
                        title: Text(_items[index]),
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
