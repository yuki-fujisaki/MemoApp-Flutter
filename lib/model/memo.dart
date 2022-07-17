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
    required this.updatedTime,
    this.isSelected = false,
  });

  String content;
  DateTime createdTime;
  DateTime updatedTime;
  bool isSelected;

  Map<String, dynamic> toJson(
      String stringCreatedTime, String stringUpdatedTime) {
    return {
      'content': content,
      'createdTime': stringCreatedTime,
      'updatedTime': stringUpdatedTime,
      'isSelected': isSelected,
    };
  }

  static Memo fromJson(Map<String, dynamic> json) {
    return Memo(
      content: json['content'],
      createdTime: getDateTime(json['createdTime']),
      updatedTime: getDateTime(json['updatedTime']),
      isSelected: json['isSelected'],
    );
  }
}
