import 'package:get/get.dart';

import 'inner_circle_chat_controller.dart';


class InnerCircleChatBinding extends Bindings {
  final String tribeId;

  InnerCircleChatBinding({required this.tribeId});

  @override
  void dependencies() {
    Get.lazyPut<InnerCircleChatController>(
          () => InnerCircleChatController(),
      tag: 'tribe_$tribeId',
    );
  }
}

// Alternative: Use this for static binding without tribe-specific tag
class ChatBindings extends Bindings {
  @override
  void dependencies() {
    // Use Get.create for multiple instances (one per tribe)
    Get.create<InnerCircleChatController>(
          () => InnerCircleChatController(),
    );
  }
}