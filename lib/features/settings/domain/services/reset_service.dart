import '../../../../core/database/app_database.dart';
import '../../../../core/notifications/notification_service.dart';

class ResetService {
  ResetService(this._database, this._notifications);

  final AppDatabase _database;
  final NotificationService _notifications;

  Future<void> deleteAllPersonalData() async {
    await _notifications.cancelAll();
    await _database.deleteAllPersonalData();
  }
}
