// ignore_for_file: non_constant_identifier_names

import 'package:e_fu/request/exercise/history_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record_data.g.dart';

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
      this.times, this.sets_no, this.item_id, this.i_id) {
    timestream = DateTime.now();
  }
  static Map<String, dynamic> getRecordJson(
      List<String> list, double sets_n, double item_i, int i_) {
    Map<String, dynamic> result = {};
    for (int i = 0; i < list.length; i++) {
      result[column[i]] = list[i];
    }
    result["sets_no"] = sets_n;
    result["item_id"] = item_i;
    result["i_id"] = i_;
    return result;
  }

  double ax;
  double ay;
  double az;
  double gx;
  double gy;
  double gz;
  double pitch;
  double times;
  double sets_no;
  double item_id;
  int i_id;
  late DateTime timestream;
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);
  Map<String, dynamic> toJson() => _$RecordToJson(this);
  // @override
  // String datatoJson(Data data) {
  //   var d = json.encode(data.toJson());
  //   return d.toString();
  // }

  // @override
  // Map<String, dynamic> toJson() =>{
  //   "ax":ax,"ay":ay,"az":az,"gx":gx,"gy":gy,"gz":gz
  // };
}

@JsonSerializable(explicitToJson: true)
class RecordSender {
  RecordSender({required this.raw, required this.detail});
  List<Map<String, dynamic>> raw;
  List<RecordSenderItem> detail;

  factory RecordSender.fromJson(Map<String, dynamic> json) =>
      _$RecordSenderFromJson(json);
  Map<String, dynamic> toJson() => _$RecordSenderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RecordSenderItem {
  RecordSenderItem(
      {required this.done, required this.score, required this.user_id,required this.i_id});

  String user_id;
  List<DoneItem> done;
  double score;
  int i_id;

  factory RecordSenderItem.fromJson(Map<String, dynamic> json) =>
      _$RecordSenderItemFromJson(json);
  Map<String, dynamic> toJson() => _$RecordSenderItemToJson(this);
}

