import 'dart:async';
import 'dart:convert';

import 'package:puntgpt_nick/core/constants/app_config.dart';
import 'package:puntgpt_nick/core/helper/log_helper.dart';
import 'package:puntgpt_nick/services/storage/locale_storage_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Connection state of the chat WebSocket.
enum ChatConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Manages **raw WebSocket** connection for Punter Club group chat.
/// Backend: Django Channels (raw WS), NOT Socket.IO.
/// Server URL: ws(s)://<domain>/ws/chat/group/<club_id>/?token=<JWT>
///
/// All client messages must be valid JSON with a "type" field.
/// Server sends raw JSON strings.
class ChatService {
  ChatService._();

  static final ChatService _instance = ChatService._();
  static ChatService get instance => _instance;

  WebSocketChannel? _channel;
  String? _currentClubId;
  StreamSubscription? _subscription;

  final _connectionStateController =
      StreamController<ChatConnectionState>.broadcast();
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<ChatConnectionState> get connectionState =>
      _connectionStateController.stream;
  Stream<Map<String, dynamic>> get events => _eventController.stream;

  ChatConnectionState _state = ChatConnectionState.disconnected;
  ChatConnectionState get state => _state;
  bool get isConnected => _state == ChatConnectionState.connected;

  void _setState(ChatConnectionState value) {
    if (_state != value) {
      _state = value;
      _connectionStateController.add(value);
    }
  }

  /// Builds the full WebSocket URI: ws(s)://host/ws/chat/group/<id>/?token=<JWT>
  Uri _buildWsUri(String groupId) {
    final base = AppConfig.baseurl.trim();
    final uri = Uri.parse(base);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final host = uri.host;
    final port = uri.port != 0 && uri.port != 80 && uri.port != 443
        ? ':${uri.port}'
        : '';
    final token = LocaleStorageService.userToken;
    return Uri.parse(
      '$scheme://$host$port/ws/chat/group/$groupId/?token=$token',
    );
  }

  /// Connects to the raw WebSocket for the given [groupId].
  void connect({required String groupId}) {
    if (groupId.isEmpty) {
      Logger.error('[ChatService] groupId is empty');
      return;
    }
    final token = LocaleStorageService.userToken;
    if (token.isEmpty) {
      Logger.error('[ChatService] No JWT token available');
      _setState(ChatConnectionState.error);
      return;
    }
    if (_currentClubId == groupId && isConnected) {
      Logger.info('[ChatService] Already connected to club $groupId');
      return;
    }
    disconnect();

    _currentClubId = groupId;
    _setState(ChatConnectionState.connecting);

    final wsUri = _buildWsUri(groupId);
    Logger.info('[ChatService] Connecting to $wsUri');

    try {
      _channel = WebSocketChannel.connect(wsUri);

      _subscription = _channel!.stream.listen(
        (message) {
          _handleIncoming(message);
        },
        onError: (e) {
          Logger.error('[ChatService] Stream error: $e');
          _setState(ChatConnectionState.error);
        },
        onDone: () {
          Logger.info('[ChatService] WebSocket closed');
          _setState(ChatConnectionState.disconnected);
        },
        cancelOnError: false,
      );

      // Consider connected once the channel is established (stream starts)
      _setState(ChatConnectionState.connected);
      Logger.info('[ChatService] Connected to club $groupId');
    } catch (e, st) {
      Logger.error('[ChatService] Connect exception: $e\n$st');
      _setState(ChatConnectionState.error);
    }
  }

  void _handleIncoming(dynamic message) {
    try {
      if (message is String) {
        final decoded = jsonDecode(message) as Map<String, dynamic>?;
        if (decoded != null) _eventController.add(decoded);
      } else if (message is List<int>) {
        final str = utf8.decode(message);
        final decoded = jsonDecode(str) as Map<String, dynamic>?;
        if (decoded != null) _eventController.add(decoded);
      }
    } catch (e) {
      Logger.error('[ChatService] Parse error: $e');
    }
  }

  /// Sends a JSON payload. Must have "type" field.
  void _send(Map<String, dynamic> payload) {
    if (!isConnected || _channel == null) {
      Logger.warning('[ChatService] Cannot send: not connected');
      return;
    }
    try {
      _channel!.sink.add(jsonEncode(payload));
    } catch (e) {
      Logger.error('[ChatService] Send error: $e');
    }
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;
    _send({'type': 'message', 'content': content.trim()});
  }

  void sendEdit(int messageId, String content) {
    if (content.trim().isEmpty) return;
    _send({'type': 'edit', 'message_id': messageId, 'content': content.trim()});
  }

  void sendDelete(int messageId) {
    _send({'type': 'delete', 'message_id': messageId});
  }

  void sendTyping() {
    _send({'type': 'typing'});
  }

  void sendStopTyping() {
    _send({'type': 'stop_typing'});
  }

  void disconnect() {
    _subscription?.cancel();
    _subscription = null;
    _channel?.sink.close();
    _channel = null;
    _currentClubId = null;
    _setState(ChatConnectionState.disconnected);
  }

  void dispose() {
    disconnect();
    _connectionStateController.close();
    _eventController.close();
  }
}
