import 'package:e_fu/request/e/e_data.dart';
import 'package:e_fu/request/exercise/history_data.dart';

class EventRecordDetail {
  EventRecordDetail({this.item = const [5, 5, 5]});
  List<int> item;
}

class EventRecord {
  EventRecord(
      {required this.eventRecordDetail, required this.eventRecordInfo}) {
    int s = 0;
    for (int i in eventRecordDetail.item) {
      s += i;
    }
    goal = s;
  }
  EventRecordDetail eventRecordDetail;
  EventRecordInfo eventRecordInfo;
  int now = 0;
  int goal = 3;
  Map<int, int> progress = {0: 0, 1: 0, 2: 0};
  Map<int, List<int>> data = {0: [], 1: [], 2: []};
  Map<int, Set<String>> tempData = {0: {}, 1: {}, 2: {}};
  bool unReadable = false;
  bool isConnect = false;
  Set<String> endSign = {};
  List<DoneItem> done = [];
  double avg=0;

  void record(int count) {
    data[now]!.add(count);
  }

  void change(int n) => now = n;

  bool hasLeft(int mode) {
    return tempData[mode]!.length >= eventRecordDetail.item[mode];
  }

  void reviceEndSign(String string) {
    endSign.add(string);
    tempData[now]?.add(string);
    // data[forEvent.now]!.add(toSave.last.times.toInt());
    changeProgress();
    needChange();
  }

  int needChange() {
    if (tempData[now]!.length >= eventRecordDetail.item[now]) {
      for (int i = 0; i < tempData.length; i++) {
        if (tempData[i]!.length < eventRecordDetail.item[i]) {
          change(i);
          break;
        }
      }
    }
    return now;
  }

  int score(int count, int age, bool isMan, int type) {
    List<int> ageList = [89, 83, 79, 74, 69];

    List<List<List<List<int>>>> scoreTable = [
      [
        [
          [17, 14, 10, 5],
          [18, 16, 13, 10],
          [19, 16, 13, 10],
          [20, 18, 15, 12],
          [22, 19, 16, 12],
          [23, 20, 17, 13]
        ],
        [
          [13, 11, 8, 5],
          [14, 12, 10, 5],
          [16, 13, 11, 9],
          [17, 15, 12, 10],
          [19, 16, 13, 10],
          [20, 17, 14, 11]
        ]
      ],
      [
        [
          [18, 15, 12, 5],
          [19, 16, 13, 8],
          [19, 17, 14, 11],
          [20, 18, 15, 11],
          [21, 19, 16, 12],
          [22, 19, 17, 13]
        ],
        [
          [13, 11, 8, 4],
          [14, 12, 9, 3],
          [15, 13, 11, 8],
          [17, 14, 12, 9],
          [18, 15, 13, 10],
          [19, 16, 14, 11]
        ]
      ]
    ];

    int ageIndex = ageList.length;
    for (int i = 0; i < ageList.length; i++) {
      if (age > ageList[i]) {
        ageIndex = i;
      }
    }
    int result = 1;
    int sexIndex = isMan ? 0 : 1;
    int typeIndex = type > 2 ? 1 : 0;

    for (int i = 0; i < scoreTable[sexIndex][typeIndex][ageIndex].length; i++) {
      if (count > scoreTable[sexIndex][typeIndex][ageIndex][i]) {
        result = 5 - i;
        break;
      }
    }

    return result;
  }

  void processData(int age, bool isMan) {
    double avgScore=0;
    tempData.forEach((key, value) {
      List<int> temp = [];
      for (var element in value) {
        int times = int.parse(element.split(',')[1]);
        temp.add(times);
        int s=score(times, age, isMan, key);
        avgScore+=s;
        done.add(DoneItem(
            level: s, times: times, type_id: key));
      }
      avg=avgScore/done.length;
      data[key] = temp;
    });
  }


  static int getMax(List<EventRecord> data) {
    int max = 0;
    for (EventRecord fe in data) {
      if (fe.endSign.length > max) max = fe.endSign.length;
    }
    return max;
  }

  void changeProgress() {
    int p = tempData[now]?.length ?? 1;
    progress[now] = (p / eventRecordDetail.item[now] * 100).round();
  }
}
