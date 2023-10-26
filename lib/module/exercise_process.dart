import 'package:flutter/material.dart';

class ItemSets {
  static final List<String> items = ["左手", "右手", "椅子坐立"];
  static List<ItemWithField> withField(){
    return items.map((e) => ItemWithField(item: e)).toList();
  }
}

class ItemWithField {
  ItemWithField({required this.item}) ;
  final String item;
  TextEditingController textEditingController = TextEditingController(text: "5");
}
