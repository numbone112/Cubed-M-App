import 'dart:convert';
import 'dart:ffi';

import 'package:e_fu/module/arrange.dart';

import "../data.dart";
class Record  extends Data{

Record(this.ax,this.ay,this.az,this.gx,this.gy,this.gz);


double ax;
double ay;
double az;
double gx;
double gy;
double gz;
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

class Arrange_date extends Data{
  
  
  Arrange_date(this.arrange_id,this.raw);
  String arrange_id;
  List<Record> raw;
  
  @override
  String datatoJson(Data data) {
    var d = json.encode(data.toJson());
    return d.toString();
  }
  
  @override
  Map<String, dynamic> toJson() =>{
    "arrange_id":arrange_id,
    "raw":json.encode(raw)
  };

}