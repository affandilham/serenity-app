import '../entities/craving_session.dart';

abstract interface class CravingRepository {
  Future<CravingSession> startSession(StartCravingSessionInput input);

  Future<CravingSession> finishSession(FinishCravingSessionInput input);

  Future<CravingSession?> getActiveSession();

  Stream<List<CravingSession>> watchSessions();
}
