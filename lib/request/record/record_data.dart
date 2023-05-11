import 'dart:convert';
import 'package:e_fu/request/data.dart';

class Record  extends Data{
Record(this.ax,this.ay,this.az,this.gx,this.gy,this.gz,this.pitch){
  dateTime=DateTime.now();
}


double ax;
double ay;
double az;
double gx;
double gy;
double gz;
double pitch;
late DateTime dateTime;
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