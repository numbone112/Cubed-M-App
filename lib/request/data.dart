import 'dart:convert';

 abstract class Data {

  String datatoJson(Data data);

  Map<String, dynamic> toJson();

}

class Format {
  String? message;
  bool? success;
  dynamic D;

  Format.fromFields(this.message,this.success,this.D);
  Format.fromJson(String str) {
      Map<String,dynamic> d = json.decode(str);
      message=d["message"];
      success=d['success'];
      D=d["D"];
    
    // initializeFromJson(json) ;
  }

  // static Format fromJson(String str) {
  
  // }
}
