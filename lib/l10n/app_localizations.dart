import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MoveM'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @fitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get fitness;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeUser(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @addFriend.
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK!'**
  String get welcomeBack;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'EMAIL/PHONE NUMBER'**
  String get emailOrPhone;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'USERNAME'**
  String get username;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'FIRST NAME'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'LAST NAME'**
  String get lastName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM PASSWORD'**
  String get confirmPassword;

  /// No description provided for @loginBtn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginBtn;

  /// No description provided for @registerBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerBtn;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccountTitle;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'VERIFY OTP'**
  String get verifyOtpTitle;

  /// No description provided for @otpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP CODE'**
  String get otpCodeLabel;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @verifyBtn.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyBtn;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'RESET PASSWORD'**
  String get resetPasswordTitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get newPassword;

  /// No description provided for @savePasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePasswordBtn;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @greetings.
  ///
  /// In en, this message translates to:
  /// **'Greetings'**
  String get greetings;

  /// No description provided for @stayActiveToday.
  ///
  /// In en, this message translates to:
  /// **'Stay Active Today!'**
  String get stayActiveToday;

  /// No description provided for @todayProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todayProgress;

  /// No description provided for @ongoingTasks.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Tasks'**
  String get ongoingTasks;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @weeklyStats.
  ///
  /// In en, this message translates to:
  /// **'Weekly Stats'**
  String get weeklyStats;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasks;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @addCollaborator.
  ///
  /// In en, this message translates to:
  /// **'Add Collaborator'**
  String get addCollaborator;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'TASK TITLE'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Name your task...'**
  String get taskTitleHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add extra notes...'**
  String get descriptionHint;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'DEADLINE'**
  String get deadlineLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get priorityLabel;

  /// No description provided for @labelsLabel.
  ///
  /// In en, this message translates to:
  /// **'LABELS'**
  String get labelsLabel;

  /// No description provided for @collaboratorsLabel.
  ///
  /// In en, this message translates to:
  /// **'COLLABORATORS'**
  String get collaboratorsLabel;

  /// No description provided for @checklistLabel.
  ///
  /// In en, this message translates to:
  /// **'CHECKLIST'**
  String get checklistLabel;

  /// No description provided for @addChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Add checklist item'**
  String get addChecklistItem;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasks;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @inviteCollaborators.
  ///
  /// In en, this message translates to:
  /// **'Invite Collaborators'**
  String get inviteCollaborators;

  /// No description provided for @searchCollaboratorsHint.
  ///
  /// In en, this message translates to:
  /// **'Search friends by name...'**
  String get searchCollaboratorsHint;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @addFriends.
  ///
  /// In en, this message translates to:
  /// **'Add Friends'**
  String get addFriends;

  /// No description provided for @friendRequests.
  ///
  /// In en, this message translates to:
  /// **'Friend Requests'**
  String get friendRequests;

  /// No description provided for @friendSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Friend Suggestions'**
  String get friendSuggestions;

  /// No description provided for @shareYourProfile.
  ///
  /// In en, this message translates to:
  /// **'Share Your Profile'**
  String get shareYourProfile;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @scanQrCodeSub.
  ///
  /// In en, this message translates to:
  /// **'Scan your friend\'s QR code'**
  String get scanQrCodeSub;

  /// No description provided for @inviteFriendsViaLink.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriendsViaLink;

  /// No description provided for @inviteFriendsViaLinkSub.
  ///
  /// In en, this message translates to:
  /// **'Invite friends via link'**
  String get inviteFriendsViaLinkSub;

  /// No description provided for @myQrCode.
  ///
  /// In en, this message translates to:
  /// **'My QR Code'**
  String get myQrCode;

  /// No description provided for @saveQr.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveQr;

  /// No description provided for @shareQr.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareQr;

  /// No description provided for @qrSavedToast.
  ///
  /// In en, this message translates to:
  /// **'QR code saved'**
  String get qrSavedToast;

  /// No description provided for @scanToConnect.
  ///
  /// In en, this message translates to:
  /// **'Scan to connect with me on MoveM'**
  String get scanToConnect;

  /// No description provided for @cameraStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting Camera...'**
  String get cameraStarting;

  /// No description provided for @alignQrHint.
  ///
  /// In en, this message translates to:
  /// **'Align QR code inside the frame to scan'**
  String get alignQrHint;

  /// No description provided for @userFound.
  ///
  /// In en, this message translates to:
  /// **'User Found'**
  String get userFound;

  /// No description provided for @movemClub.
  ///
  /// In en, this message translates to:
  /// **'MoveM Club'**
  String get movemClub;

  /// No description provided for @soloChallenges.
  ///
  /// In en, this message translates to:
  /// **'Solo Challenges'**
  String get soloChallenges;

  /// No description provided for @groupActivity.
  ///
  /// In en, this message translates to:
  /// **'Group Activity'**
  String get groupActivity;

  /// No description provided for @yourGoal.
  ///
  /// In en, this message translates to:
  /// **'Your Goal'**
  String get yourGoal;

  /// No description provided for @liveTracking.
  ///
  /// In en, this message translates to:
  /// **'Live Tracking'**
  String get liveTracking;

  /// No description provided for @runSummary.
  ///
  /// In en, this message translates to:
  /// **'Run Summary'**
  String get runSummary;

  /// No description provided for @runHistory.
  ///
  /// In en, this message translates to:
  /// **'Run History'**
  String get runHistory;

  /// No description provided for @runDetails.
  ///
  /// In en, this message translates to:
  /// **'Run Details'**
  String get runDetails;

  /// No description provided for @pushUpWorkout.
  ///
  /// In en, this message translates to:
  /// **'Push Up Workout'**
  String get pushUpWorkout;

  /// No description provided for @workoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Workout Details'**
  String get workoutDetails;

  /// No description provided for @createActivity.
  ///
  /// In en, this message translates to:
  /// **'Create Activity'**
  String get createActivity;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @invitePeople.
  ///
  /// In en, this message translates to:
  /// **'Invite people'**
  String get invitePeople;

  /// No description provided for @setupGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal & Focus'**
  String get setupGoal;

  /// No description provided for @activityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY NAME'**
  String get activityNameLabel;

  /// No description provided for @groupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'GROUP NAME'**
  String get groupNameLabel;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'Distance (km)'**
  String get distanceKm;

  /// No description provided for @avgPace.
  ///
  /// In en, this message translates to:
  /// **'Avg Pace'**
  String get avgPace;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @caloriesBurned.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get caloriesBurned;

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'SET'**
  String get setLabel;

  /// No description provided for @repsLabel.
  ///
  /// In en, this message translates to:
  /// **'REPS'**
  String get repsLabel;

  /// No description provided for @tapToCount.
  ///
  /// In en, this message translates to:
  /// **'Tap screen to count rep'**
  String get tapToCount;

  /// No description provided for @greatJobWorkout.
  ///
  /// In en, this message translates to:
  /// **'Great job! Workout completed'**
  String get greatJobWorkout;

  /// No description provided for @tripsMap.
  ///
  /// In en, this message translates to:
  /// **'Trips Map'**
  String get tripsMap;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @sessionsSection.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsSection;

  /// No description provided for @yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get yourProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @appearances.
  ///
  /// In en, this message translates to:
  /// **'Appearances'**
  String get appearances;

  /// No description provided for @darkLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark/Light'**
  String get darkLightTheme;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Your Account'**
  String get deleteAccount;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @myActivities.
  ///
  /// In en, this message translates to:
  /// **'My Activities'**
  String get myActivities;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English (English)'**
  String get languageEnglish;

  /// No description provided for @languageKhmer.
  ///
  /// In en, this message translates to:
  /// **'ភាសាខ្មែរ (Khmer)'**
  String get languageKhmer;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @yourInviteLink.
  ///
  /// In en, this message translates to:
  /// **'YOUR INVITE LINK'**
  String get yourInviteLink;

  /// No description provided for @yourToken.
  ///
  /// In en, this message translates to:
  /// **'YOUR TOKEN'**
  String get yourToken;

  /// No description provided for @shareVia.
  ///
  /// In en, this message translates to:
  /// **'SHARE VIA'**
  String get shareVia;

  /// No description provided for @inviteLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied to clipboard'**
  String get inviteLinkCopied;

  /// No description provided for @inviteTokenCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite token copied to clipboard'**
  String get inviteTokenCopied;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit Comment'**
  String get editComment;

  /// No description provided for @editingComment.
  ///
  /// In en, this message translates to:
  /// **'Editing Comment'**
  String get editingComment;

  /// No description provided for @editYourComment.
  ///
  /// In en, this message translates to:
  /// **'Edit your comment...'**
  String get editYourComment;

  /// No description provided for @deleteComment.
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get deleteComment;

  /// No description provided for @deleteCommentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment? This action cannot be undone.'**
  String get deleteCommentConfirm;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyText;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @beTheFirstToComment.
  ///
  /// In en, this message translates to:
  /// **'Be the first to leave a comment or ask a question about this task.'**
  String get beTheFirstToComment;

  /// No description provided for @commentCopiedToast.
  ///
  /// In en, this message translates to:
  /// **'Comment copied to clipboard'**
  String get commentCopiedToast;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get edited;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task? This action cannot be undone.'**
  String get deleteTaskConfirm;

  /// No description provided for @taskDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task deleted successfully'**
  String get taskDeletedSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
