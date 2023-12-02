import 'package:flutter/material.dart';
import 'package:collection/collection.dart';


class ItemSets {
  static final List<String> items = ["左手", "右手", "椅子坐立"];
  static List<ItemWithField> withField(List<String> setList) {
    List<ItemWithField> result=[];
    for (var pairs in IterableZip([items,setList])){
      result.add(ItemWithField(item: pairs[0],text: pairs[1]));
    }
    return result;
  }
}

class ItemWithField {
  ItemWithField({required this.item, required String text}) {
    textEditingController = TextEditingController(text: text);
  }
  final String item;

  late TextEditingController textEditingController;
}
