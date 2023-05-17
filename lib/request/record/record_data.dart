import 'dart:convert';
import 'package:e_fu/request/data.dart';

class Record  extends Data{
Record(this.ax,this.ay,this.az,this.gx,this.gy,this.gz,this.pitch,this.times,this.sets_no,this.item_id,this.a_id){
  timestream=DateTime.now();
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
int a_id;
late DateTime timestream;
  @override
  String datatoJson(Data data) {
    var d = json.encode(data.toJson());
    return d.toString();
  }

  @override
  Map<String, dynamic> toJson() =>{
    "ax":ax,"ay":ay,"az":az,"gx":gx,"gy":gy,"gz":gz
  };


}

class ArrangeDate extends Data{
  
  
  ArrangeDate(this.arrangeId,this.raw);
  String arrangeId;
  List<Record> raw;
  
  @override
  String datatoJson(Data data) {
    var d = json.encode(data.toJson());
    return d.toString();
  }
  
  @override
  Map<String, dynamic> toJson() =>{
    "a_id":arrangeId,
    "raw":json.encode(raw)
  };

}