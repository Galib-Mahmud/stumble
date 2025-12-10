import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stumble/feature/widget/condition/custom_appbar2.dart';

// ============================================
// Custom App Bar for Chat Screen with Subtitle
// ============================================

class CustomAppBarChat extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final int? onlineCount;
  final VoidCallback? onBack;
  final Color backButtonColor;
  final String? actionIcon;
  final VoidCallback? onAction;

  const CustomAppBarChat({
    super.key,
    required this.title,
    this.subtitle,
    this.onlineCount,
    this.onBack,
    this.backButtonColor = const Color(0xFF2D2D3A),
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          if (subtitle != null || onlineCount != null) ...[
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Green online indicator dot
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  subtitle ?? '${onlineCount} Online',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: onBack != null
          ? Padding(
        padding: EdgeInsets.all(8.w),
        child: Container(
          decoration: BoxDecoration(
            color: backButtonColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16.sp,
            ),
            onPressed: onBack,
            padding: EdgeInsets.zero,
          ),
        ),
      )
          : null,
      actions: [
        if (actionIcon != null)
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: onAction,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: backButtonColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    actionIcon!,
                    height: 20.h,
                    width: 20.w,
                    fit: BoxFit.contain,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        else
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: onAction,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: backButtonColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

// ============================================
// Inner Circle Chat Screen
// ============================================

class InnerCircleChatScreen extends StatefulWidget {
  const InnerCircleChatScreen({super.key});

  @override
  State<InnerCircleChatScreen> createState() => _InnerCircleChatScreenState();
}

class _InnerCircleChatScreenState extends State<InnerCircleChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample chat messages
  final List<ChatMessage> messages = [
    ChatMessage(
      senderName: "Maya Rivers",
      senderAvatar: "assets/images/avatar_maya.png",
      message:
      "It's hard. But you know, talking 😊😊 about it helps a little. I'm here if you need someone to listen.",
      isMe: false,
      showAvatar: true,
    ),
    ChatMessage(
      senderName: "Depressed Riaz",
      senderAvatar: "",
      message:
      "I get that. It's like you're there physically, but your mind is elsewhere, and no one seems to notice.😔😔",
      isMe: false,
      showAvatar: false,
    ),
    ChatMessage(
      senderName: "Depressed Riaz",
      senderAvatar: "",
      message:
      "Exactly. I want to reach out, but I feel like no one will get it. Or they'll think I'm just overreacting.",
      isMe: false,
      showAvatar: false,
    ),
    ChatMessage(
      senderName: "Depressed Riaz",
      senderAvatar: "",
      message:
      "I get that. It's like you're there physically, but your mind is elsewhere, and no one seems to notice. 😢😢",
      isMe: false,
      showAvatar: false,
    ),
    ChatMessage(
      senderName: "Me",
      senderAvatar: "",
      message: "Thanks, Ethan. It means more than you know.",
      isMe: true,
      showAvatar: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar2(title: "Inner Circle Chat \n    4622 online"),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/avatar/Inner Circle Chat.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Divider line below app bar
              Container(
                height: 0.5,
                color: Colors.grey.withOpacity(0.3),
              ),

              // Chat Messages
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    children: messages
                        .map((msg) => _buildMessageBubble(msg))
                        .toList(),
                  ),
                ),
              ),

              // Message Input
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment:
        message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender Name with Avatar (for other users only)
          if (!message.isMe)
            Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.showAvatar) ...[
                    // Avatar with gradient border
                    Container(
                      padding: EdgeInsets.all(1.5.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFE040FB),
                            Color(0xFF7C4DFF),
                            Color(0xFF536DFE),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 10.r,
                        backgroundColor: const Color(0xFF1A1A2E),
                        backgroundImage: message.senderAvatar.isNotEmpty
                            ? AssetImage(message.senderAvatar)
                            : null,
                        child: message.senderAvatar.isEmpty
                            ? Text(
                          message.senderName[0],
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            : null,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    message.senderName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

          // Message Bubble
          Row(
            mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: 250.w,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: message.isMe
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF2D2D3A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.r),
                    topRight: Radius.circular(18.r),
                    bottomLeft: Radius.circular(message.isMe ? 18.r : 4.r),
                    bottomRight: Radius.circular(message.isMe ? 4.r : 18.r),
                  ),
                ),
                child: message.isMe
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.check_circle,
                      color: Colors.white.withOpacity(0.8),
                      size: 16.sp,
                    ),
                  ],
                )
                    : Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          // Attachment Button
          GestureDetector(
            onTap: () {
              // Handle attachment
            },
            child: Icon(
              Icons.attach_file,
              color: const Color(0xFF6B7280),
              size: 24.sp,
            ),
          ),

          SizedBox(width: 10.w),

          // Text Input Field
          Expanded(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F2E),
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Center(
                child: TextField(
                  controller: _messageController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type A Message',
                    hintStyle: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // Send Button
          GestureDetector(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  messages.add(ChatMessage(
                    senderName: "Me",
                    senderAvatar: "",
                    message: _messageController.text,
                    isMe: true,
                    showAvatar: false,
                  ));
                  _messageController.clear();
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });
              }
            },
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// Chat Message Model
// ============================================

class ChatMessage {
  final String senderName;
  final String senderAvatar;
  final String message;
  final bool isMe;
  final bool showAvatar;

  ChatMessage({
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.isMe,
    required this.showAvatar,
  });
}