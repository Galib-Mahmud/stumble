import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InnerCircleChatScreen extends StatefulWidget {
  const InnerCircleChatScreen({super.key});

  @override
  State<InnerCircleChatScreen> createState() => _InnerCircleChatScreenState();
}

class _InnerCircleChatScreenState extends State<InnerCircleChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Sample chat messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      senderName: 'Maya Rivers',
      senderAvatar: 'assets/images/chat/avatar_maya.png',
      message: "It's hard. But you know, talking 😊😊 about it helps a little. I'm here if you need someone to listen.",
      isMe: false,
    ),
    ChatMessage(
      senderName: 'Depressed Riaz',
      senderAvatar: 'assets/images/chat/avatar_riaz.png',
      message: "I get that. It's like you're there physically, but your mind is elsewhere, and no one seems to notice.😊😊",
      isMe: false,
    ),
    ChatMessage(
      senderName: 'Depressed Riaz',
      senderAvatar: 'assets/images/chat/avatar_riaz.png',
      message: "Exactly. I want to reach out, but I feel like no one will get it. Or they'll think I'm just overreacting.",
      isMe: false,
    ),
    ChatMessage(
      senderName: 'Depressed Riaz',
      senderAvatar: 'assets/images/chat/avatar_riaz.png',
      message: "I get that. It's like you're there physically, but your mind is elsewhere, and no one seems to notice. 😊😊",
      isMe: false,
    ),
    ChatMessage(
      senderName: 'Me',
      senderAvatar: '',
      message: "Thanks, Ethan. It means more than you know.",
      isMe: true,
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
            // App Bar
            _buildAppBar(),

            // Chat Messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(_messages[index]);
                },
              ),
            ),

            // Message Input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // App Bar
  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(top: 30.h,left: 16.w,right: 16.w,bottom: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
                SizedBox(height: 20.h),
                Text(
                  'Inner Circle Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '4622 Online',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Button
          GestureDetector(
            onTap: () {
              // Handle menu
            },
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color:  Colors.white.withOpacity(0.2),
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

  // Message Item
  Widget _buildMessageItem(ChatMessage message) {
    if (message.isMe) {
      return _buildMyMessage(message);
    } else {
      return _buildOtherMessage(message);
    }
  }

  // Other User's Message
  Widget _buildOtherMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender Name
          Padding(
            padding: EdgeInsets.only(left: 44.w, bottom: 6.h),
            child: Text(
              message.senderName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
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
                    color: const Color(0xFF4EFFEE).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    message.senderAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF6B4EAA),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Message Bubble
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A4A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 50.w), // Right padding for other messages
            ],
          ),
        ],
      ),
    );
  }

  // My Message
  Widget _buildMyMessage(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 50.w), // Left padding for my messages

          // Message Bubble
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
              child: Row(
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
            ),
          ),
        ],
      ),
    );
  }

  // Message Input
  Widget _buildMessageInput() {
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
      child: Row(
        children: [
          // Attachment Button
          GestureDetector(
            onTap: () {
              // Handle attachment
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset('assets/images/icon/gallary.png')
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
                controller: _messageController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Type A Message',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Send Button
          GestureDetector(
            onTap: () {
              // Handle send
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add(ChatMessage(
                    senderName: 'Me',
                    senderAvatar: '',
                    message: _messageController.text,
                    isMe: true,
                  ));
                  _messageController.clear();
                });
              }
            },
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset("assets/images/icon/send.png")
            ),
          ),
        ],
      ),
    );
  }
}

// Chat Message Model
class ChatMessage {
  final String senderName;
  final String senderAvatar;
  final String message;
  final bool isMe;

  ChatMessage({
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.isMe,
  });
}