import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'bot_controller.dart';


class BotChatScreen extends StatelessWidget {
  const BotChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BotController controller = Get.find<BotController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: _buildAppBar(controller),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: controller.chatMessages.length,
                itemBuilder: (context, index) {
                  final message = controller.chatMessages[index];
                  return _buildMessageBubble(message, controller);
                },
              );
            }),
          ),

          // Typing Indicator
          Obx(() {
            if (controller.isSending.value) {
              return _buildTypingIndicator(controller);
            }
            return const SizedBox.shrink();
          }),

          // Input Field
          _buildInputField(controller),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BotController controller) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A1A),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        final bot = controller.currentBot.value;
        if (bot == null) return const SizedBox.shrink();

        return Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: bot.botColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                bot.botIcon,
                color: bot.botColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bot.displayName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  bot.persona,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white, size: 22.sp),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message, BotController controller) {
    final isUser = message.isUser;
    final bot = controller.currentBot.value;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: bot?.botColor.withOpacity(0.2) ?? Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                bot?.botIcon ?? Icons.smart_toy,
                color: bot?.botColor ?? Colors.grey,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF262626),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(isUser ? 18.r : 4.r),
                  bottomRight: Radius.circular(isUser ? 4.r : 18.r),
                ),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BotController controller) {
    final bot = controller.currentBot.value;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: bot?.botColor.withOpacity(0.2) ?? Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              bot?.botIcon ?? Icons.smart_toy,
              color: bot?.botColor ?? Colors.grey,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4.w),
                _buildDot(1),
                SizedBox(width: 4.w),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildInputField(BotController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 30.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller.messageController,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  controller.sendMessage(value);
                },
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Obx(() {
            return GestureDetector(
              onTap: controller.isSending.value
                  ? null
                  : () {
                controller.sendMessage(controller.messageController.text);
              },
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: controller.isSending.value
                      ? Colors.grey
                      : const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}