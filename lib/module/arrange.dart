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
        people!.add(new People.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['peopleNumber'] = this.peopleNumber;
    if (this.people != null) {
      data['people'] = this.people!.map((v) => v.toJson()).toList();
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
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeId;
    data['quota'] = this.quota;
    return data;
  }
}