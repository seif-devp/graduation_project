import 'package:graduation_project/core/networking/dio.dart';
import 'package:graduation_project/features/Notifications/notification_seeker/data/model.dart';

class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications() async {
    final response = await DioFactory.getDio().get('/api/notifications');

    final dynamic responseData = response.data;

    List<dynamic> items = [];

    // ✅ الـ API بيرجع List مباشرة مش {"items": [...]}
    if (responseData is List) {
      items = responseData;
    } else if (responseData is Map) {
      items = responseData['items'] ?? responseData['data'] ?? [];
    }

    return items.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> markAsRead(String id) async =>
      await DioFactory.getDio().patch('/api/notifications/$id/read');

  Future<void> markAllAsRead() async =>
      await DioFactory.getDio().patch('/api/notifications/read-all');

  Future<void> deleteNotification(String id) async =>
      await DioFactory.getDio().delete('/api/notifications/$id');
}