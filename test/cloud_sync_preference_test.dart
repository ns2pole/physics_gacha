import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/services/auth/cloud_sync_preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('unset preference is off', () async {
    expect(await CloudSyncPreferenceService.isEnabledForUser('u1'), isFalse);
  });

  test('setEnabled persists per uid', () async {
    await CloudSyncPreferenceService.setEnabled('u1', true);
    await CloudSyncPreferenceService.setEnabled('u2', false);
    expect(await CloudSyncPreferenceService.isEnabledForUser('u1'), isTrue);
    expect(await CloudSyncPreferenceService.isEnabledForUser('u2'), isFalse);

    await CloudSyncPreferenceService.refreshForUser('u1');
    expect(CloudSyncPreferenceService.enabledListenable.value, isTrue);

    await CloudSyncPreferenceService.removeForUser('u1');
    expect(await CloudSyncPreferenceService.isEnabledForUser('u1'), isFalse);
  });
}
