import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../websocket/inner_circle_chat_controller.dart';
import '../websocket/tribe_message_model.dart';



class InnerCircleChatScreen extends StatelessWidget {
  // Required parameters - passed via Get.arguments in route
  final String tribeId;
  final String tribeName;
  final String apiBaseUrl;
  final String accessToken;
  final String currentUserEmail;
  final String? wsBaseUrl;

  const InnerCircleChatScreen({
    super.key,
    required this.tribeId,
    required this.apiBaseUrl,
    required this.accessToken,
    required this.currentUserEmail,
    this.tribeName = 'Inner Circle Chat',
    this.wsBaseUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with tag for unique instance per tribe
    final controller = Get.put(
      InnerCircleChatController(),
      tag: 'tribe_$tribeId',
    );

    // Initialize chat connection with dynamic values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeChat(
        apiBaseUrl: apiBaseUrl,
        tribeId: tribeId,
        accessToken: accessToken,
        currentUserEmail: currentUserEmail,
        wsBaseUrl: wsBaseUrl,
      );
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF362565),
              Color(0xFF210F3E),
              Color(0xFF080A15),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(controller),
            _buildConnectionStatus(controller),
            Expanded(child: _buildMessageList(controller)),
            _buildMessageInput(controller),
          ],
        ),
      ),
    );
  }

  // App Bar with online count
  Widget _buildAppBar(InnerCircleChatController controller) {
    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 16.w, right: 16.w, bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              // Disconnect WebSocket when leaving
              controller.disconnectWebSocket();
              Get.back();
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Title and Online Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  tribeName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: controller.isConnected.value
                            ? const Color(0xFF4CAF50)
                            : controller.isConnecting.value
                            ? Colors.orange
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      controller.isConnected.value
                          ? '${controller.onlineCount.value} Online'
                          : controller.isConnecting.value
                          ? 'Connecting...'
                          : 'Disconnected',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),

          // Support Button
          GestureDetector(
            onTap: () => _showSupportOptions(controller),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(width: 8.w),

          // Menu Button
          GestureDetector(
            onTap: () {
              // Handle menu
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Connection status banner
  Widget _buildConnectionStatus(InnerCircleChatController controller) {
    return Obx(() {
      if (controller.isConnecting.value) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: Colors.orange.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.orange,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Connecting to chat...',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          color: Colors.red.withOpacity(0.2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red[300],
                    fontSize: 12.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => controller.retryConnection(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  // Message List
  Widget _buildMessageList(InnerCircleChatController controller) {
    return Obx(() {
      if (controller.isLoadingHistory.value && controller.messages.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white54),
        );
      }

      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                color: Colors.white.withOpacity(0.3),
                size: 64.w,
              ),
              SizedBox(height: 16.h),
              Text(
                'No messages yet',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Be the first to say something!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: controller.messages.length + 1,
        itemBuilder: (context, index) {
          // Loading indicator at top
          if (index == 0) {
            return Obx(() => controller.isLoadingHistory.value
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white54),
              ),
            )
                : const SizedBox.shrink());
          }

          final message = controller.messages[index - 1];
          return _buildMessageItem(message, controller);
        },
      );
    });
  }

  // Message Item
  Widget _buildMessageItem(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    if (message.isMe) {
      return _buildMyMessage(message, controller);
    } else {
      return _buildOtherMessage(message, controller);
    }
  }

  // Other User's Message (including bot messages)
  Widget _buildOtherMessage(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender Name with Bot Badge
          Padding(
            padding: EdgeInsets.only(left: 44.w, bottom: 6.h),
            child: Row(
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (message.isBot) ...[
                  SizedBox(width: 6.w),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4EFFEE).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'BOT',
                      style: TextStyle(
                        color: const Color(0xFF4EFFEE),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (message.isEdited) ...[
                  SizedBox(width: 6.w),
                  Text(
                    '(edited)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 10.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Avatar and Message Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: message.isBot
                        ? const Color(0xFF4EFFEE).withOpacity(0.5)
                        : const Color(0xFF4EFFEE).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: message.userAvatar != null
                      ? Image.network(
                    message.userAvatar!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(message.isBot);
                    },
                  )
                      : _buildDefaultAvatar(message.isBot),
                ),
              ),

              SizedBox(width: 8.w),

              // Message Bubble
              Flexible(
                child: GestureDetector(
                  onLongPress: () => _showMessageOptions(message, controller),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: message.isBot
                          ? const Color(0xFF1A3A4A)
                          : const Color(0xFF2A2A4A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                      border: message.isBot
                          ? Border.all(
                        color: const Color(0xFF4EFFEE).withOpacity(0.3),
                      )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                            height: 1.4,
                          ),
                        ),
                        if (message.reactions.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          _buildReactions(message),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 50.w),
            ],
          ),
        ],
      ),
    );
  }

  // My Message
  Widget _buildMyMessage(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (message.isEdited)
            Padding(
              padding: EdgeInsets.only(right: 8.w, bottom: 4.h),
              child: Text(
                '(edited)',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 10.sp,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 50.w),

              // Message Bubble
              Flexible(
                child: GestureDetector(
                  onLongPress: () => _showMessageOptions(message, controller),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6B4EAA),
                          Color(0xFF8B5CF6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(4.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check_circle,
                              color: const Color(0xFF4EFFEE),
                              size: 16.w,
                            ),
                          ],
                        ),
                        if (message.reactions.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          _buildReactions(message),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reactions display
  Widget _buildReactions(TribeMessage message) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: message.reactions.map((reaction) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reaction.emoji, style: TextStyle(fontSize: 12.sp)),
              SizedBox(width: 4.w),
              Text(
                '${reaction.count}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Default avatar widget
  Widget _buildDefaultAvatar(bool isBot) {
    return Container(
      color: isBot ? const Color(0xFF1A3A4A) : const Color(0xFF6B4EAA),
      child: Icon(
        isBot ? Icons.smart_toy : Icons.person,
        color: isBot ? const Color(0xFF4EFFEE) : Colors.white,
        size: 20.w,
      ),
    );
  }

  // Message Input
  Widget _buildMessageInput(InnerCircleChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment Button
            GestureDetector(
              onTap: () {
                // TODO: Handle file attachment
              },
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.image,
                  color: Colors.white.withOpacity(0.6),
                  size: 22.w,
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Text Input
            Expanded(
              child: Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: TextField(
                  controller: controller.messageController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Send Button
            Obx(() => GestureDetector(
              onTap: controller.isConnected.value
                  ? () => controller.sendMessage()
                  : null,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: controller.isConnected.value
                      ? const Color(0xFF6B4EAA)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.send,
                  color: controller.isConnected.value
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  size: 20.w,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Show message options (edit, delete, react, report)
  void _showMessageOptions(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick reactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['❤️', '😂', '😮', '😢', '👍', '🔥'].map((emoji) {
                return GestureDetector(
                  onTap: () {
                    controller.reactToMessage(message.id, emoji);
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    child: Text(emoji, style: TextStyle(fontSize: 24.sp)),
                  ),
                );
              }).toList(),
            ),
            Divider(color: Colors.white.withOpacity(0.1)),

            // Edit option (only for own messages)
            if (controller.isMyMessage(message))
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white70),
                title:
                const Text('Edit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  _showEditDialog(message, controller);
                },
              ),

            // Delete option (only for own messages)
            if (controller.isMyMessage(message))
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  _confirmDelete(message, controller);
                },
              ),

            // Report option (for others' messages)
            if (!controller.isMyMessage(message))
              ListTile(
                leading: const Icon(Icons.flag, color: Colors.orange),
                title:
                const Text('Report', style: TextStyle(color: Colors.orange)),
                onTap: () {
                  Get.back();
                  _showReportDialog(message, controller);
                },
              ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  // Edit message dialog
  void _showEditDialog(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    final editController = TextEditingController(text: message.message);

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title:
        const Text('Edit Message', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: editController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Edit your message...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.editMessage(message.id, editController.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete confirmation
  void _confirmDelete(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title:
        const Text('Delete Message', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this message?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteMessage(message.id);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Report message dialog
  void _showReportDialog(
      TribeMessage message,
      InnerCircleChatController controller,
      ) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title:
        const Text('Report Message', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Why are you reporting this message?',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: reasonController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () {
              controller.reportMessage(message.id, reasonController.text);
              Get.back();
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  // Support options (Gentle, Critical, Urgent)
  void _showSupportOptions(InnerCircleChatController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Support',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'How are you feeling right now?',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // Gentle support
            _buildSupportOption(
              icon: Icons.spa,
              color: Colors.green,
              title: 'I could use some support',
              subtitle: 'A bot will offer gentle encouragement',
              onTap: () {
                Get.back();
                _showSupportMessageInput(controller, SupportMode.gentle);
              },
            ),

            SizedBox(height: 12.h),

            // Critical support
            _buildSupportOption(
              icon: Icons.warning_amber,
              color: Colors.orange,
              title: 'I\'m struggling right now',
              subtitle: 'A bot will provide focused support',
              onTap: () {
                Get.back();
                _showSupportMessageInput(controller, SupportMode.critical);
              },
            ),

            SizedBox(height: 12.h),

            // Urgent support
            _buildSupportOption(
              icon: Icons.emergency,
              color: Colors.red,
              title: 'I need immediate help (SOS)',
              subtitle: 'Get emergency contact numbers',
              onTap: () {
                Get.back();
                controller.requestSupport(
                  mode: SupportMode.urgent,
                  message: 'Urgent help needed',
                );
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16.w),
          ],
        ),
      ),
    );
  }

  void _showSupportMessageInput(
      InnerCircleChatController controller,
      SupportMode mode,
      ) {
    final messageController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(
          mode == SupportMode.gentle ? 'Tell us more' : 'What\'s happening?',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: messageController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Share how you\'re feeling...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.requestSupport(
                mode: mode,
                message: messageController.text,
              );
              Get.back();
            },
            child: const Text('Request Support'),
          ),
        ],
      ),
    );
  }
}