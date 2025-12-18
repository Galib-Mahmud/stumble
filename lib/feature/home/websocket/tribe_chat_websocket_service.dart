import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef WebSocketCallback = void Function(Map<String, dynamic> data);
typedef VoidCallback = void Function();

class TribeChatWebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  bool _isConnected = false;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;

  // Connection info for reconnection
  String? _currentTribeId;
  String? _currentToken;
  String? _wsBaseUrl;

  // Callbacks
  WebSocketCallback? onConnectionEstablished;
  WebSocketCallback? onNewMessage;
  WebSocketCallback? onMessageEdited;
  WebSocketCallback? onMessageDeleted;
  WebSocketCallback? onReactionUpdate;
  WebSocketCallback? onError;
  VoidCallback? onDisconnected;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;

  /// Connect to tribe chat WebSocket
  /// [wsBaseUrl] should be ws:// or wss:// URL (e.g., "ws://joeapi.dsrt321.online")
  /// Endpoint: ws://<domain>/ws/tribe/{tribe_id}/?token=<token>
  Future<bool> connect({
    required String wsBaseUrl,
    required String tribeId,
    required String token,
  }) async {
    if (_isConnecting) {
      print('⚠️ Already connecting, skipping...');
      return false;
    }

    _isConnecting = true;
    _wsBaseUrl = wsBaseUrl;
    _currentTribeId = tribeId;
    _currentToken = token;

    try {
      // Close existing connection if any
      await disconnect();

      // Build WebSocket URL with token as query parameter
      // Format: ws://<domain>/ws/tribe/{tribe_id}/?token=<token>
      final wsUrl = '$wsBaseUrl/ws/tribe/$tribeId/?token=$token';
      print('🔌 Connecting to WebSocket: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Wait a brief moment for connection to establish
      await Future.delayed(const Duration(milliseconds: 500));

      // Listen to the stream
      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDone,
        cancelOnError: false,
      );

      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;

      print('✅ WebSocket connected successfully');
      return true;
    } catch (e) {
      print('❌ WebSocket connection failed: $e');
      _isConnecting = false;
      _isConnected = false;
      _scheduleReconnect();
      return false;
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String? ?? '';

      print('📩 Received WebSocket event: $type');
      print('📦 Data: $data');

      switch (type) {
        case 'connection_established':
          _isConnected = true;
          onConnectionEstablished?.call(data);
          break;
        case 'new_message':
          onNewMessage?.call(data);
          break;
        case 'message_edited':
          onMessageEdited?.call(data);
          break;
        case 'message_deleted':
          onMessageDeleted?.call(data);
          break;
        case 'reaction_update':
          onReactionUpdate?.call(data);
          break;
        case 'error':
          onError?.call(data);
          break;
        default:
          print('⚠️ Unknown event type: $type');
      }
    } catch (e) {
      print('❌ Error parsing WebSocket message: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    print('❌ WebSocket error: $error');
    _isConnected = false;
    _isConnecting = false;
    onError?.call({'message': error.toString()});
    _scheduleReconnect();
  }

  /// Handle WebSocket connection closed
  void _handleDone() {
    print('🔌 WebSocket connection closed');
    _isConnected = false;
    _isConnecting = false;
    onDisconnected?.call();
    _scheduleReconnect();
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ Max reconnection attempts reached ($_maxReconnectAttempts)');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = Duration(seconds: (2 << _reconnectAttempts).clamp(2, 30));
    _reconnectAttempts++;

    print('🔄 Scheduling reconnection attempt $_reconnectAttempts in ${delay.inSeconds}s');

    _reconnectTimer = Timer(delay, () {
      if (_currentTribeId != null && _currentToken != null && _wsBaseUrl != null) {
        connect(
          wsBaseUrl: _wsBaseUrl!,
          tribeId: _currentTribeId!,
          token: _currentToken!,
        );
      }
    });
  }

  // ==================== Actions (Client -> Server) ====================

  /// Send a text message
  /// Action: {"action": "create", "message": "Hello tribe!"}
  void sendMessage(String message) {
    _sendAction({
      'action': 'create',
      'message': message,
    });
  }

  /// Send a reaction to a message
  /// Action: {"action": "react", "message_id": 123, "emoji": "🔥"}
  void sendReaction(int messageId, String emoji) {
    _sendAction({
      'action': 'react',
      'message_id': messageId,
      'emoji': emoji,
    });
  }

  /// Edit a message
  /// Action: {"action": "edit", "message_id": 123, "message": "Updated text"}
  void editMessage(int messageId, String newMessage) {
    _sendAction({
      'action': 'edit',
      'message_id': messageId,
      'message': newMessage,
    });
  }

  /// Delete a message
  /// Action: {"action": "delete", "message_id": 123, "reason": "typo"}
  void deleteMessage(int messageId, {String? reason}) {
    _sendAction({
      'action': 'delete',
      'message_id': messageId,
      if (reason != null) 'reason': reason,
    });
  }

  /// Report a message
  /// Action: {"action": "report", "message_id": 123, "reason": "Inappropriate"}
  void reportMessage(int messageId, String reason) {
    _sendAction({
      'action': 'report',
      'message_id': messageId,
      'reason': reason,
    });
  }

  /// Send action through WebSocket
  void _sendAction(Map<String, dynamic> action) {
    if (!_isConnected || _channel == null) {
      print('❌ Cannot send action: WebSocket not connected');
      onError?.call({'message': 'WebSocket not connected. Please wait for reconnection.'});
      return;
    }

    try {
      final jsonString = jsonEncode(action);
      print('📤 Sending action: $jsonString');
      _channel!.sink.add(jsonString);
    } catch (e) {
      print('❌ Error sending action: $e');
      onError?.call({'message': 'Failed to send message: $e'});
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    print('🔌 Disconnecting WebSocket...');

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    await _subscription?.cancel();
    _subscription = null;

    if (_channel != null) {
      try {
        await _channel!.sink.close(status.goingAway);
      } catch (e) {
        print('⚠️ Error closing WebSocket sink: $e');
      }
    }
    _channel = null;

    _isConnected = false;
    _isConnecting = false;

    print('🔌 WebSocket disconnected');
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    onConnectionEstablished = null;
    onNewMessage = null;
    onMessageEdited = null;
    onMessageDeleted = null;
    onReactionUpdate = null;
    onError = null;
    onDisconnected = null;
  }
}