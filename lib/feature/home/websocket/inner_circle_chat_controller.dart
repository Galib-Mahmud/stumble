import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'tribe_chat_api_service.dart';
import 'tribe_chat_websocket_service.dart';
import 'tribe_message_model.dart';

class InnerCircleChatController extends GetxController {
  // Services
  final TribeChatWebSocketService _wsService = TribeChatWebSocketService();
  final TribeChatApiService _apiService = TribeChatApiService();
  final ImagePicker _imagePicker = ImagePicker(); // NEW: For image picking

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
  String? _apiBaseUrl;
  String? _wsBaseUrl;

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
  Future<void> initializeChat({
    required String apiBaseUrl,
    required String tribeId,
    required String accessToken,
    required String currentUserEmail,
    String? wsBaseUrl,
  }) async {
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

    _apiBaseUrl = apiBaseUrl;
    _tribeId = tribeId;
    _accessToken = accessToken;
    _currentUserEmail = currentUserEmail;

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

    _setupWebSocketCallbacks();
    await loadMessageHistory();
    await connectWebSocket();
  }

  void _setupWebSocketCallbacks() {
    _wsService.onConnectionEstablished = _onConnectionEstablished;
    _wsService.onNewMessage = _onNewMessage;
    _wsService.onMessageEdited = _onMessageEdited;
    _wsService.onMessageDeleted = _onMessageDeleted;
    _wsService.onReactionUpdate = _onReactionUpdate;
    _wsService.onError = _onError;
    _wsService.onDisconnected = _onDisconnected;
  }

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
    final action = data['action'] as String?;
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

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

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

  void reactToMessage(int messageId, String emoji) {
    _wsService.sendReaction(messageId, emoji);
  }

  void editMessage(int messageId, String newText) {
    if (newText.trim().isEmpty) return;
    _wsService.editMessage(messageId, newText.trim());
  }

  void deleteMessage(int messageId, {String? reason}) {
    _wsService.deleteMessage(messageId, reason: reason);
  }

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

  // ==================== NEW: IMAGE SENDING ====================

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Send Image',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.photo_library, color: Colors.blue),
              ),
              title: const Text('Gallery', style: TextStyle(color: Colors.white)),
              subtitle: Text('Choose from your photos', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              onTap: () {
                Get.back();
                _pickAndSendImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.green),
              ),
              title: const Text('Camera', style: TextStyle(color: Colors.white)),
              subtitle: Text('Take a new photo', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              onTap: () {
                Get.back();
                _pickAndSendImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      if (image == null) return;
      _showImagePreviewDialog(File(image.path));
    } catch (e) {
      print('❌ Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
    }
  }

  void _showImagePreviewDialog(File imageFile) {
    final captionController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.file(imageFile, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.grey[800], child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 48)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: captionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add a caption (optional)...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6B4EAA))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: Colors.white70)))),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(() => ElevatedButton(
                            onPressed: isSending.value ? null : () => _sendImageAsBase64(imageFile, captionController.text),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B4EAA), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                            child: isSending.value
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _sendImageAsBase64(File imageFile, String caption) async {
    if (!isConnected.value) {
      Get.snackbar('Not Connected', 'Please wait while we reconnect...', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
      return;
    }

    if (messagesSentThisMinute.value >= maxMessagesPerMinute) {
      Get.snackbar('Rate Limited', 'You can only send $maxMessagesPerMinute messages per minute', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange.withOpacity(0.9), colorText: Colors.white);
      return;
    }

    isSending.value = true;

    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final extension = imageFile.path.split('.').last.toLowerCase();
      String mimeType = 'image/jpeg';
      if (extension == 'png') mimeType = 'image/png';
      else if (extension == 'gif') mimeType = 'image/gif';
      else if (extension == 'webp') mimeType = 'image/webp';

      String messageText = caption.isNotEmpty ? '$caption\n[img:$mimeType]$base64Image[/img]' : '[img:$mimeType]$base64Image[/img]';

      _wsService.sendMessage(messageText);
      messagesSentThisMinute.value++;

      Get.back();
      print('✅ Image sent as base64 (${bytes.length} bytes)');
    } catch (e) {
      print('❌ Error sending image: $e');
      Get.snackbar('Send Failed', 'Failed to send image. Please try again.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
    } finally {
      isSending.value = false;
    }
  }

  // ==================== REST API Methods ====================

  Future<void> loadMessageHistory({bool refresh = false}) async {
    if (isLoadingHistory.value) return;
    if (_tribeId == null || _accessToken == null || _apiBaseUrl == null) {
      print('❌ Cannot load history - missing config');
      return;
    }

    if (refresh) {
      _currentPage = 1;
      hasMoreMessages.value = true;
      messages.clear();
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
        if (refresh || _currentPage == 1) {
          messages.value = historyMessages;
          _scrollToBottomAfterBuild();
        } else {
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
        Get.snackbar('Support Requested', 'Help is on the way', snackPosition: SnackPosition.TOP, backgroundColor: Colors.green.withOpacity(0.9), colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to request support', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red.withOpacity(0.9), colorText: Colors.white);
    }
  }

  void _showEmergencyModal(List<EmergencyContact> contacts) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(children: [Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28), SizedBox(width: 8), Text('Get Help Now', style: TextStyle(color: Colors.white))]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: contacts.map((contact) => ListTile(leading: const Icon(Icons.phone, color: Colors.green), title: Text(contact.name, style: const TextStyle(color: Colors.white)), subtitle: Text(contact.phone, style: const TextStyle(color: Colors.white70)), onTap: () {})).toList(),
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Close'))],
      ),
      barrierDismissible: false,
    );
  }

  // ==================== Utilities ====================

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels <= 100 && !isLoadingHistory.value && hasMoreMessages.value) {
        loadMessageHistory();
      }
    });
  }

  void _startRateLimitTimer() {
    _rateLimitResetTimer = Timer.periodic(const Duration(minutes: 1), (_) => messagesSentThisMinute.value = 0);
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }
  }

  void _scrollToBottomAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void retryConnection() {
    errorMessage.value = '';
    connectWebSocket();
  }

  Future<void> refreshChat() async {
    await loadMessageHistory(refresh: true);
    if (!isConnected.value) {
      await connectWebSocket();
    }
  }

  bool isMyMessage(TribeMessage message) {
    return message.isMe;
  }

  TribeMessage? getMessageById(int id) {
    try {
      return messages.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}