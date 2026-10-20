import 'package:ai_chat_kit/ai_chat_kit.dart';

class PhysicsAiChatConfig {
  const PhysicsAiChatConfig._();

  static const defaultEndpoint = String.fromEnvironment(
    'AI_CHAT_ENDPOINT',
    defaultValue: '',
  );

  static const installationIdStorageKey = 'physicsgacha/ai_chat_installation_id';

  static AiChatApiConfig apiConfigFromEnvironment() {
    final value = defaultEndpoint.trim();
    final endpoint = value.isEmpty ? null : Uri.parse(value);
    return AiChatApiConfig(
      endpoint: endpoint,
      installationIdStorageKey: installationIdStorageKey,
    );
  }

  static Uri? accountDeletionEndpointFromEnvironment() {
    const deletionValue = String.fromEnvironment(
      'ACCOUNT_DELETION_ENDPOINT',
      defaultValue: '',
    );
    if (deletionValue.trim().isNotEmpty) {
      return Uri.parse(deletionValue.trim());
    }
    return _deriveSiblingEndpoint(
      apiConfigFromEnvironment().endpoint,
      'deleteMyAccount',
    );
  }

  static Uri? _deriveSiblingEndpoint(Uri? endpoint, String functionName) {
    if (endpoint == null) return null;
    final segments = endpoint.pathSegments;
    if (segments.isEmpty || segments.last != 'aiChat') return null;
    return endpoint.replace(
      pathSegments: [...segments.take(segments.length - 1), functionName],
    );
  }
}
