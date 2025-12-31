import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/local_storage/user_info.dart' as local_storage;
import '../../../core/endpoint/api_endpoint.dart';

class BotModel {
  final String name;
  final String displayName;
  final String persona;
  final String description;
  final bool isActive;
  final String chatEndpoint;

  BotModel({
    required this.name,
    required this.displayName,
    required this.persona,
    required this.description,
    required this.isActive,
    required this.chatEndpoint,
  });

  factory BotModel.fromJson(Map<String, dynamic> json) {
    return BotModel(
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      persona: json['persona'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? false,
      chatEndpoint: json['chat_endpoint'] ?? '',
    );
  }

  // Get color based on bot name
  Color get botColor {
    switch (name.toLowerCase()) {
      case 'aquila':
        return const Color(0xFF2196F3);
      case 'azuris':
        return const Color(0xFFE53935);
      case 'ignis':
        return const Color(0xFFFFB300);
      case 'luma':
        return const Color(0xFFB0BEC5);
      case 'solen':
        return const Color(0xFFE91E63);
      case 'terra':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF00BCD4);
    }
  }

  // Get icon image path based on persona
  String get botIconPath {
    switch (persona) {
      case 'The Vision':
        return "assets/images/avatar/aquila.png";
      case 'The Listener':
        return "assets/images/avatar/azuris.png";
      case 'The Flame':
        return "assets/images/avatar/ignis.png";
      case 'The Spark':
        return "assets/images/avatar/luma.png";
      case 'The Architect':
        return "assets/images/avatar/solen.png";
      case 'The Ground':
        return "assets/images/avatar/terra.png";
      default:
        return "assets/images/avatar/profile.png";
    }
  }
}

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class BotController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSending = false.obs;
  RxString errorMessage = ''.obs;

  RxList<BotModel> bots = <BotModel>[].obs;
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;

  Rx<BotModel?> currentBot = Rx<BotModel?>(null);

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    print("🤖 BotController onInit called");
    fetchBots();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchBots() async {
    print("🔄 fetchBots() started...");

    final token = await local_storage.UserInfo.getAccessToken();
    print("🔑 Token: ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}");

    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      print("❌ No token found!");
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final url = "${ApiEndpoint.baseUrl}${ApiEndpoint.bots}";
      print("🌐 API URL: $url");

      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("📡 Response Status Code: ${response.statusCode}");
      print("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        print("🔍 Decoded Type: ${decoded.runtimeType}");

        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey('data')) {
          data = decoded['data'] as List<dynamic>;
        } else if (decoded is Map && decoded.containsKey('results')) {
          data = decoded['results'] as List<dynamic>;
        } else {
          print("❌ Unexpected response format: $decoded");
          errorMessage.value = "Unexpected response format";
          return;
        }

        print("📊 Data length: ${data.length}");

        final allBots = data.map((json) => BotModel.fromJson(json)).toList();
        print("🤖 All bots count: ${allBots.length}");

        for (var bot in allBots) {
          print("  - ${bot.displayName} (${bot.name}) - Active: ${bot.isActive}");
        }

        bots.value = allBots.where((bot) => bot.isActive).toList();
        print("✅ Active bots count: ${bots.length}");

      } else {
        print("❌ API Error: ${response.statusCode}");
        print("❌ Error Body: ${response.body}");
        errorMessage.value = "Failed to load bots (${response.statusCode})";
      }
    } catch (e, stackTrace) {
      print("💥 Exception: $e");
      print("📚 Stack trace: $stackTrace");
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      print("🏁 fetchBots() completed. Bots count: ${bots.length}");
    }
  }

  void selectBot(BotModel bot) {
    currentBot.value = bot;
    chatMessages.clear();
    chatMessages.add(ChatMessage(
      message: "Hi! I'm ${bot.displayName}, ${bot.persona}. ${bot.description} How can I help you today?",
      isUser: false,
    ));
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || currentBot.value == null) return;

    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      return;
    }

    chatMessages.add(ChatMessage(
      message: message.trim(),
      isUser: true,
    ));

    messageController.clear();
    _scrollToBottom();

    try {
      isSending.value = true;

      final endpoint = "${ApiEndpoint.baseUrl}/api/chatbot/chatbot/${currentBot.value!.name}/";

      print("📤 Sending message to: $endpoint");

      final uri = Uri.parse(endpoint);
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_input": message.trim(),
        }),
      );

      print("📡 Chat Response Status: ${response.statusCode}");
      print("📄 Chat Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botResponse = data['response'] ?? "I couldn't understand that.";

        chatMessages.add(ChatMessage(
          message: botResponse,
          isUser: false,
        ));
      } else {
        chatMessages.add(ChatMessage(
          message: "Sorry, I'm having trouble responding right now. Please try again.",
          isUser: false,
        ));
      }
    } catch (e) {
      print("💥 Chat Exception: $e");
      chatMessages.add(ChatMessage(
        message: "Connection error. Please check your internet and try again.",
        isUser: false,
      ));
    } finally {
      isSending.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}