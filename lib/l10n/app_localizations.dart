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
  /// **'FRIENDS'**
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
  /// **'DURATION'**
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

  /// No description provided for @createNewTrip.
  ///
  /// In en, this message translates to:
  /// **'Create New Trip'**
  String get createNewTrip;

  /// No description provided for @tripStepName.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get tripStepName;

  /// No description provided for @tripStepLocation.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get tripStepLocation;

  /// No description provided for @tripStepDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get tripStepDuration;

  /// No description provided for @tripStepStops.
  ///
  /// In en, this message translates to:
  /// **'STOPS'**
  String get tripStepStops;

  /// No description provided for @tripStepFriends.
  ///
  /// In en, this message translates to:
  /// **'FRIENDS'**
  String get tripStepFriends;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueButton;

  /// No description provided for @tripNameLabel.
  ///
  /// In en, this message translates to:
  /// **'TRIP NAME'**
  String get tripNameLabel;

  /// No description provided for @tripNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your trip name...'**
  String get tripNameHint;

  /// No description provided for @tripNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your trip name.'**
  String get tripNameRequired;

  /// No description provided for @tripNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s the Trip Called?'**
  String get tripNameTitle;

  /// No description provided for @tripNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give your adventure a name'**
  String get tripNameSubtitle;

  /// No description provided for @tripLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get tripLocationTitle;

  /// No description provided for @tripLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search for a place or tap the map to choose it'**
  String get tripLocationSubtitle;

  /// No description provided for @tripLocationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search destination...'**
  String get tripLocationSearchHint;

  /// No description provided for @tripLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get tripLocationSelected;

  /// No description provided for @tripLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your destination.'**
  String get tripLocationRequired;

  /// No description provided for @tripLocationSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search for locations. Please try again.'**
  String get tripLocationSearchFailed;

  /// No description provided for @tripLocationNotFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found.'**
  String get tripLocationNotFound;

  /// No description provided for @tripLocationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to use your current location.'**
  String get tripLocationPermissionDenied;

  /// No description provided for @tripLocationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Please turn on location services.'**
  String get tripLocationServiceDisabled;

  /// No description provided for @tripLocationSearching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get tripLocationSearching;

  /// No description provided for @tripDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration & Budget'**
  String get tripDurationTitle;

  /// No description provided for @tripDurationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How long and how much?'**
  String get tripDurationSubtitle;

  /// No description provided for @tripDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip Duration'**
  String get tripDurationLabel;

  /// No description provided for @tripDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get tripDaysLabel;

  /// No description provided for @tripSetupDates.
  ///
  /// In en, this message translates to:
  /// **'Set up dates'**
  String get tripSetupDates;

  /// No description provided for @tripDurationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your trip dates.'**
  String get tripDurationRequired;

  /// No description provided for @tripBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Budget'**
  String get tripBudgetTitle;

  /// No description provided for @tripBudgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the budget for your adventure'**
  String get tripBudgetSubtitle;

  /// No description provided for @tripBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get tripBudgetLabel;

  /// No description provided for @tripBudgetHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get tripBudgetHint;

  /// No description provided for @tripStopsTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan your stops'**
  String get tripStopsTitle;

  /// No description provided for @tripStopsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add checkpoints along your route'**
  String get tripStopsSubtitle;

  /// No description provided for @tripAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add a stop'**
  String get tripAddStop;

  /// No description provided for @tripStopsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No stops added yet'**
  String get tripStopsEmpty;

  /// No description provided for @tripUnnamedStop.
  ///
  /// In en, this message translates to:
  /// **'Unnamed stop'**
  String get tripUnnamedStop;

  /// No description provided for @tripStepPacking.
  ///
  /// In en, this message translates to:
  /// **'PACKING'**
  String get tripStepPacking;

  /// No description provided for @tripStepChecklist.
  ///
  /// In en, this message translates to:
  /// **'CHECKLIST'**
  String get tripStepChecklist;

  /// No description provided for @tripFriendsTitle.
  ///
  /// In en, this message translates to:
  /// **'WHO\'S COMING?'**
  String get tripFriendsTitle;

  /// No description provided for @tripFriendsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invite friends to join your trip'**
  String get tripFriendsSubtitle;

  /// No description provided for @tripFriendsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get tripFriendsSearchHint;

  /// No description provided for @tripFriendsInvitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Invited Friends'**
  String get tripFriendsInvitedTitle;

  /// No description provided for @tripFriendsSuggestedTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested Friends'**
  String get tripFriendsSuggestedTitle;

  /// No description provided for @tripFriendsSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get tripFriendsSearchResultsTitle;

  /// No description provided for @tripFriendsNoFriendsFound.
  ///
  /// In en, this message translates to:
  /// **'No friends found'**
  String get tripFriendsNoFriendsFound;

  /// No description provided for @tripYourTrip.
  ///
  /// In en, this message translates to:
  /// **'Your Trip'**
  String get tripYourTrip;

  /// No description provided for @tripLocationFallback.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get tripLocationFallback;

  /// No description provided for @tripDay.
  ///
  /// In en, this message translates to:
  /// **'DAY'**
  String get tripDay;

  /// No description provided for @tripDays.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get tripDays;

  /// No description provided for @tripStop.
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get tripStop;

  /// No description provided for @tripStops.
  ///
  /// In en, this message translates to:
  /// **'STOPS'**
  String get tripStops;

  /// No description provided for @tripPackingTitle.
  ///
  /// In en, this message translates to:
  /// **'NEED HELP WITH WHAT TO PACK?'**
  String get tripPackingTitle;

  /// No description provided for @tripPackingDescription.
  ///
  /// In en, this message translates to:
  /// **'Check what you and your friends need to pack!'**
  String get tripPackingDescription;

  /// No description provided for @tripEssentials.
  ///
  /// In en, this message translates to:
  /// **'Trip Essentials'**
  String get tripEssentials;

  /// No description provided for @packingItemsHint.
  ///
  /// In en, this message translates to:
  /// **'List packing items...'**
  String get packingItemsHint;

  /// No description provided for @tripChecklistTitle.
  ///
  /// In en, this message translates to:
  /// **'TRIP CHECKLIST'**
  String get tripChecklistTitle;

  /// No description provided for @tripChecklistDescription.
  ///
  /// In en, this message translates to:
  /// **'Make sure everything is ready for your trip!'**
  String get tripChecklistDescription;

  /// No description provided for @checklistItemsHint.
  ///
  /// In en, this message translates to:
  /// **'List checklist items...'**
  String get checklistItemsHint;

  /// No description provided for @tripSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Summary'**
  String get tripSummaryTitle;

  /// No description provided for @readyButton.
  ///
  /// In en, this message translates to:
  /// **'READY'**
  String get readyButton;

  /// No description provided for @yourTrip.
  ///
  /// In en, this message translates to:
  /// **'YOUR TRIP'**
  String get yourTrip;

  /// No description provided for @locationNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Location not selected'**
  String get locationNotSelected;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'DESTINATION'**
  String get destination;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'BUDGET'**
  String get budget;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'STOPS'**
  String get stops;

  /// No description provided for @places.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get places;

  /// No description provided for @essentials.
  ///
  /// In en, this message translates to:
  /// **'ESSENTIALS'**
  String get essentials;

  /// No description provided for @itemsToBePacked.
  ///
  /// In en, this message translates to:
  /// **'Items to be packed'**
  String get itemsToBePacked;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'ROUTES'**
  String get routes;

  /// No description provided for @noStopsAdded.
  ///
  /// In en, this message translates to:
  /// **'No stops added'**
  String get noStopsAdded;

  /// No description provided for @unnamedStop.
  ///
  /// In en, this message translates to:
  /// **'Unnamed stop'**
  String get unnamedStop;

  /// No description provided for @editTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Trip'**
  String get editTripTitle;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @editTripName.
  ///
  /// In en, this message translates to:
  /// **'Trip Name'**
  String get editTripName;

  /// No description provided for @editTripDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get editTripDuration;

  /// No description provided for @editTripMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get editTripMembers;

  /// No description provided for @editTripStops.
  ///
  /// In en, this message translates to:
  /// **'STOPS'**
  String get editTripStops;

  /// No description provided for @editTripPacking.
  ///
  /// In en, this message translates to:
  /// **'Packing Items'**
  String get editTripPacking;

  /// No description provided for @editTripChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get editTripChecklist;

  /// No description provided for @editTripAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get editTripAttachments;

  /// No description provided for @editTripStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get editTripStartDate;

  /// No description provided for @editTripEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get editTripEndDate;

  /// No description provided for @editTripSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get editTripSaveChanges;

  /// No description provided for @editTripNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter trip name'**
  String get editTripNameHint;

  /// No description provided for @editTripNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Trip name cannot be empty'**
  String get editTripNameRequired;

  /// No description provided for @editTripNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Trip name updated'**
  String get editTripNameUpdated;

  /// No description provided for @editTripUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get editTripUpdateSuccess;

  /// No description provided for @editTripUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update trip'**
  String get editTripUpdateFailed;

  /// No description provided for @editTripAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get editTripAddItem;

  /// No description provided for @editTripAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get editTripAddMember;

  /// No description provided for @editTripUploadAttachment.
  ///
  /// In en, this message translates to:
  /// **'Upload Attachment'**
  String get editTripUploadAttachment;

  /// No description provided for @editTripNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get editTripNoMembers;

  /// No description provided for @editTripNoAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments yet'**
  String get editTripNoAttachments;

  /// No description provided for @editTripNoPackingItems.
  ///
  /// In en, this message translates to:
  /// **'No packing items yet'**
  String get editTripNoPackingItems;

  /// No description provided for @editTripNoChecklistItems.
  ///
  /// In en, this message translates to:
  /// **'No checklist items yet'**
  String get editTripNoChecklistItems;

  /// No description provided for @editTripReorderStops.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder stops'**
  String get editTripReorderStops;

  /// No description provided for @editTripSectionTripName.
  ///
  /// In en, this message translates to:
  /// **'Trip Name'**
  String get editTripSectionTripName;

  /// No description provided for @editTripSectionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get editTripSectionDuration;

  /// No description provided for @editTripSectionMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get editTripSectionMembers;

  /// No description provided for @editTripSectionStops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get editTripSectionStops;

  /// No description provided for @editTripSectionPacking.
  ///
  /// In en, this message translates to:
  /// **'Packing Items'**
  String get editTripSectionPacking;

  /// No description provided for @editTripSectionChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get editTripSectionChecklist;

  /// No description provided for @editTripSectionAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get editTripSectionAttachments;

  /// No description provided for @editTripSectionBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get editTripSectionBudget;

  /// No description provided for @editTripSectionRoutes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get editTripSectionRoutes;

  /// No description provided for @editTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get editTripDetails;

  /// No description provided for @editTripDatesNotSet.
  ///
  /// In en, this message translates to:
  /// **'Dates not set'**
  String get editTripDatesNotSet;

  /// No description provided for @editTripNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get editTripNotSelected;

  /// No description provided for @editTripDestination.
  ///
  /// In en, this message translates to:
  /// **'DESTINATION'**
  String get editTripDestination;

  /// No description provided for @editTripBudget.
  ///
  /// In en, this message translates to:
  /// **'BUDGET'**
  String get editTripBudget;

  /// No description provided for @editTripFriends.
  ///
  /// In en, this message translates to:
  /// **'FRIENDS'**
  String get editTripFriends;

  /// No description provided for @editTripDurations.
  ///
  /// In en, this message translates to:
  /// **'DURATIONS'**
  String get editTripDurations;

  /// No description provided for @editTripEssentials.
  ///
  /// In en, this message translates to:
  /// **'ESSENTIALS'**
  String get editTripEssentials;

  /// No description provided for @editTripItemsToBePacked.
  ///
  /// In en, this message translates to:
  /// **'Items to be packed'**
  String get editTripItemsToBePacked;

  /// No description provided for @editTripChecklists.
  ///
  /// In en, this message translates to:
  /// **'CHECKLISTS'**
  String get editTripChecklists;

  /// No description provided for @editTripRoutes.
  ///
  /// In en, this message translates to:
  /// **'ROUTES'**
  String get editTripRoutes;

  /// No description provided for @editTripNoStopsAdded.
  ///
  /// In en, this message translates to:
  /// **'No stops added'**
  String get editTripNoStopsAdded;

  /// No description provided for @editTripUnnamedStop.
  ///
  /// In en, this message translates to:
  /// **'Unnamed stop'**
  String get editTripUnnamedStop;

  /// No description provided for @editTripItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get editTripItem;

  /// No description provided for @editTripItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get editTripItems;

  /// No description provided for @editTripToBePrepared.
  ///
  /// In en, this message translates to:
  /// **'to be prepared'**
  String get editTripToBePrepared;
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
