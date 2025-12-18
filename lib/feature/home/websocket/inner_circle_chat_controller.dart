import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'tribe_chat_api_service.dart';
import 'tribe_chat_websocket_service.dart';
import 'tribe_message_model.dart';

class InnerCircleChatController extends GetxController {
  // Services
  final TribeChatWebSocketService _wsService = TribeChatWebSocketService();
  final TribeChatApiService _apiService = TribeChatApiService();

  // UI Controllers
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observable State
  final RxList<TribeMessage> messages = <TribeMessage>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool hasMoreMessages = true.obs;
  final RxInt onlineCount = 0.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSending = false.obs;

  // Rate limiting (10 messages/minute as per integration guide)
  final RxInt messagesSentThisMinute = 0.obs;
  static const int maxMessagesPerMinute = 10;
  Timer? _rateLimitResetTimer;

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 20;

  // Config - Separate URLs for REST API and WebSocket
  String? _tribeId;
  String? _accessToken;
  String? _currentUserEmail;
  String? _apiBaseUrl;  // http:// for REST API
  String? _wsBaseUrl;   // ws:// for WebSocket

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    _startRateLimitTimer();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _wsService.dispose();
    _rateLimitResetTimer?.cancel();
    super.onClose();
  }

  /// Initialize chat with tribe ID and auth token
  ///
  /// [apiBaseUrl] - REST API URL (e.g., "http://joeapi.dsrt321.online")
  /// [tribeId] - The tribe/chat room ID
  /// [accessToken] - JWT Bearer token
  /// [currentUserEmail] - Current user's email to identify own messages
  /// [wsBaseUrl] - Optional WebSocket URL (auto-derived from apiBaseUrl if not provided)
  Future<void> initializeChat({
    required String apiBaseUrl,
    required String tribeId,
    required String accessToken,
    required String currentUserEmail,
    String? wsBaseUrl,
  }) async {
    // Validate inputs
    if (tribeId.isEmpty) {
      errorMessage.value = 'Invalid tribe ID';
      print('❌ Error: Empty tribe ID');
      return;
    }

    if (accessToken.isEmpty) {
      errorMessage.value = 'Invalid access token';
      print('❌ Error: Empty access token');
      return;
    }

    if (apiBaseUrl.isEmpty) {
      errorMessage.value = 'Invalid API URL';
      print('❌ Error: Empty API base URL');
      return;
    }

    // Store config
    _apiBaseUrl = apiBaseUrl;
    _tribeId = tribeId;
    _accessToken = accessToken;
    _currentUserEmail = currentUserEmail;

    // Derive WebSocket URL from API URL if not provided
    // http:// -> ws://
    // https:// -> wss://
    if (wsBaseUrl != null && wsBaseUrl.isNotEmpty) {
      _wsBaseUrl = wsBaseUrl;
    } else if (apiBaseUrl.startsWith('https://')) {
      _wsBaseUrl = apiBaseUrl.replaceFirst('https://', 'wss://');
    } else {
      _wsBaseUrl = apiBaseUrl.replaceFirst('http://', 'ws://');
    }

    print('═══════════════════════════════════════════');
    print('📡 Chat Configuration:');
    print('   API Base URL: $_apiBaseUrl');
    print('   WebSocket URL: $_wsBaseUrl');
    print('   Tribe ID: $_tribeId');
    print('   User Email: $_currentUserEmail');
    print('═══════════════════════════════════════════');

    // Setup WebSocket callbacks
    _setupWebSocketCallbacks();

    // Load message history first
    await loadMessageHistory();

    // Then connect to WebSocket for real-time updates
    await connectWebSocket();
  }

  /// Setup WebSocket event callbacks
  void _setupWebSocketCallbacks() {
    _wsService.onConnectionEstablished = _onConnectionEstablished;
    _wsService.onNewMessage = _onNewMessage;
    _wsService.onMessageEdited = _onMessageEdited;
    _wsService.onMessageDeleted = _onMessageDeleted;
    _wsService.onReactionUpdate = _onReactionUpdate;
    _wsService.onError = _onError;
    _wsService.onDisconnected = _onDisconnected;
  }

  /// Connect to WebSocket
  Future<void> connectWebSocket() async {
    if (_tribeId == null || _accessToken == null || _wsBaseUrl == null) {
      errorMessage.value = 'Missing configuration for WebSocket connection';
      print('❌ Missing config - tribeId: $_tribeId, token: ${_accessToken != null}, wsUrl: $_wsBaseUrl');
      return;
    }

    isConnecting.value = true;
    errorMessage.value = '';

    final success = await _wsService.connect(
      wsBaseUrl: _wsBaseUrl!,
      tribeId: _tribeId!,
      token: _accessToken!,
    );

    isConnecting.value = false;
    isConnected.value = success;

    if (!success) {
      errorMessage.value = 'Failed to connect to chat';
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnectWebSocket() async {
    await _wsService.disconnect();
    isConnected.value = false;
  }

  // ==================== WebSocket Event Handlers ====================

  void _onConnectionEstablished(Map<String, dynamic> data) {
    isConnected.value = true;
    isConnecting.value = false;
    onlineCount.value = data['member_count'] ?? 0;
    errorMessage.value = '';
    print('✅ Connected! ${onlineCount.value} members online');
  }

  void _onNewMessage(Map<String, dynamic> data) {
    final messageData = data['data'] as Map<String, dynamic>?;
    if (messageData == null) return;

    final newMessage = TribeMessage.fromJson(messageData, _currentUserEmail ?? '');

    // Avoid duplicates
    if (!messages.any((m) => m.id == newMessage.id)) {
      messages.add(newMessage);
      _scrollToBottom();
    }
  }

  void _onMessageEdited(Map<String, dynamic> data) {
    final messageData = data['data'] as Map<String, dynamic>?;
    if (messageData == null) return;

    final updatedMessage = TribeMessage.fromJson(messageData, _currentUserEmail ?? '');
    final index = messages.indexWhere((m) => m.id == updatedMessage.id);

    if (index != -1) {
      messages[index] = updatedMessage.copyWith(isEdited: true);
    }
  }

  void _onMessageDeleted(Map<String, dynamic> data) {
    final messageId = data['message_id'] as int?;
    if (messageId == null) return;

    messages.removeWhere((m) => m.id == messageId);
  }

  void _onReactionUpdate(Map<String, dynamic> data) {
    final messageId = data['message_id'] as int?;
    final emoji = data['emoji'] as String?;
    final action = data['action'] as String?; // 'added' or 'removed'
    final userId = data['user_id'] as int?;

    if (messageId == null || emoji == null || action == null) return;

    final index = messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final message = messages[index];
    final reactions = List<MessageReaction>.from(message.reactions);

    final reactionIndex = reactions.indexWhere((r) => r.emoji == emoji);

    if (action == 'added') {
      if (reactionIndex != -1) {
        final existing = reactions[reactionIndex];
        reactions[reactionIndex] = MessageReaction(
          emoji: emoji,
          count: existing.count + 1,
          userIds: [...existing.userIds, if (userId != null) userId],
          isReactedByMe: existing.isReactedByMe,
        );
      } else {
        reactions.add(MessageReaction(
          emoji: emoji,
          count: 1,
          userIds: [if (userId != null) userId],
        ));
      }
    } else if (action == 'removed' && reactionIndex != -1) {
      final existing = reactions[reactionIndex];
      if (existing.count <= 1) {
        reactions.removeAt(reactionIndex);
      } else {
        reactions[reactionIndex] = MessageReaction(
          emoji: emoji,
          count: existing.count - 1,
          userIds: existing.userIds.where((id) => id != userId).toList(),
          isReactedByMe: existing.isReactedByMe,
        );
      }
    }

    messages[index] = message.copyWith(reactions: reactions);
  }

  void _onError(Map<String, dynamic> data) {
    final message = data['message'] as String? ?? 'An error occurred';
    errorMessage.value = message;

    // Handle rate limit error (429)
    if (message.contains('429') || message.toLowerCase().contains('rate limit')) {
      Get.snackbar(
        'Slow down!',
        'You\'re sending messages too fast. Please wait a moment.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _onDisconnected() {
    isConnected.value = false;
    Get.snackbar(
      'Disconnected',
      'Reconnecting to chat...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // ==================== Message Actions ====================

  /// Send a new message
  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Check rate limit
    if (messagesSentThisMinute.value >= maxMessagesPerMinute) {
      Get.snackbar(
        'Rate Limited',
        'You can only send $maxMessagesPerMinute messages per minute',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (!isConnected.value) {
      Get.snackbar(
        'Not Connected',
        'Please wait while we reconnect...',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    _wsService.sendMessage(text);
    messageController.clear();
    messagesSentThisMinute.value++;
  }

  /// React to a message
  void reactToMessage(int messageId, String emoji) {
    _wsService.sendReaction(messageId, emoji);
  }

  /// Edit a message
  void editMessage(int messageId, String newText) {
    if (newText.trim().isEmpty) return;
    _wsService.editMessage(messageId, newText.trim());
  }

  /// Delete a message
  void deleteMessage(int messageId, {String? reason}) {
    _wsService.deleteMessage(messageId, reason: reason);
  }

  /// Report a message
  void reportMessage(int messageId, String reason) {
    if (reason.trim().isEmpty) return;
    _wsService.reportMessage(messageId, reason.trim());

    Get.snackbar(
      'Report Submitted',
      'Thank you for helping keep this community safe',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
    );
  }

  // ==================== REST API Methods ====================

  /// Load message history
  Future<void> loadMessageHistory({bool refresh = false}) async {
    if (isLoadingHistory.value) return;
    if (_tribeId == null || _accessToken == null || _apiBaseUrl == null) {
      print('❌ Cannot load history - missing config');
      return;
    }

    if (refresh) {
      _currentPage = 1;
      hasMoreMessages.value = true;
    }

    if (!hasMoreMessages.value) return;

    isLoadingHistory.value = true;
    errorMessage.value = '';

    try {
      final historyMessages = await _apiService.getMessageHistory(
        baseUrl: _apiBaseUrl!,
        tribeId: _tribeId!,
        token: _accessToken!,
        page: _currentPage,
        pageSize: _pageSize,
        currentUserEmail: _currentUserEmail ?? '',
      );

      if (historyMessages.isEmpty) {
        hasMoreMessages.value = false;
      } else {
        if (refresh) {
          messages.value = historyMessages;
        } else {
          // Insert at beginning for older messages
          messages.insertAll(0, historyMessages);
        }
        _currentPage++;
      }
      print('✅ Loaded ${historyMessages.length} messages');
    } catch (e) {
      errorMessage.value = 'Failed to load messages';
      print('❌ Error loading messages: $e');
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Request support
  Future<void> requestSupport({
    required SupportMode mode,
    required String message,
  }) async {
    if (_tribeId == null || _accessToken == null || _apiBaseUrl == null) return;

    try {
      final response = await _apiService.requestSupport(
        baseUrl: _apiBaseUrl!,
        token: _accessToken!,
        tribeId: int.parse(_tribeId!),
        mode: mode,
        message: message,
      );

      if (response.isEmergency && response.emergencyContacts != null) {
        _showEmergencyModal(response.emergencyContacts!);
      } else if (response.success) {
        Get.snackbar(
          'Support Requested',
          'Help is on the way',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to request support',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  /// Show emergency contacts modal (for urgent support)
  void _showEmergencyModal(List<EmergencyContact> contacts) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text(
              'Get Help Now',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contacts
              .map((contact) => ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text(
              contact.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              contact.phone,
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              // TODO: Launch phone dialer
              // launchUrl(Uri.parse('tel:${contact.phone}'));
            },
          ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ==================== Utilities ====================

  /// Setup scroll listener for pagination
  void _setupScrollListener() {
    scrollController.addListener(() {
      // Load more when scrolled to top (older messages)
      if (scrollController.position.pixels <= 100) {
        loadMessageHistory();
      }
    });
  }

  /// Start rate limit reset timer
  void _startRateLimitTimer() {
    _rateLimitResetTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) => messagesSentThisMinute.value = 0,
    );
  }

  /// Scroll to bottom of chat
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  /// Retry connection
  void retryConnection() {
    errorMessage.value = '';
    connectWebSocket();
  }

  /// Check if message belongs to current user (for edit/delete options)
  bool isMyMessage(TribeMessage message) {
    return message.isMe;
  }

  /// Get message by ID
  TribeMessage? getMessageById(int id) {
    try {
      return messages.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}