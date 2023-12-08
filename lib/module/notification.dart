// ignore_for_file: depend_on_referenced_packages

import 'package:e_fu/request/plan/plan_data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPlugin {
  final FlutterLocalNotificationsPlugin np = FlutterLocalNotificationsPlugin();

  init() async {
    // 在 Android 平台上的設置，並使用 flutter logo 作為通知顯示的圖標
    var android = const AndroidInitializationSettings('flutter_logo');

    // 在 iOS 平台上的設置，並設置了 iOS 通知的權限
    var ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    // 註冊不同平台初始化設置的 InitializationSetting 對象
    var initSettings = InitializationSettings(android: android, iOS: ios);
  tz.initializeTimeZones(); // 初始化時區資料庫
    tz.setLocalLocation(tz.getLocation('Asia/Taipei')); // 將時區設定為台北標準時間
    // 使用 np 實例的 initialize 方法初始化本地通知插件
    await np.initialize(initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  tz.TZDateTime _convertTime(DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      8,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  // 觸發通知時，透過呼叫此函式來顯示通知
  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return np.show(id, title, body, await notificatinoDetails());
  }

  notificatinoDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  setSchedule(DateTime dateTime) async {
    await np.zonedSchedule(
        0,
        '今天已設立運動計畫',
        '記得要運動喔！',
        _convertTime(dateTime),
        await notificatinoDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  setCostomize(Plan plan) {
    for (DateTime dateTime = DateTime.now();
        dateTime.isBefore(plan.end_date);
        dateTime.add(const Duration(days: 1))) {
      if (plan.execute[dateTime.weekday - 1]) {
        setSchedule(dateTime);
      }
    }
  }
}
