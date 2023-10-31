// ignore_for_file: non_constant_identifier_names

import 'package:e_fu/request/exercise/history_data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'record_data.g.dart';

List<Record> changeRecordID(List<Record> record, int id) {
  List<Record> res = [];
  for (Record r in record) {
    r.i_id = id;
    res.add(r);
  }
  return res;
}

List<RecordSenderItem> changeSenderItemID(List<RecordSenderItem> senderItem, int id) {
  List<RecordSenderItem> res = [];
  for (RecordSenderItem r in senderItem) {
    r.i_id = id;
    
    res.add(r);
  }
  return res;
}

@JsonSerializable(explicitToJson: true)
class Record {
  static final List<String> column = [
    "ax",
    'ay',
    'az',
    'gx',
    'gy',
    'gz',
    'pitch',
    'times',
    'sets_no',
    'item_id',
    'i_id'
  ];
  Record(this.ax, this.ay, this.az, this.gx, this.gy, this.gz, this.pitch,
      this.times, this.sets_no, this.item_id, this.i_id) ;
  static Record getRecordJson(
      List<String> list, int sets_n, int item_i, int i_) {
    Map<String, dynamic> result = {};
    result["sets_no"] = sets_n;
    result["item_id"] = item_i;
    result["i_id"] = i_;
    for (int i = 0; i < list.length; i++) {
    
      result[column[i]] = double.parse(list[i]);
    }

    return Record.fromJson(result);
  }

  double ax;
  double ay;
  double az;
  double gx;
  double gy;
  double gz;
  double pitch;
  double times;
  int sets_no;
  int item_id;
  int i_id;
  // late DateTime timestream;
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecordSender {
  RecordSender({required this.record, required this.detail});
  List<Record> record;
  List<RecordSenderItem> detail;

  factory RecordSender.fromJson(Map<String, dynamic> json) =>
      _$RecordSenderFromJson(json);
  Map<String, dynamic> toJson() => _$RecordSenderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecordSenderItem {
  RecordSenderItem(
      {required this.done,
      required this.each_score,
      required this.user_id,
      required this.i_id,
      required this.total_score});

  String user_id;
  List<DoneItem> done;
  List<double> each_score;
  double total_score;
  int i_id;

  factory RecordSenderItem.fromJson(Map<String, dynamic> json) =>
      _$RecordSenderItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecordSenderItemToJson(this);
}
