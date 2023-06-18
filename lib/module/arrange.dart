class Arrange {
  String? time;
  int? peopleNumber;
  List<People>? people;

  Arrange({this.time, this.peopleNumber, this.people});

  Arrange.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    peopleNumber = json['peopleNumber'];
    if (json['people'] != null) {
      people = <People>[];
      json['people'].forEach((v) {
        people!.add(People.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['peopleNumber'] = peopleNumber;
    if (people != null) {
      data['people'] = people!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class People {
  String? id;
  List<Items>? items;

  People({this.id, this.items});

  People.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? typeId;
  int? quota;

  Items({this.typeId, this.quota});

  Items.fromJson(Map<String, dynamic> json) {
    typeId = json['type_id'];
    quota = json['quota'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type_id'] = typeId;
    data['quota'] = quota;
    return data;
  }
}