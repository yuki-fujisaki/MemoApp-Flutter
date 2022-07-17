import 'package:intl/intl.dart';

DateTime getDateTime(String datetimeStr) {
  final _dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime result;

  // String→DateTime変換
  result = _dateFormatter.parse(datetimeStr);
  return result;
}

class Memo {
  Memo({
    this.content = '',
    required this.createdTime,
  });

  String content;
  DateTime createdTime;

  Map<String, dynamic> toJson(String stringCreateTime) {
    return {
      'content': content,
      'createTime': stringCreateTime,
    };
  }

  static Memo fromJson(Map<String, dynamic> json) {
    return Memo(
      content: json['content'],
      createdTime: getDateTime(json['createTime']),
    );
  }
}
