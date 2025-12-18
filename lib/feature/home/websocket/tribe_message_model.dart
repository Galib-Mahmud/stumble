class TribeMessage {
  final int id;
  final String message;
  final String userEmail;
  final String? userAvatar;
  final String senderName;
  final bool isBot;
  final bool isMe;
  final DateTime createdAt;
  final List<MessageReaction> reactions;
  final bool isEdited;
  final bool isDeleted;

  TribeMessage({
    required this.id,
    required this.message,
    required this.userEmail,
    this.userAvatar,
    required this.senderName,
    required this.isBot,
    required this.isMe,
    required this.createdAt,
    this.reactions = const [],
    this.isEdited = false,
    this.isDeleted = false,
  });

  factory TribeMessage.fromJson(Map<String, dynamic> json, String currentUserEmail) {
    final userEmail = json['user_email']?.toString() ?? '';
    return TribeMessage(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      userEmail: userEmail,
      userAvatar: json['user_avatar'],
      senderName: json['user_name'] ?? json['sender_name'] ?? 'Unknown',
      isBot: userEmail.endsWith('@stumblebot.internal'),
      isMe: userEmail.toLowerCase() == currentUserEmail.toLowerCase(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((r) => MessageReaction.fromJson(r))
          .toList() ??
          [],
      isEdited: json['is_edited'] ?? false,
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  TribeMessage copyWith({
    int? id,
    String? message,
    String? userEmail,
    String? userAvatar,
    String? senderName,
    bool? isBot,
    bool? isMe,
    DateTime? createdAt,
    List<MessageReaction>? reactions,
    bool? isEdited,
    bool? isDeleted,
  }) {
    return TribeMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      userEmail: userEmail ?? this.userEmail,
      userAvatar: userAvatar ?? this.userAvatar,
      senderName: senderName ?? this.senderName,
      isBot: isBot ?? this.isBot,
      isMe: isMe ?? this.isMe,
      createdAt: createdAt ?? this.createdAt,
      reactions: reactions ?? this.reactions,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

class MessageReaction {
  final String emoji;
  final int count;
  final List<int> userIds;
  final bool isReactedByMe;

  MessageReaction({
    required this.emoji,
    required this.count,
    required this.userIds,
    this.isReactedByMe = false,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      emoji: json['emoji'] ?? '',
      count: json['count'] ?? 0,
      userIds: (json['user_ids'] as List<dynamic>?)
          ?.map((id) => id as int)
          .toList() ??
          [],
      isReactedByMe: json['is_reacted_by_me'] ?? false,
    );
  }
}

// WebSocket Event Types
enum ChatEventType {
  connectionEstablished,
  newMessage,
  messageEdited,
  messageDeleted,
  reactionUpdate,
  error,
  unknown,
}

extension ChatEventTypeExtension on ChatEventType {
  static ChatEventType fromString(String type) {
    switch (type) {
      case 'connection_established':
        return ChatEventType.connectionEstablished;
      case 'new_message':
        return ChatEventType.newMessage;
      case 'message_edited':
        return ChatEventType.messageEdited;
      case 'message_deleted':
        return ChatEventType.messageDeleted;
      case 'reaction_update':
        return ChatEventType.reactionUpdate;
      case 'error':
        return ChatEventType.error;
      default:
        return ChatEventType.unknown;
    }
  }
}

// Support Request Models
enum SupportMode { gentle, critical, urgent }

class SupportResponse {
  final bool success;
  final String message;
  final bool isEmergency;
  final String? botMessage;
  final List<EmergencyContact>? emergencyContacts;

  SupportResponse({
    required this.success,
    required this.message,
    this.isEmergency = false,
    this.botMessage,
    this.emergencyContacts,
  });

  factory SupportResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final isEmergency = json['emergency'] ?? false;

    List<EmergencyContact>? contacts;
    if (isEmergency && data != null && data['emergency_contacts'] != null) {
      contacts = (data['emergency_contacts'] as List<dynamic>)
          .map((c) => EmergencyContact.fromJson(c))
          .toList();
    }

    return SupportResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isEmergency: isEmergency,
      botMessage: data?['bot_message'],
      emergencyContacts: contacts,
    );
  }
}

class EmergencyContact {
  final String name;
  final String phone;

  EmergencyContact({required this.name, required this.phone});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}