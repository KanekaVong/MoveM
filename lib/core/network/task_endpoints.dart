abstract class TaskEndpoints {
  static const String tasks = 'tasks';
  static String taskDetail(String activityId) => 'tasks/$activityId';
  static String completeTask(String activityId) => 'tasks/$activityId/complete';
  static String restoreTask(String activityId) => 'tasks/$activityId/restore';
  static String permanentDelete(String activityId) => 'activities/$activityId/permanent';
  static String parentTasks(String parentId) => 'activities/$parentId/tasks';

  static String taskChecklists(String activityId) => 'tasks/$activityId/checklists';
  static String updateChecklistItem(dynamic checklistId) => 'tasks/$checklistId/checklists';
  static String deleteChecklistItem(dynamic checklistId) => 'tasks/checklists/$checklistId';
  static String toggleChecklistCompletion(dynamic checklistId) => 'tasks/checklists/$checklistId/complete';

  static String taskReminders(String activityId) => 'tasks/$activityId/reminders';
  static const String upcomingReminders = 'tasks/reminders/upcoming';
  static String reminderDetail(dynamic reminderId) => 'tasks/reminders/$reminderId';

  static String taskAttachments(String activityId) => 'tasks/$activityId/attachments';

  static const String taskLabels = 'task-labels';
  static String taskLabelDetail(dynamic labelId) => 'task-labels/$labelId';

  static String comments(String activityId) => 'comments/$activityId';
  static String commentDetail(dynamic commentId) => 'comments/$commentId';

  static String groupMembers(String activityId) => 'groups/$activityId/members';
  static String groupInvite(String activityId) => 'groups/$activityId/invite';
  static String groupJoinLink(String activityId) => 'groups/$activityId/join-link';
  static String groupJoinRequests(String activityId) => 'groups/$activityId/join-requests';
  static String groupLeave(String activityId) => 'groups/$activityId/leave';
  static String groupMemberDetail(String activityId, dynamic memberId) => 'groups/$activityId/members/$memberId';
  static String groupPendingInvites(String activityId) => 'groups/$activityId/pending-invites';
  static const String myInvitations = 'groups/my-invitations';
  static String acceptGroupInvite(dynamic inviteId) => 'groups/invites/$inviteId/accept';
  static String rejectGroupInvite(dynamic inviteId) => 'groups/invites/$inviteId/reject';

  static String activityFeed(String activityId) => 'activity-feed/$activityId';
  static String auditLogs(String activityId) => 'audit-logs/$activityId';
  static String groupAuditLogs(String activityId) => 'audit-logs/groups/$activityId';
  static String activityNotifications(String activityId) => 'notifications/activity/$activityId';

  static const String taskStatistics = 'statistics/tasks';
}
