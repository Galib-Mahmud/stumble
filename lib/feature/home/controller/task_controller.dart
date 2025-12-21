import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

class TaskController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // Observables
  var isLoading = false.obs;
  var tasks = <TaskModel>[].obs;

  // Selection mode
  var isSelectionMode = false.obs;
  var selectedTaskIds = <int>{}.obs;

  // Text controllers
  final titleController = TextEditingController();
  final durationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  @override
  void onClose() {
    titleController.dispose();
    durationController.dispose();
    super.onClose();
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await UserInfo.getAccessToken();
    return {"Authorization": "Bearer $token"};
  }

  /// Fetch all tasks
  Future<void> fetchTasks() async {
    try {
      isLoading.value = true;
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(ApiEndpoint.tasks, headers: headers);

      if (response != null) {
        List<dynamic> taskList = [];
        if (response is List) {
          taskList = response;
        } else if (response['results'] != null) {
          taskList = response['results'];
        }
        tasks.value = taskList
            .where((json) => json['id'] != null)
            .map((json) => TaskModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("❌ Error fetching tasks: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new task
  Future<void> createTask({
    required String title,
    required String duration,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = {"title": title, "duration": duration};

      final response = await _apiClient.post(
        ApiEndpoint.tasks,
        headers: headers,
        body: body,
      );

      if (response != null && response['id'] != null) {
        tasks.add(TaskModel.fromJson(response));
        _showSuccessSnackbar("Task created!");
      } else {
        await fetchTasks();
        _showSuccessSnackbar("Task created!");
      }
    } catch (e) {
      print("❌ Error creating task: $e");
      _showErrorSnackbar("Failed to create task");
    }
  }

  /// Delete single task
  Future<void> deleteTask(int taskId) async {
    try {
      final headers = await _getAuthHeaders();
      await _apiClient.delete(ApiEndpoint.taskById(taskId), headers: headers);
      tasks.removeWhere((t) => t.id == taskId);
      selectedTaskIds.remove(taskId);
      _showSuccessSnackbar("Task deleted!");
    } catch (e) {
      print("❌ Error deleting task: $e");
      _showErrorSnackbar("Failed to delete task");
      await fetchTasks();
    }
  }

  // ========== Selection Mode ==========

  void enterSelectionMode() {
    isSelectionMode.value = true;
    selectedTaskIds.clear();
  }

  void exitSelectionMode() {
    isSelectionMode.value = false;
    selectedTaskIds.clear();
  }

  void toggleTaskSelection(int taskId) {
    if (selectedTaskIds.contains(taskId)) {
      selectedTaskIds.remove(taskId);
      if (selectedTaskIds.isEmpty) {
        isSelectionMode.value = false;
      }
    } else {
      selectedTaskIds.add(taskId);
      isSelectionMode.value = true;
    }
  }

  bool isTaskSelected(int taskId) => selectedTaskIds.contains(taskId);

  void selectAllTasks() {
    if (selectedTaskIds.length == tasks.length) {
      selectedTaskIds.clear();
      isSelectionMode.value = false;
    } else {
      selectedTaskIds.value = tasks.map((t) => t.id).toSet();
      isSelectionMode.value = true;
    }
  }

  bool get isAllSelected => tasks.isNotEmpty && selectedTaskIds.length == tasks.length;

  /// Delete selected tasks
  Future<void> deleteSelectedTasks() async {
    if (selectedTaskIds.isEmpty) return;

    final idsToDelete = List<int>.from(selectedTaskIds);
    int successCount = 0;

    for (final taskId in idsToDelete) {
      try {
        final headers = await _getAuthHeaders();
        await _apiClient.delete(ApiEndpoint.taskById(taskId), headers: headers);
        tasks.removeWhere((t) => t.id == taskId);
        successCount++;
      } catch (e) {
        print("❌ Error deleting task $taskId: $e");
      }
    }

    selectedTaskIds.clear();
    isSelectionMode.value = false;
    await fetchTasks();

    if (successCount > 0) {
      _showSuccessSnackbar("$successCount task${successCount > 1 ? 's' : ''} deleted!");
    } else {
      _showErrorSnackbar("Failed to delete tasks");
    }
  }

  void showDeleteSelectedConfirmation() {
    if (selectedTaskIds.isEmpty) return;

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          "Delete ${selectedTaskIds.length} Task${selectedTaskIds.length > 1 ? 's' : ''}?",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "This action cannot be undone.",
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteSelectedTasks();
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.redAccent, fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Show Add Task Bottom Sheet
  void showAddTaskSheet() {
    exitSelectionMode();
    titleController.clear();
    durationController.clear();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Add New Task",
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Task Title",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: titleController,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: "Enter task title",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14.sp),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Duration",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: durationController,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  decoration: InputDecoration(
                    hintText: "e.g., 15-30 min",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14.sp),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    prefixIcon: Icon(Icons.access_time, color: Colors.white.withOpacity(0.5), size: 20.sp),
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty && durationController.text.isNotEmpty) {
                        createTask(
                          title: titleController.text.trim(),
                          duration: durationController.text.trim(),
                        );
                        Get.back();
                      } else {
                        _showErrorSnackbar("Please fill all fields");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      "Add Task",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success", message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error", message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
    );
  }
}

/// Task Model
class TaskModel {
  final int id;
  final String title;
  final String duration;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}