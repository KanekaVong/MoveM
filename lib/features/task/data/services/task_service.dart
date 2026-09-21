import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/task_endpoints.dart';

class TaskService {
  final Dio dio = DioClient().dio;

  Future<Response> createTask(Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.tasks, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTasks({Map<String, dynamic>? queryParameters}) async {
    return await dio.get(TaskEndpoints.tasks, queryParameters: queryParameters, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTaskDetail(String activityId) async {
    return await dio.get(TaskEndpoints.taskDetail(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateTask(String activityId, Map<String, dynamic> data) async {
    return await dio.put(TaskEndpoints.taskDetail(activityId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteTask(String activityId) async {
    return await dio.delete(TaskEndpoints.taskDetail(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> markTaskComplete(String activityId) async {
    return await dio.patch(TaskEndpoints.completeTask(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> restoreTask(String activityId) async {
    return await dio.put(TaskEndpoints.restoreTask(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> permanentDeleteTask(String activityId) async {
    return await dio.delete(TaskEndpoints.permanentDelete(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getParentTasks(String parentId) async {
    return await dio.get(TaskEndpoints.parentTasks(parentId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getChecklistItems(String activityId) async {
    return await dio.get(TaskEndpoints.taskChecklists(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> addChecklistItem(String activityId, Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.taskChecklists(activityId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateChecklistItem(dynamic checklistId, Map<String, dynamic> data) async {
    return await dio.put(TaskEndpoints.updateChecklistItem(checklistId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteChecklistItem(dynamic checklistId) async {
    return await dio.delete(TaskEndpoints.deleteChecklistItem(checklistId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> toggleChecklistItem(dynamic checklistId) async {
    return await dio.patch(TaskEndpoints.toggleChecklistCompletion(checklistId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTaskReminders(String activityId) async {
    return await dio.get(TaskEndpoints.taskReminders(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> addReminder(String activityId, Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.taskReminders(activityId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getUpcomingReminders() async {
    return await dio.get(TaskEndpoints.upcomingReminders, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateReminder(dynamic reminderId, Map<String, dynamic> data) async {
    return await dio.put(TaskEndpoints.reminderDetail(reminderId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteReminder(dynamic reminderId) async {
    return await dio.delete(TaskEndpoints.reminderDetail(reminderId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getLabels() async {
    return await dio.get(TaskEndpoints.taskLabels, options: Options(responseType: ResponseType.json));
  }

  Future<Response> createLabel(Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.taskLabels, data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateLabel(dynamic labelId, Map<String, dynamic> data) async {
    return await dio.put(TaskEndpoints.taskLabelDetail(labelId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteLabel(dynamic labelId) async {
    return await dio.delete(TaskEndpoints.taskLabelDetail(labelId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTaskAttachments(String activityId) async {
    return await dio.get(TaskEndpoints.taskAttachments(activityId), options: Options(responseType: ResponseType.json));
  }

  MediaType? _getMediaType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (ext == 'jpg' || ext == 'jpeg') {
      return MediaType('image', 'jpeg');
    } else if (ext == 'png') {
      return MediaType('image', 'png');
    } else if (ext == 'webp') {
      return MediaType('image', 'webp');
    } else if (ext == 'gif') {
      return MediaType('image', 'gif');
    } else if (ext == 'pdf') {
      return MediaType('application', 'pdf');
    }
    return null;
  }

  Future<Response> uploadAttachment(String filePath) async {
    final fileName = filePath.split('/').last;
    final mediaType = _getMediaType(fileName);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
    });
    return await dio.post(
      'attachments/upload',
      data: formData,
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> uploadTaskAttachment(String activityId, String filePath) async {
    final fileName = filePath.split('/').last;
    final mediaType = _getMediaType(fileName);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
    });
    return await dio.post(
      TaskEndpoints.taskAttachments(activityId),
      data: formData,
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> deleteAttachment(dynamic attachmentId) async {
    return await dio.delete(
      'attachments/$attachmentId',
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> getTaskComments(String activityId, {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(TaskEndpoints.comments(activityId), queryParameters: queryParameters, options: Options(responseType: ResponseType.json));
  }

  Future<Response> createTaskComment(String activityId, Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.comments(activityId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> updateComment(dynamic commentId, Map<String, dynamic> data) async {
    return await dio.put(TaskEndpoints.commentDetail(commentId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> deleteComment(dynamic commentId) async {
    return await dio.delete(TaskEndpoints.commentDetail(commentId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupMembers(String activityId) async {
    return await dio.get(TaskEndpoints.groupMembers(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> inviteGroupMember(String activityId, Map<String, dynamic> data) async {
    return await dio.post(TaskEndpoints.groupInvite(activityId), data: data, options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupJoinLink(String activityId) async {
    return await dio.get(TaskEndpoints.groupJoinLink(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> createGroupJoinLink(String activityId) async {
    return await dio.post(TaskEndpoints.groupJoinLink(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupJoinRequests(String activityId) async {
    return await dio.get(TaskEndpoints.groupJoinRequests(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> leaveGroup(String activityId) async {
    return await dio.delete(TaskEndpoints.groupLeave(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> removeGroupMember(String activityId, dynamic memberId) async {
    return await dio.delete(TaskEndpoints.groupMemberDetail(activityId, memberId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupPendingInvites(String activityId) async {
    return await dio.get(TaskEndpoints.groupPendingInvites(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getActivityFeed(String activityId, {int page = 0, int size = 20}) async {
    return await dio.get(
      TaskEndpoints.activityFeed(activityId),
      queryParameters: {
        'page': page,
        'size': size,
      },
      options: Options(responseType: ResponseType.json),
    );
  }

  Future<Response> getAuditLogs(String activityId) async {
    return await dio.get(TaskEndpoints.auditLogs(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getGroupAuditLogs(String activityId) async {
    return await dio.get(TaskEndpoints.groupAuditLogs(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getActivityNotifications(String activityId) async {
    return await dio.get(TaskEndpoints.activityNotifications(activityId), options: Options(responseType: ResponseType.json));
  }

  Future<Response> getTaskStatistics() async {
    return await dio.get(TaskEndpoints.taskStatistics, options: Options(responseType: ResponseType.json));
  }
}
