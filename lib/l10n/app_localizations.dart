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

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get didntGetCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {time}'**
  String resendCodeIn(String time);

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

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME BACK'**
  String get welcomeBackTitle;

  /// No description provided for @emailPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Email/Phone Number'**
  String get emailPhoneHint;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @setUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Set Username'**
  String get setUsernameHint;

  /// No description provided for @enterPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPasswordHint;

  /// No description provided for @setPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPasswordHint;

  /// No description provided for @retypePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'RE-TYPE PASSWORD'**
  String get retypePasswordLabel;

  /// No description provided for @retypePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-Type Password'**
  String get retypePasswordHint;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginAction;

  /// No description provided for @noAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t have an account yet? Sign Up'**
  String get noAccountSignUp;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get haveAccountSignIn;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @otpCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get otpCodeHint;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to\n{identifier}'**
  String otpSentTo(String identifier);

  /// No description provided for @verifyAction.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyAction;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @savePasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get savePasswordAction;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get fillAllFields;

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
  /// **'Enter description'**
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

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

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
  /// **'Budget'**
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

  /// No description provided for @createClub.
  ///
  /// In en, this message translates to:
  /// **'Create Club'**
  String get createClub;

  /// No description provided for @clubNameLabel.
  ///
  /// In en, this message translates to:
  /// **'CLUB NAME'**
  String get clubNameLabel;

  /// No description provided for @clubNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter club name'**
  String get clubNameHint;

  /// No description provided for @clubDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'CLUB DESCRIPTION'**
  String get clubDescriptionLabel;

  /// No description provided for @searchForClub.
  ///
  /// In en, this message translates to:
  /// **'Search for Club'**
  String get searchForClub;

  /// No description provided for @clubInvitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get clubInvitations;

  /// No description provided for @clubMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get clubMembers;

  /// No description provided for @clubOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get clubOverview;

  /// No description provided for @exploreClubs.
  ///
  /// In en, this message translates to:
  /// **'Explore Clubs'**
  String get exploreClubs;

  /// No description provided for @publicLabel.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicLabel;

  /// No description provided for @privateLabel.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateLabel;

  /// No description provided for @selectPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Select Privacy'**
  String get selectPrivacy;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @pleaseEnterClubName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a club name'**
  String get pleaseEnterClubName;

  /// No description provided for @myFriends.
  ///
  /// In en, this message translates to:
  /// **'My Friends'**
  String get myFriends;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @suggestionsTab.
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestionsTab;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get noFriendsYet;

  /// No description provided for @noFriendsYetSub.
  ///
  /// In en, this message translates to:
  /// **'People you add will appear here.'**
  String get noFriendsYetSub;

  /// No description provided for @noFriendRequests.
  ///
  /// In en, this message translates to:
  /// **'No friend requests'**
  String get noFriendRequests;

  /// No description provided for @noFriendRequestsSub.
  ///
  /// In en, this message translates to:
  /// **'When someone sends you a request, it will show up here.'**
  String get noFriendRequestsSub;

  /// No description provided for @noRequestsSent.
  ///
  /// In en, this message translates to:
  /// **'No requests sent'**
  String get noRequestsSent;

  /// No description provided for @noRequestsSentSub.
  ///
  /// In en, this message translates to:
  /// **'Friend requests you send will appear here.'**
  String get noRequestsSentSub;

  /// No description provided for @noSuggestionsFound.
  ///
  /// In en, this message translates to:
  /// **'No suggestions found'**
  String get noSuggestionsFound;

  /// No description provided for @noSuggestionsFoundSub.
  ///
  /// In en, this message translates to:
  /// **'We do not have anyone to suggest right now.'**
  String get noSuggestionsFoundSub;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @nothingMatchesSearch.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches your search.'**
  String get nothingMatchesSearch;

  /// No description provided for @workoutChallenge.
  ///
  /// In en, this message translates to:
  /// **'Workout Challenge'**
  String get workoutChallenge;

  /// No description provided for @filterChallenges.
  ///
  /// In en, this message translates to:
  /// **'Filter Challenges'**
  String get filterChallenges;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @noChallengesFound.
  ///
  /// In en, this message translates to:
  /// **'No challenges found'**
  String get noChallengesFound;

  /// No description provided for @workoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Workout History'**
  String get workoutHistory;

  /// No description provided for @noWorkoutsYet.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get noWorkoutsYet;

  /// No description provided for @noWorkoutsYetSub.
  ///
  /// In en, this message translates to:
  /// **'Finish a run or workout to see it here.'**
  String get noWorkoutsYetSub;

  /// No description provided for @noWorkoutSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No workout sessions yet'**
  String get noWorkoutSessionsYet;

  /// No description provided for @noWorkoutSessionsYetSub.
  ///
  /// In en, this message translates to:
  /// **'Complete a run or push-up workout to see it here!'**
  String get noWorkoutSessionsYetSub;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @challengeAction.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get challengeAction;

  /// No description provided for @fitnessClubAction.
  ///
  /// In en, this message translates to:
  /// **'Fitness Club'**
  String get fitnessClubAction;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivityYet;

  /// No description provided for @noActivityYetSub.
  ///
  /// In en, this message translates to:
  /// **'Updates for this task will appear here.'**
  String get noActivityYetSub;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'When something happens, you will see it here.'**
  String get noNotificationsSub;

  /// No description provided for @endWorkout.
  ///
  /// In en, this message translates to:
  /// **'End Workout?'**
  String get endWorkout;

  /// No description provided for @endWorkoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be saved.'**
  String get endWorkoutConfirm;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get keepGoing;

  /// No description provided for @exitRun.
  ///
  /// In en, this message translates to:
  /// **'Exit Run?'**
  String get exitRun;

  /// No description provided for @exitRunConfirm.
  ///
  /// In en, this message translates to:
  /// **'Your run progress will be saved.'**
  String get exitRunConfirm;

  /// No description provided for @unfriend.
  ///
  /// In en, this message translates to:
  /// **'Unfriend'**
  String get unfriend;

  /// No description provided for @newsFeed.
  ///
  /// In en, this message translates to:
  /// **'News Feed'**
  String get newsFeed;

  /// No description provided for @feedEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Workouts and updates from your circle will show up here.'**
  String get feedEmptySub;

  /// No description provided for @writeAComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get writeAComment;

  /// No description provided for @joinClub.
  ///
  /// In en, this message translates to:
  /// **'Join Club'**
  String get joinClub;

  /// No description provided for @createClubSub.
  ///
  /// In en, this message translates to:
  /// **'Create Your Own Community, Socialize with us'**
  String get createClubSub;

  /// No description provided for @noClubsFound.
  ///
  /// In en, this message translates to:
  /// **'No clubs found'**
  String get noClubsFound;

  /// No description provided for @noClubsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No clubs yet'**
  String get noClubsAvailable;

  /// No description provided for @noClubsAvailableSub.
  ///
  /// In en, this message translates to:
  /// **'Create a club or look around to find friends to train with.'**
  String get noClubsAvailableSub;

  /// No description provided for @discoverClubs.
  ///
  /// In en, this message translates to:
  /// **'Discover Clubs'**
  String get discoverClubs;

  /// No description provided for @beFirstClub.
  ///
  /// In en, this message translates to:
  /// **'Be the first to start a club!'**
  String get beFirstClub;

  /// No description provided for @haventJoinedClubsSub.
  ///
  /// In en, this message translates to:
  /// **'Join a club or start your own to train together.'**
  String get haventJoinedClubsSub;

  /// No description provided for @noClubInvitations.
  ///
  /// In en, this message translates to:
  /// **'No club invitations'**
  String get noClubInvitations;

  /// No description provided for @noClubInvitationsSub.
  ///
  /// In en, this message translates to:
  /// **'Invites to join a club will show up here.'**
  String get noClubInvitationsSub;

  /// No description provided for @noJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'No join requests'**
  String get noJoinRequests;

  /// No description provided for @noJoinRequestsSub.
  ///
  /// In en, this message translates to:
  /// **'When someone asks to join your club, you\'ll see it here.'**
  String get noJoinRequestsSub;

  /// No description provided for @noMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get noMembersYet;

  /// No description provided for @inviteToGrowClub.
  ///
  /// In en, this message translates to:
  /// **'Invite friends to grow this club.'**
  String get inviteToGrowClub;

  /// No description provided for @noCompletedChallenges.
  ///
  /// In en, this message translates to:
  /// **'No finished challenges yet'**
  String get noCompletedChallenges;

  /// No description provided for @createChallenge.
  ///
  /// In en, this message translates to:
  /// **'Create Challenge'**
  String get createChallenge;

  /// No description provided for @pleaseEnterChallengeName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a challenge name.'**
  String get pleaseEnterChallengeName;

  /// No description provided for @endDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after the start date.'**
  String get endDateAfterStart;

  /// No description provided for @achievementsBadges.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsBadges;

  /// No description provided for @noAchievementsFound.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet'**
  String get noAchievementsFound;

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'No Achievements Yet'**
  String get noAchievementsYet;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @noMutuals.
  ///
  /// In en, this message translates to:
  /// **'No mutual friends'**
  String get noMutuals;

  /// No description provided for @invitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation'**
  String get invitation;

  /// No description provided for @invitationsLabel.
  ///
  /// In en, this message translates to:
  /// **'INVITATIONS'**
  String get invitationsLabel;

  /// No description provided for @noInvitations.
  ///
  /// In en, this message translates to:
  /// **'No invitations'**
  String get noInvitations;

  /// No description provided for @noInvitationsSub.
  ///
  /// In en, this message translates to:
  /// **'Task invitations you receive will show up here.'**
  String get noInvitationsSub;

  /// No description provided for @noFriendsFoundInvite.
  ///
  /// In en, this message translates to:
  /// **'No friends found'**
  String get noFriendsFoundInvite;

  /// No description provided for @addFriendsThenInvite.
  ///
  /// In en, this message translates to:
  /// **'Add friends first, then invite them to this club.'**
  String get addFriendsThenInvite;

  /// No description provided for @createButton.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createButton;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get success;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops'**
  String get errorTitle;

  /// No description provided for @taskTitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please name your task.'**
  String get taskTitleEmpty;

  /// No description provided for @taskCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task created!'**
  String get taskCreatedSuccess;

  /// No description provided for @taskUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task updated!'**
  String get taskUpdatedSuccess;

  /// No description provided for @labelCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Label created!'**
  String get labelCreatedSuccess;

  /// No description provided for @cannotEditAfterDeadline.
  ///
  /// In en, this message translates to:
  /// **'This task can\'t be changed after the deadline.'**
  String get cannotEditAfterDeadline;

  /// No description provided for @noLabelsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No labels yet.'**
  String get noLabelsAvailable;

  /// No description provided for @taskMarkedComplete.
  ///
  /// In en, this message translates to:
  /// **'Nice! Task marked complete.'**
  String get taskMarkedComplete;

  /// No description provided for @pleaseEnterHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your height.'**
  String get pleaseEnterHeight;

  /// No description provided for @pleaseEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter your weight.'**
  String get pleaseEnterWeight;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile saved.'**
  String get profileUpdated;

  /// No description provided for @enterHeightRange.
  ///
  /// In en, this message translates to:
  /// **'Enter height in cm (50–300).'**
  String get enterHeightRange;

  /// No description provided for @enterWeightRange.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg (20–500).'**
  String get enterWeightRange;

  /// No description provided for @swipeToStart.
  ///
  /// In en, this message translates to:
  /// **'Swipe to start'**
  String get swipeToStart;

  /// No description provided for @mainGoalQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your main goal?'**
  String get mainGoalQuestion;

  /// No description provided for @targetWeightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your target weight?'**
  String get targetWeightQuestion;

  /// No description provided for @targetDateQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your target date?'**
  String get targetDateQuestion;

  /// No description provided for @workoutLevelQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which workout level feels right?'**
  String get workoutLevelQuestion;

  /// No description provided for @fitnessAssessment.
  ///
  /// In en, this message translates to:
  /// **'Fitness check'**
  String get fitnessAssessment;

  /// No description provided for @pleaseSelectMainGoal.
  ///
  /// In en, this message translates to:
  /// **'Please pick a main goal.'**
  String get pleaseSelectMainGoal;

  /// No description provided for @pleaseEnterTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a target weight.'**
  String get pleaseEnterTargetWeight;

  /// No description provided for @pleaseSelectFutureDate.
  ///
  /// In en, this message translates to:
  /// **'Please pick a future date.'**
  String get pleaseSelectFutureDate;

  /// No description provided for @pleaseSelectWorkoutLevel.
  ///
  /// In en, this message translates to:
  /// **'Please pick a workout level.'**
  String get pleaseSelectWorkoutLevel;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'We need location to track your run.'**
  String get locationRequired;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Please turn on location services.'**
  String get enableLocation;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'Already in this task.'**
  String get alreadyMember;

  /// No description provided for @alreadyInvited.
  ///
  /// In en, this message translates to:
  /// **'Already invited.'**
  String get alreadyInvited;

  /// No description provided for @noSoloChallenges.
  ///
  /// In en, this message translates to:
  /// **'No solo challenges right now'**
  String get noSoloChallenges;

  /// No description provided for @anyoneCanJoin.
  ///
  /// In en, this message translates to:
  /// **'Anyone can find and join this club'**
  String get anyoneCanJoin;

  /// No description provided for @requiresInvite.
  ///
  /// In en, this message translates to:
  /// **'Needs an invite to join'**
  String get requiresInvite;

  /// No description provided for @searchClubsHint.
  ///
  /// In en, this message translates to:
  /// **'Search clubs by name...'**
  String get searchClubsHint;

  /// No description provided for @movemClubs.
  ///
  /// In en, this message translates to:
  /// **'MoveM Clubs'**
  String get movemClubs;

  /// No description provided for @clubInvitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Club Invitations'**
  String get clubInvitationsTitle;

  /// No description provided for @noClubChallenges.
  ///
  /// In en, this message translates to:
  /// **'No club challenges yet'**
  String get noClubChallenges;

  /// No description provided for @createOneToStart.
  ///
  /// In en, this message translates to:
  /// **'Create one to get started.'**
  String get createOneToStart;

  /// No description provided for @noMembersJoined.
  ///
  /// In en, this message translates to:
  /// **'No members have joined yet'**
  String get noMembersJoined;

  /// No description provided for @endSessionBody.
  ///
  /// In en, this message translates to:
  /// **'Want to stop and see your summary?'**
  String get endSessionBody;

  /// No description provided for @exitRunBody.
  ///
  /// In en, this message translates to:
  /// **'Your run will be paused. Leave now?'**
  String get exitRunBody;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @lbsUnit.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbsUnit;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @requestJoin.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestJoin;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @joinedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re in!'**
  String get joinedTitle;

  /// No description provided for @requestSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSentTitle;

  /// No description provided for @savedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedTitle;

  /// No description provided for @removedTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get removedTitle;

  /// No description provided for @clubCreatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Club \"{name}\" is ready!'**
  String clubCreatedMsg(String name);

  /// No description provided for @challengeCreatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Challenge \"{name}\" is ready!'**
  String challengeCreatedMsg(String name);

  /// No description provided for @joinedClubMsg.
  ///
  /// In en, this message translates to:
  /// **'You\'re now in {name}'**
  String joinedClubMsg(String name);

  /// No description provided for @joinRequestSentMsg.
  ///
  /// In en, this message translates to:
  /// **'Your request to join {name} is waiting.'**
  String joinRequestSentMsg(String name);

  /// No description provided for @failedToCreateClub.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the club. Try again.'**
  String get failedToCreateClub;

  /// No description provided for @failedToJoinClub.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join the club. Try again.'**
  String get failedToJoinClub;

  /// No description provided for @failedToSubmitJoinRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send the join request. Try again.'**
  String get failedToSubmitJoinRequest;

  /// No description provided for @failedToCreateChallenge.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the challenge. Try again.'**
  String get failedToCreateChallenge;

  /// No description provided for @failedToRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t remove this member.'**
  String get failedToRemoveMember;

  /// No description provided for @couldNotApproveRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t approve that request.'**
  String get couldNotApproveRequest;

  /// No description provided for @couldNotRejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reject that request.'**
  String get couldNotRejectRequest;

  /// No description provided for @couldNotCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel that request.'**
  String get couldNotCancelRequest;

  /// No description provided for @enterTargetInUnit.
  ///
  /// In en, this message translates to:
  /// **'Enter a target in {unit}.'**
  String enterTargetInUnit(String unit);

  /// No description provided for @loadingChallenges.
  ///
  /// In en, this message translates to:
  /// **'Loading challenges...'**
  String get loadingChallenges;

  /// Number of trip members
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String membersCount(int count);

  /// No description provided for @completedChallengesLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed challenges'**
  String get completedChallengesLabel;

  /// No description provided for @viewAllArrow.
  ///
  /// In en, this message translates to:
  /// **'View all >>'**
  String get viewAllArrow;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @challengeNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge name'**
  String get challengeNameTitle;

  /// No description provided for @datesTitle.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get datesTitle;

  /// No description provided for @targetTitle.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get targetTitle;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Try again.'**
  String get failedToSaveProfile;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update your profile. Try again.'**
  String get failedToUpdateProfile;

  /// No description provided for @invalidHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid height in cm (for example 170).'**
  String get invalidHeight;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight in kg (for example 65).'**
  String get invalidWeight;

  /// No description provided for @goalSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your goal is saved!'**
  String get goalSetSuccess;

  /// No description provided for @failedToSetGoal.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t set your goal. Try again.'**
  String get failedToSetGoal;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission needed'**
  String get permissionDeniedTitle;

  /// No description provided for @serviceDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'Location is off'**
  String get serviceDisabledTitle;

  /// No description provided for @noTaskData.
  ///
  /// In en, this message translates to:
  /// **'No task data found.'**
  String get noTaskData;

  /// No description provided for @updateFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update'**
  String get updateFailedTitle;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get unexpectedError;

  /// No description provided for @copiedProfileLink.
  ///
  /// In en, this message translates to:
  /// **'Profile link copied'**
  String get copiedProfileLink;

  /// No description provided for @unableToCancelFriendRequest.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t cancel that request. Try later.'**
  String get unableToCancelFriendRequest;

  /// No description provided for @failedToSendComment.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t post that comment right now.'**
  String get failedToSendComment;

  /// No description provided for @alreadyMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Already a member'**
  String get alreadyMemberTitle;

  /// No description provided for @alreadyInvitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Already invited'**
  String get alreadyInvitedTitle;

  /// No description provided for @membersAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} added to {name}.'**
  String membersAdded(int count, String name);

  /// No description provided for @couldNotAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add members. Try again.'**
  String get couldNotAddMembers;

  /// No description provided for @removeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from {club}?'**
  String removeMemberConfirm(String name, String club);

  /// No description provided for @thisMember.
  ///
  /// In en, this message translates to:
  /// **'this member'**
  String get thisMember;

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} was removed from {club}.'**
  String memberRemoved(String name, String club);

  /// No description provided for @youJoinedChallenge.
  ///
  /// In en, this message translates to:
  /// **'You\'re in {name}.'**
  String youJoinedChallenge(String name);

  /// No description provided for @failedToJoinChallenge.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join this challenge.'**
  String get failedToJoinChallenge;

  /// No description provided for @membersJoinedLabel.
  ///
  /// In en, this message translates to:
  /// **'Members joined'**
  String get membersJoinedLabel;

  /// No description provided for @addFriendsForTask.
  ///
  /// In en, this message translates to:
  /// **'Add friends so you can invite them to this task.'**
  String get addFriendsForTask;

  /// No description provided for @loseWeightGoal.
  ///
  /// In en, this message translates to:
  /// **'Lose weight'**
  String get loseWeightGoal;

  /// No description provided for @buildMuscleGoal.
  ///
  /// In en, this message translates to:
  /// **'Build muscle'**
  String get buildMuscleGoal;

  /// No description provided for @keepFitGoal.
  ///
  /// In en, this message translates to:
  /// **'Keep fit'**
  String get keepFitGoal;

  /// No description provided for @noviceLevel.
  ///
  /// In en, this message translates to:
  /// **'Just starting'**
  String get noviceLevel;

  /// No description provided for @noviceLevelSub.
  ///
  /// In en, this message translates to:
  /// **'Small steps, big changes. Perfect if you\'re new to fitness.'**
  String get noviceLevelSub;

  /// No description provided for @intermediateLevel.
  ///
  /// In en, this message translates to:
  /// **'A little experience'**
  String get intermediateLevel;

  /// No description provided for @intermediateLevelSub.
  ///
  /// In en, this message translates to:
  /// **'You know the basics. Great if you exercise now and then.'**
  String get intermediateLevelSub;

  /// No description provided for @advancedLevel.
  ///
  /// In en, this message translates to:
  /// **'Fitness fan'**
  String get advancedLevel;

  /// No description provided for @advancedLevelSub.
  ///
  /// In en, this message translates to:
  /// **'Push yourself. For people who train often.'**
  String get advancedLevelSub;

  /// No description provided for @requestsLabel.
  ///
  /// In en, this message translates to:
  /// **'REQUESTS'**
  String get requestsLabel;

  /// No description provided for @youRequestedJoin.
  ///
  /// In en, this message translates to:
  /// **'You asked to join {name}'**
  String youRequestedJoin(String name);

  /// No description provided for @aClub.
  ///
  /// In en, this message translates to:
  /// **'a club'**
  String get aClub;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// No description provided for @createTaskToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a task to get started.'**
  String get createTaskToStart;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'HISTORY'**
  String get history;

  /// No description provided for @profileAndGoal.
  ///
  /// In en, this message translates to:
  /// **'PROFILE & GOAL'**
  String get profileAndGoal;

  /// No description provided for @editFitnessProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Fitness Profile >>'**
  String get editFitnessProfile;

  /// No description provided for @editFitnessGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Fitness Goal >>'**
  String get editFitnessGoal;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @currentHeight.
  ///
  /// In en, this message translates to:
  /// **'Current Height'**
  String get currentHeight;

  /// No description provided for @fitnessLevel.
  ///
  /// In en, this message translates to:
  /// **'Fitness Level'**
  String get fitnessLevel;

  /// No description provided for @targetDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Date'**
  String get targetDateLabel;

  /// No description provided for @targetWeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Weight'**
  String get targetWeightLabel;

  /// No description provided for @noneValue.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneValue;

  /// No description provided for @notClubMember.
  ///
  /// In en, this message translates to:
  /// **'Join this club first to create a challenge.'**
  String get notClubMember;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @notSetUp.
  ///
  /// In en, this message translates to:
  /// **'Not Set Up'**
  String get notSetUp;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task Completed'**
  String get taskCompleted;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @daysUntilYourTrip.
  ///
  /// In en, this message translates to:
  /// **'Days Until Your Trip'**
  String get daysUntilYourTrip;

  /// No description provided for @tasksStat.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksStat;

  /// No description provided for @workoutsStat.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workoutsStat;

  /// No description provided for @tripsStat.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripsStat;

  /// No description provided for @badgesStat.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgesStat;

  /// No description provided for @unlinkPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlink phone number?'**
  String get unlinkPhoneTitle;

  /// No description provided for @unlinkPhoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink your phone number from your account?'**
  String get unlinkPhoneConfirm;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlink;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select Date Of Birth'**
  String get selectDateOfBirth;

  /// No description provided for @selectRegion.
  ///
  /// In en, this message translates to:
  /// **'Select Region'**
  String get selectRegion;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @congratulationOnYour.
  ///
  /// In en, this message translates to:
  /// **'CONGRATULATION ON YOUR'**
  String get congratulationOnYour;

  /// No description provided for @first10Kilometers.
  ///
  /// In en, this message translates to:
  /// **'FIRST 10 KILOMETERS!'**
  String get first10Kilometers;

  /// No description provided for @firstWorkout.
  ///
  /// In en, this message translates to:
  /// **'FIRST WORKOUT!'**
  String get firstWorkout;

  /// No description provided for @newAchievement.
  ///
  /// In en, this message translates to:
  /// **'NEW ACHIEVEMENT!'**
  String get newAchievement;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'AWESOME!!!'**
  String get awesome;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// No description provided for @tripMembers.
  ///
  /// In en, this message translates to:
  /// **'Trip Members'**
  String get tripMembers;

  /// No description provided for @pendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'Pending Invitations'**
  String get pendingInvitations;

  /// No description provided for @noPendingInvitations.
  ///
  /// In en, this message translates to:
  /// **'No pending invitations'**
  String get noPendingInvitations;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inviteFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite Friend'**
  String get inviteFriend;

  /// No description provided for @searchFriends.
  ///
  /// In en, this message translates to:
  /// **'Search friends'**
  String get searchFriends;

  /// No description provided for @searchFriendsHint.
  ///
  /// In en, this message translates to:
  /// **'Search by username or email'**
  String get searchFriendsHint;

  /// No description provided for @searchToFindFriends.
  ///
  /// In en, this message translates to:
  /// **'Search to find friends'**
  String get searchToFindFriends;

  /// No description provided for @invitationPending.
  ///
  /// In en, this message translates to:
  /// **'Invitation Pending'**
  String get invitationPending;

  /// No description provided for @invitationSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent successfully'**
  String get invitationSent;

  /// No description provided for @failedToSendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Failed to send invitation'**
  String get failedToSendInvitation;

  /// No description provided for @tripInvitations.
  ///
  /// In en, this message translates to:
  /// **'Trip Invitations'**
  String get tripInvitations;

  /// No description provided for @noTripInvitations.
  ///
  /// In en, this message translates to:
  /// **'No trip invitations'**
  String get noTripInvitations;

  /// No description provided for @invitedYouToTrip.
  ///
  /// In en, this message translates to:
  /// **'invited you to a trip'**
  String get invitedYouToTrip;

  /// No description provided for @invitationAccepted.
  ///
  /// In en, this message translates to:
  /// **'Invitation accepted'**
  String get invitationAccepted;

  /// No description provided for @tripAddedToYourTrips.
  ///
  /// In en, this message translates to:
  /// **'The trip has been added to your trips.'**
  String get tripAddedToYourTrips;

  /// No description provided for @invitationRejected.
  ///
  /// In en, this message translates to:
  /// **'Invitation rejected'**
  String get invitationRejected;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @tapToEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Tap to enter amount'**
  String get tapToEnterAmount;

  /// No description provided for @tripExpenses.
  ///
  /// In en, this message translates to:
  /// **'Trip Expenses'**
  String get tripExpenses;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BUDGET'**
  String get totalBudget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'SPENT'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'REMAINING'**
  String get remaining;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'CATEGORIES'**
  String get categories;

  /// No description provided for @addExpenseBudget.
  ///
  /// In en, this message translates to:
  /// **'ADD EXPENSE / BUDGET'**
  String get addExpenseBudget;

  /// No description provided for @foodsAndDrinks.
  ///
  /// In en, this message translates to:
  /// **'Foods & Drinks'**
  String get foodsAndDrinks;

  /// No description provided for @accommodations.
  ///
  /// In en, this message translates to:
  /// **'Accommodations'**
  String get accommodations;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'{amount} • Paid by {payerName}'**
  String paidBy(Object amount, Object payerName);

  /// No description provided for @trackAllYourExpenses.
  ///
  /// In en, this message translates to:
  /// **'Track All Your Expenses'**
  String get trackAllYourExpenses;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @filterExpenses.
  ///
  /// In en, this message translates to:
  /// **'Filter Expenses'**
  String get filterExpenses;

  /// No description provided for @splitBills.
  ///
  /// In en, this message translates to:
  /// **'Split Bills'**
  String get splitBills;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get noExpensesYet;

  /// No description provided for @expensesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your trip expenses will appear here.'**
  String get expensesWillAppearHere;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense?'**
  String get deleteExpense;

  /// No description provided for @deleteExpenseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{description}\"?'**
  String deleteExpenseConfirmation(Object description);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @allocatedAmount.
  ///
  /// In en, this message translates to:
  /// **'Allocated Amount'**
  String get allocatedAmount;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit {category}'**
  String editCategory(Object category);

  /// No description provided for @addDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Add Descriptions'**
  String get addDescriptions;

  /// No description provided for @descriptionDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Write more details on this expense so your friends know what they\'re for.'**
  String get descriptionDetailsHint;

  /// No description provided for @expensePaidBy.
  ///
  /// In en, this message translates to:
  /// **'{amount} is paid by {payerName}'**
  String expensePaidBy(Object amount, Object payerName);

  /// No description provided for @splitBetween.
  ///
  /// In en, this message translates to:
  /// **'Split Between'**
  String get splitBetween;

  /// No description provided for @amountOwed.
  ///
  /// In en, this message translates to:
  /// **'Amount Owed'**
  String get amountOwed;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @unsettled.
  ///
  /// In en, this message translates to:
  /// **'Unsettled'**
  String get unsettled;

  /// No description provided for @noSplitInformation.
  ///
  /// In en, this message translates to:
  /// **'No split information available.'**
  String get noSplitInformation;

  /// No description provided for @splitBillsWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Split Bills With Your Friends!'**
  String get splitBillsWithFriends;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Expense Amount'**
  String get expenseAmount;

  /// No description provided for @splitType.
  ///
  /// In en, this message translates to:
  /// **'Split Type'**
  String get splitType;

  /// No description provided for @equal.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get equal;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @splitAmount.
  ///
  /// In en, this message translates to:
  /// **'Split Amount'**
  String get splitAmount;

  /// No description provided for @createSplitBill.
  ///
  /// In en, this message translates to:
  /// **'CREATE SPLIT BILL'**
  String get createSplitBill;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @splitBillComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Split bill creation will be available soon.'**
  String get splitBillComingSoon;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Total amount spent on a trip
  ///
  /// In en, this message translates to:
  /// **'Total Spent: {amount}\$'**
  String totalSpent(Object amount);

  /// No description provided for @addTripCover.
  ///
  /// In en, this message translates to:
  /// **'Add Trip Cover'**
  String get addTripCover;

  /// No description provided for @changeTripCover.
  ///
  /// In en, this message translates to:
  /// **'Change Trip Cover'**
  String get changeTripCover;

  /// No description provided for @addTripCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Add trip cover image'**
  String get addTripCoverImage;

  /// No description provided for @changeCurrentImage.
  ///
  /// In en, this message translates to:
  /// **'Change current image'**
  String get changeCurrentImage;

  /// No description provided for @recentTrips.
  ///
  /// In en, this message translates to:
  /// **'Recent Trips'**
  String get recentTrips;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @newestDate.
  ///
  /// In en, this message translates to:
  /// **'Newest Date'**
  String get newestDate;

  /// No description provided for @oldestDate.
  ///
  /// In en, this message translates to:
  /// **'Oldest Date'**
  String get oldestDate;

  /// No description provided for @highestSpent.
  ///
  /// In en, this message translates to:
  /// **'Highest Spent'**
  String get highestSpent;

  /// No description provided for @noTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No trips yet.'**
  String get noTripsYet;

  /// No description provided for @editTripDeleteStop.
  ///
  /// In en, this message translates to:
  /// **'Delete Stop'**
  String get editTripDeleteStop;

  /// No description provided for @editTripDeleteStopConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this stop?'**
  String get editTripDeleteStopConfirmation;

  /// No description provided for @editTripEditStop.
  ///
  /// In en, this message translates to:
  /// **'Edit Stop'**
  String get editTripEditStop;

  /// No description provided for @editTripEditStopNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Stop editing will be available here.'**
  String get editTripEditStopNotImplemented;

  /// No description provided for @editTripAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add Stop'**
  String get editTripAddStop;

  /// No description provided for @editTripAddStopSuccess.
  ///
  /// In en, this message translates to:
  /// **'Stop added successfully'**
  String get editTripAddStopSuccess;

  /// No description provided for @editTripDeleteChecklist.
  ///
  /// In en, this message translates to:
  /// **'Delete Checklist'**
  String get editTripDeleteChecklist;

  /// No description provided for @editTripDeleteChecklistConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this checklist item?'**
  String get editTripDeleteChecklistConfirm;

  /// No description provided for @editTripDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get editTripDelete;

  /// No description provided for @editTripCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editTripCancel;

  /// No description provided for @editTripDeleteChecklistSuccess.
  ///
  /// In en, this message translates to:
  /// **'Checklist deleted successfully'**
  String get editTripDeleteChecklistSuccess;

  /// No description provided for @editTripDeleteChecklistFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete checklist item'**
  String get editTripDeleteChecklistFailed;

  /// No description provided for @editTripEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTripEdit;

  /// No description provided for @viewBills.
  ///
  /// In en, this message translates to:
  /// **'View Bills'**
  String get viewBills;

  /// No description provided for @alreadySettled.
  ///
  /// In en, this message translates to:
  /// **'Already settled?'**
  String get alreadySettled;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @confirmSettlement.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get confirmSettlement;

  /// No description provided for @confirmSettlementMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark your share as paid?'**
  String get confirmSettlementMessage;

  /// No description provided for @settle.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get settle;

  /// No description provided for @noRecentTripsYet.
  ///
  /// In en, this message translates to:
  /// **'No recent trips yet.'**
  String get noRecentTripsYet;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @apiRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get apiRequestCancelled;

  /// No description provided for @apiTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection is slow. Please try again.'**
  String get apiTimeout;

  /// No description provided for @apiNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get apiNoInternet;

  /// No description provided for @serverBadResponse.
  ///
  /// In en, this message translates to:
  /// **'The server sent an unexpected response. Please try again.'**
  String get serverBadResponse;

  /// No description provided for @apiUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please log in again.'**
  String get apiUnauthorized;

  /// No description provided for @apiForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to do this.'**
  String get apiForbidden;

  /// No description provided for @apiNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you\'re looking for.'**
  String get apiNotFound;

  /// No description provided for @apiServerError.
  ///
  /// In en, this message translates to:
  /// **'Our server has a problem right now. Please try again later.'**
  String get apiServerError;

  /// No description provided for @apiAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'The {field} \'{value}\' is already taken. Please try another one.'**
  String apiAlreadyTaken(Object field, Object value);

  /// No description provided for @unitKmValue.
  ///
  /// In en, this message translates to:
  /// **'{value}KM'**
  String unitKmValue(Object value);

  /// No description provided for @unitMeterValue.
  ///
  /// In en, this message translates to:
  /// **'{value}M'**
  String unitMeterValue(Object value);

  /// No description provided for @homeDailyQuote.
  ///
  /// In en, this message translates to:
  /// **'“Success is stumbling from failure to failure with no loss of enthusiasm” - Winston Churchill'**
  String get homeDailyQuote;

  /// No description provided for @homeSloganMove.
  ///
  /// In en, this message translates to:
  /// **'MOVE'**
  String get homeSloganMove;

  /// No description provided for @homeSloganExplore.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE'**
  String get homeSloganExplore;

  /// No description provided for @homeSloganAchieve.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVE'**
  String get homeSloganAchieve;

  /// No description provided for @notifChannelImportant.
  ///
  /// In en, this message translates to:
  /// **'High Importance Notifications'**
  String get notifChannelImportant;

  /// No description provided for @notifChannelImportantDesc.
  ///
  /// In en, this message translates to:
  /// **'This channel is used for important notifications and alerts.'**
  String get notifChannelImportantDesc;

  /// No description provided for @notifChannelTaskReminders.
  ///
  /// In en, this message translates to:
  /// **'Task Reminders'**
  String get notifChannelTaskReminders;

  /// No description provided for @notifChannelTaskRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications for task deadlines and upcoming reminders'**
  String get notifChannelTaskRemindersDesc;

  /// No description provided for @taskReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Reminder: {title}'**
  String taskReminderTitle(Object title);

  /// No description provided for @taskReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to complete your task!'**
  String get taskReminderBody;

  /// No description provided for @authVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get authVerifiedTitle;

  /// No description provided for @authOtpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified Successfully!'**
  String get authOtpVerified;

  /// No description provided for @authCodeSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Code Sent'**
  String get authCodeSentTitle;

  /// No description provided for @authNewCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new code has been sent to your email.'**
  String get authNewCodeSent;

  /// No description provided for @authEmailVerified.
  ///
  /// In en, this message translates to:
  /// **'Email Verified Successfully!'**
  String get authEmailVerified;

  /// No description provided for @authNewVerificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A new verification code has been sent to your email.'**
  String get authNewVerificationCodeSent;

  /// No description provided for @authOtpSentTitle.
  ///
  /// In en, this message translates to:
  /// **'OTP Sent'**
  String get authOtpSentTitle;

  /// No description provided for @authOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'An OTP has been sent to {email}.'**
  String authOtpSentTo(Object email);

  /// No description provided for @authPasswordResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get authPasswordResetTitle;

  /// No description provided for @authPasswordResetDone.
  ///
  /// In en, this message translates to:
  /// **'Your password has been reset successfully.'**
  String get authPasswordResetDone;

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'YOUR LIFE, IN MOTION'**
  String get authTagline;

  /// No description provided for @activitySteps.
  ///
  /// In en, this message translates to:
  /// **'STEPS'**
  String get activitySteps;

  /// No description provided for @activityDurationMins.
  ///
  /// In en, this message translates to:
  /// **'{mins} MINS'**
  String activityDurationMins(Object mins);

  /// No description provided for @activityCalories.
  ///
  /// In en, this message translates to:
  /// **'CALORIES'**
  String get activityCalories;

  /// No description provided for @activityAvgPace.
  ///
  /// In en, this message translates to:
  /// **'AVG PACE'**
  String get activityAvgPace;

  /// No description provided for @activityChallenge.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE'**
  String get activityChallenge;

  /// No description provided for @activityCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED 🔥'**
  String get activityCompleted;

  /// No description provided for @likesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Likes'**
  String likesCount(Object count);

  /// No description provided for @commentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Comments'**
  String commentsCount(Object count);

  /// No description provided for @activityWorkout.
  ///
  /// In en, this message translates to:
  /// **'WORKOUT'**
  String get activityWorkout;

  /// No description provided for @homeMovemUser.
  ///
  /// In en, this message translates to:
  /// **'MoveM User'**
  String get homeMovemUser;

  /// No description provided for @feedCompletedRunDistance.
  ///
  /// In en, this message translates to:
  /// **'Completed a {distance} Run! 🔥'**
  String feedCompletedRunDistance(Object distance);

  /// No description provided for @feedCompletedRun.
  ///
  /// In en, this message translates to:
  /// **'Completed a Run! 🔥'**
  String get feedCompletedRun;

  /// No description provided for @feedCompletedPushUp.
  ///
  /// In en, this message translates to:
  /// **'Completed a PushUp Challenge 🔥'**
  String get feedCompletedPushUp;

  /// No description provided for @feedCompletedSquat.
  ///
  /// In en, this message translates to:
  /// **'Completed a Squat Challenge 🔥'**
  String get feedCompletedSquat;

  /// No description provided for @feedCompletedWorkout.
  ///
  /// In en, this message translates to:
  /// **'Completed a {type} Challenge 🔥'**
  String feedCompletedWorkout(Object type);

  /// No description provided for @homeMovemAthlete.
  ///
  /// In en, this message translates to:
  /// **'MoveM Athlete'**
  String get homeMovemAthlete;

  /// No description provided for @caloriesValue.
  ///
  /// In en, this message translates to:
  /// **'{count}Cals'**
  String caloriesValue(Object count);

  /// No description provided for @stepsValue.
  ///
  /// In en, this message translates to:
  /// **'{count}Steps'**
  String stepsValue(Object count);

  /// No description provided for @durHoursMins.
  ///
  /// In en, this message translates to:
  /// **'{hours}Hr {mins}Mins'**
  String durHoursMins(Object hours, Object mins);

  /// No description provided for @durHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}Hr'**
  String durHours(Object hours);

  /// No description provided for @durMins.
  ///
  /// In en, this message translates to:
  /// **'{mins}Mins'**
  String durMins(Object mins);

  /// No description provided for @paceValue.
  ///
  /// In en, this message translates to:
  /// **'{pace} / KM'**
  String paceValue(Object pace);

  /// No description provided for @runSprintName.
  ///
  /// In en, this message translates to:
  /// **'{km} KILOMETERS SPRINT'**
  String runSprintName(Object km);

  /// No description provided for @activityRun.
  ///
  /// In en, this message translates to:
  /// **'RUN'**
  String get activityRun;

  /// No description provided for @durMinsSecs.
  ///
  /// In en, this message translates to:
  /// **'{mins}m {secs}s'**
  String durMinsSecs(Object mins, Object secs);

  /// No description provided for @durSecs.
  ///
  /// In en, this message translates to:
  /// **'{secs}s'**
  String durSecs(Object secs);

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @addPhone.
  ///
  /// In en, this message translates to:
  /// **'Add phone'**
  String get addPhone;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @phoneNumberLower.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLower;

  /// No description provided for @emailPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your email address is linked to your account and remains private. If updated, your previous address may be kept for account recovery.'**
  String get emailPrivacyNote;

  /// No description provided for @phoneUpdateNote.
  ///
  /// In en, this message translates to:
  /// **'Your phone number will be updated in your profile.'**
  String get phoneUpdateNote;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @phoneUpdated.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully'**
  String get phoneUpdated;

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logOutConfirm;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @chooseRegion.
  ///
  /// In en, this message translates to:
  /// **'Choose your region'**
  String get chooseRegion;

  /// No description provided for @chooseRegionSub.
  ///
  /// In en, this message translates to:
  /// **'Select your country and province, state, or region.'**
  String get chooseRegionSub;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country...'**
  String get searchCountry;

  /// No description provided for @regionStateProvince.
  ///
  /// In en, this message translates to:
  /// **'Region / State / Province'**
  String get regionStateProvince;

  /// No description provided for @selectRegionLower.
  ///
  /// In en, this message translates to:
  /// **'Select region'**
  String get selectRegionLower;

  /// No description provided for @searchRegion.
  ///
  /// In en, this message translates to:
  /// **'Search region...'**
  String get searchRegion;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed.'**
  String get passwordChanged;

  /// No description provided for @changeYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Change your password'**
  String get changeYourPassword;

  /// No description provided for @changePasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and choose a new one.'**
  String get changePasswordSub;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password.'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @newPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordTitle;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password.'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordMin8;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @pleaseConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password.'**
  String get pleaseConfirmNewPassword;

  /// No description provided for @forgotPasswordLower.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLower;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from Library'**
  String get chooseFromLibrary;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @removeCurrentPhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Current Profile'**
  String get removeCurrentPhoto;

  /// No description provided for @couldNotSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Could not select image.'**
  String get couldNotSelectImage;

  /// No description provided for @failedToSaveProfileChanges.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your changes. Please try again.'**
  String get failedToSaveProfileChanges;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @photoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'The server could not save your photo. Please try again later.'**
  String get photoUploadFailed;

  /// No description provided for @firstNameField.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameField;

  /// No description provided for @lastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameField;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @yourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Your email address:'**
  String get yourEmailAddress;

  /// No description provided for @yourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Your phone number:'**
  String get yourPhoneNumber;

  /// No description provided for @phonePrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your phone number is linked to your account and remains private. If updated, your previous number may be kept for account recovery.'**
  String get phonePrivacyNote;

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhoneNumber;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get verifyEmail;

  /// No description provided for @verifyEmailSub.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to your registered email address to confirm your identity. Please check your inbox and enter the code.'**
  String get verifyEmailSub;

  /// No description provided for @resendCodeInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeInSeconds(Object seconds);

  /// No description provided for @resendCodeLower.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCodeLower;

  /// No description provided for @pleaseEnter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the 6-digit verification code'**
  String get pleaseEnter6DigitCode;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP.'**
  String get pleaseEnterOtp;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetYourPassword;

  /// No description provided for @resetPasswordSub.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and use the OTP sent to you to create a new password.'**
  String get resetPasswordSub;

  /// No description provided for @otpCodeField.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpCodeField;

  /// No description provided for @enter6DigitOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get enter6DigitOtp;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @otpExpiryNote.
  ///
  /// In en, this message translates to:
  /// **'The OTP expires according to your account security settings.'**
  String get otpExpiryNote;

  /// No description provided for @resetPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordAction;

  /// No description provided for @friendRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Friend request accepted'**
  String get friendRequestAccepted;

  /// No description provided for @friendRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Friend request rejected'**
  String get friendRequestRejected;

  /// No description provided for @challengesCompleted.
  ///
  /// In en, this message translates to:
  /// **'Challenges Completed'**
  String get challengesCompleted;

  /// No description provided for @tripPlans.
  ///
  /// In en, this message translates to:
  /// **'Trip Plans'**
  String get tripPlans;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @recentAchievementsLead.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recentAchievementsLead;

  /// No description provided for @mutualFriendsLead.
  ///
  /// In en, this message translates to:
  /// **'Mutual'**
  String get mutualFriendsLead;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSent;

  /// No description provided for @moveWithPurpose.
  ///
  /// In en, this message translates to:
  /// **'MOVE WITH PURPOSE'**
  String get moveWithPurpose;

  /// No description provided for @addFriendsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Find And Connect With Friends To Stay Active Together'**
  String get addFriendsHeadline;

  /// No description provided for @inviteShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on MoveM! Move with purpose. Use my invite link: {link}'**
  String inviteShareMessage(Object link);

  /// No description provided for @qrCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to capture QR code image'**
  String get qrCaptureFailed;

  /// No description provided for @qrConvertFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to convert QR code to image'**
  String get qrConvertFailed;

  /// No description provided for @permissionNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionNeededTitle;

  /// No description provided for @allowPhotoAccessQr.
  ///
  /// In en, this message translates to:
  /// **'Please allow photo access to save the QR code'**
  String get allowPhotoAccessQr;

  /// No description provided for @qrSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save QR code to Photos'**
  String get qrSaveFailed;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// No description provided for @profileLinkCopiedWithLink.
  ///
  /// In en, this message translates to:
  /// **'Profile link copied to clipboard: {link}'**
  String profileLinkCopiedWithLink(Object link);

  /// No description provided for @friendRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Friend request sent.'**
  String get friendRequestSent;

  /// No description provided for @nowFriends.
  ///
  /// In en, this message translates to:
  /// **'You are now friends.'**
  String get nowFriends;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermissionRequired;

  /// No description provided for @noCameraFound.
  ///
  /// In en, this message translates to:
  /// **'No camera found'**
  String get noCameraFound;

  /// No description provided for @cameraInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to initialize camera'**
  String get cameraInitFailed;

  /// No description provided for @couldNotOpenImage.
  ///
  /// In en, this message translates to:
  /// **'Could not open the selected image'**
  String get couldNotOpenImage;

  /// No description provided for @invalidQr.
  ///
  /// In en, this message translates to:
  /// **'Invalid QR'**
  String get invalidQr;

  /// No description provided for @noQrInImage.
  ///
  /// In en, this message translates to:
  /// **'No valid QR code found in this image'**
  String get noQrInImage;

  /// No description provided for @qrGalleryScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to scan QR from gallery'**
  String get qrGalleryScanFailed;

  /// No description provided for @noUserInQr.
  ///
  /// In en, this message translates to:
  /// **'No valid user found in QR code'**
  String get noUserInQr;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @priorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priorityUrgent;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthly;

  /// No description provided for @repeatYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get repeatYearly;

  /// No description provided for @repeatRecurring.
  ///
  /// In en, this message translates to:
  /// **'REPEATS'**
  String get repeatRecurring;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get taskStatusComplete;

  /// No description provided for @taskStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get taskStatusCancelled;

  /// No description provided for @taskStatusDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get taskStatusDeleted;

  /// No description provided for @taskStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get taskStatusCompleted;

  /// No description provided for @deadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Deadline Passed'**
  String get deadlinePassed;

  /// No description provided for @markAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markAsComplete;

  /// No description provided for @dueOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dueOverdue;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due Tomorrow'**
  String get dueTomorrow;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {days} days'**
  String dueInDays(Object days);

  /// No description provided for @dueNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Due Next Week'**
  String get dueNextWeek;

  /// No description provided for @dueOnDate.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOnDate(Object date);

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get dueSoon;

  /// No description provided for @overdueOnDate.
  ///
  /// In en, this message translates to:
  /// **'Overdue · {date}'**
  String overdueOnDate(Object date);

  /// No description provided for @deadlineOnDate.
  ///
  /// In en, this message translates to:
  /// **'Deadline: {date}'**
  String deadlineOnDate(Object date);

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @inviteQuery.
  ///
  /// In en, this message translates to:
  /// **'Invite \"{query}\"'**
  String inviteQuery(Object query);

  /// No description provided for @deadlinesLabel.
  ///
  /// In en, this message translates to:
  /// **'DEADLINES'**
  String get deadlinesLabel;

  /// No description provided for @repeatLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'REPEAT'**
  String get repeatLabelTitle;

  /// No description provided for @yourNextReminder.
  ///
  /// In en, this message translates to:
  /// **'Your Next Reminder'**
  String get yourNextReminder;

  /// No description provided for @attachmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Attachments   ({count})'**
  String attachmentsCount(Object count);

  /// No description provided for @labelTitle.
  ///
  /// In en, this message translates to:
  /// **'LABEL'**
  String get labelTitle;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get detailsTitle;

  /// No description provided for @collaboratorsCount.
  ///
  /// In en, this message translates to:
  /// **'Collaborators   ({count})'**
  String collaboratorsCount(Object count);

  /// No description provided for @attachment.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get attachment;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'TITLE'**
  String get titleLabel;

  /// No description provided for @taskTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitlePlaceholder;

  /// No description provided for @taskDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter task description...'**
  String get taskDescriptionHint;

  /// No description provided for @selectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Label'**
  String get selectLabel;

  /// No description provided for @addAnItem.
  ///
  /// In en, this message translates to:
  /// **'Add an item'**
  String get addAnItem;

  /// No description provided for @addCollaboratorsCaps.
  ///
  /// In en, this message translates to:
  /// **'ADD COLLABORATORS'**
  String get addCollaboratorsCaps;

  /// No description provided for @noAttachmentsAdded.
  ///
  /// In en, this message translates to:
  /// **'No attachments added'**
  String get noAttachmentsAdded;

  /// No description provided for @uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// No description provided for @readyToUploadOnSave.
  ///
  /// In en, this message translates to:
  /// **'Ready to upload on save'**
  String get readyToUploadOnSave;

  /// No description provided for @addAttachmentsCaps.
  ///
  /// In en, this message translates to:
  /// **'ADD ATTACHMENTS'**
  String get addAttachmentsCaps;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @taskReminderOptIn.
  ///
  /// In en, this message translates to:
  /// **'Get upcoming reminders about your Tasks'**
  String get taskReminderOptIn;

  /// No description provided for @createCaps.
  ///
  /// In en, this message translates to:
  /// **'CREATE'**
  String get createCaps;

  /// No description provided for @createLabelTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Label'**
  String get createLabelTitle;

  /// No description provided for @enterLabelName.
  ///
  /// In en, this message translates to:
  /// **'Enter label name'**
  String get enterLabelName;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'COLOR'**
  String get colorLabel;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get progressTitle;

  /// No description provided for @allTasksCaps.
  ///
  /// In en, this message translates to:
  /// **'ALL TASKS'**
  String get allTasksCaps;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @filterTasks.
  ///
  /// In en, this message translates to:
  /// **'Filter Tasks'**
  String get filterTasks;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusLabel;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @taskHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready To Elevate Your\nTask To Another Level?'**
  String get taskHeroTitle;

  /// No description provided for @completedTasksCaps.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED TASKS'**
  String get completedTasksCaps;

  /// No description provided for @createTaskCaps.
  ///
  /// In en, this message translates to:
  /// **'CREATE TASK'**
  String get createTaskCaps;

  /// No description provided for @createTaskSub.
  ///
  /// In en, this message translates to:
  /// **'Let your brain relax, put it here.'**
  String get createTaskSub;

  /// No description provided for @completedCaps.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get completedCaps;

  /// No description provided for @upcomingTasks.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Tasks'**
  String get upcomingTasks;

  /// No description provided for @noUpcomingTasks.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks'**
  String get noUpcomingTasks;

  /// No description provided for @ongoingTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'On-Going Tasks'**
  String get ongoingTasksTitle;

  /// No description provided for @noOngoingTasks.
  ///
  /// In en, this message translates to:
  /// **'No ongoing tasks'**
  String get noOngoingTasks;

  /// No description provided for @noDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get noDeadline;

  /// No description provided for @progressionPercent.
  ///
  /// In en, this message translates to:
  /// **'Progression : {percent}%'**
  String progressionPercent(Object percent);

  /// No description provided for @someone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get someone;

  /// No description provided for @aTask.
  ///
  /// In en, this message translates to:
  /// **'a task'**
  String get aTask;

  /// No description provided for @invitedYouToCollaborate.
  ///
  /// In en, this message translates to:
  /// **' has invited you to collaborate in'**
  String get invitedYouToCollaborate;

  /// No description provided for @failedToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedToLoadHistory;

  /// No description provided for @failedToSend.
  ///
  /// In en, this message translates to:
  /// **'Failed to Send'**
  String get failedToSend;

  /// No description provided for @updatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedTitle;

  /// No description provided for @commentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Comment updated successfully'**
  String get commentUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get updateFailed;

  /// No description provided for @commentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully'**
  String get commentDeleted;

  /// No description provided for @failedToLoadInvitations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load invitations'**
  String get failedToLoadInvitations;

  /// No description provided for @youJoinedName.
  ///
  /// In en, this message translates to:
  /// **'You joined {name}'**
  String youJoinedName(Object name);

  /// No description provided for @youJoinedTask.
  ///
  /// In en, this message translates to:
  /// **'You joined the task'**
  String get youJoinedTask;

  /// No description provided for @couldNotAccept.
  ///
  /// In en, this message translates to:
  /// **'Could not accept'**
  String get couldNotAccept;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get pleaseTryAgain;

  /// No description provided for @couldNotDecline.
  ///
  /// In en, this message translates to:
  /// **'Could not decline'**
  String get couldNotDecline;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get repeatNone;

  /// No description provided for @repeatCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get repeatCustom;

  /// No description provided for @taskStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskStatusUpcoming;

  /// No description provided for @taskStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get taskStatusPending;

  /// No description provided for @travelDriving.
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get travelDriving;

  /// No description provided for @travelWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get travelWalking;

  /// No description provided for @travelCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get travelCycling;

  /// No description provided for @travelRiding.
  ///
  /// In en, this message translates to:
  /// **'Riding'**
  String get travelRiding;

  /// No description provided for @noRouteForMode.
  ///
  /// In en, this message translates to:
  /// **'No {mode} route available for this trip.'**
  String noRouteForMode(Object mode);

  /// No description provided for @deleteTripConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This action cannot be undone.'**
  String deleteTripConfirm(Object name);

  /// No description provided for @tripHeroEnhance.
  ///
  /// In en, this message translates to:
  /// **'ENHANCE YOUR\nJOURNEY WITH US.'**
  String get tripHeroEnhance;

  /// No description provided for @buildingRoute.
  ///
  /// In en, this message translates to:
  /// **'Building route...'**
  String get buildingRoute;

  /// No description provided for @placeHasNoCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Selected place has no coordinates.'**
  String get placeHasNoCoordinates;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown location'**
  String get unknownLocation;

  /// No description provided for @tripWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE\nTHE WORLD\nWITH US'**
  String get tripWelcomeTitle;

  /// No description provided for @tripWelcomeSub.
  ///
  /// In en, this message translates to:
  /// **'Move with purpose, Always'**
  String get tripWelcomeSub;

  /// No description provided for @slideToExplore.
  ///
  /// In en, this message translates to:
  /// **'Slide to explore'**
  String get slideToExplore;

  /// No description provided for @goLabel.
  ///
  /// In en, this message translates to:
  /// **'GO'**
  String get goLabel;

  /// No description provided for @failedToSearchUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to search users'**
  String get failedToSearchUsers;

  /// No description provided for @invitationSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitation Sent'**
  String get invitationSentTitle;

  /// No description provided for @invitationSentTo.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent to {name}'**
  String invitationSentTo(Object name);

  /// No description provided for @invitationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitation Failed'**
  String get invitationFailedTitle;

  /// No description provided for @couldNotInviteName.
  ///
  /// In en, this message translates to:
  /// **'Could not invite {name}'**
  String couldNotInviteName(Object name);

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'ROUTE DETAILS'**
  String get routeDetails;

  /// No description provided for @routeDistanceAndTime.
  ///
  /// In en, this message translates to:
  /// **'{km} km • {time}'**
  String routeDistanceAndTime(Object km, Object time);

  /// No description provided for @distanceCaps.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get distanceCaps;

  /// No description provided for @kmValueLower.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String kmValueLower(Object km);

  /// No description provided for @estTime.
  ///
  /// In en, this message translates to:
  /// **'EST. TIME'**
  String get estTime;

  /// No description provided for @travelModeCaps.
  ///
  /// In en, this message translates to:
  /// **'TRAVEL MODE'**
  String get travelModeCaps;

  /// No description provided for @noStopsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stops available.'**
  String get noStopsAvailable;

  /// No description provided for @routeStop.
  ///
  /// In en, this message translates to:
  /// **'Route stop'**
  String get routeStop;

  /// No description provided for @locationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled.'**
  String get locationServicesOff;

  /// No description provided for @locationNeededForRoute.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to show the route.'**
  String get locationNeededForRoute;

  /// No description provided for @unableToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get location.'**
  String get unableToGetLocation;

  /// No description provided for @tripDestinationMissing.
  ///
  /// In en, this message translates to:
  /// **'This trip\'s destination isn\'t on the map yet.'**
  String get tripDestinationMissing;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// No description provided for @stopNumber.
  ///
  /// In en, this message translates to:
  /// **'Stop {number}'**
  String stopNumber(Object number);

  /// No description provided for @destinationTitle.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destinationTitle;

  /// No description provided for @tripNameRequiredShort.
  ///
  /// In en, this message translates to:
  /// **'Trip name is required.'**
  String get tripNameRequiredShort;

  /// No description provided for @startDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Start date is required.'**
  String get startDateRequired;

  /// No description provided for @tripHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'WHAT’S\nYOUR\nNEXT\nPLAN?'**
  String get tripHeroTitle;

  /// No description provided for @planYourJourney.
  ///
  /// In en, this message translates to:
  /// **'PLAN YOUR JOURNEY'**
  String get planYourJourney;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get deleteTrip;

  /// No description provided for @tripDeleted.
  ///
  /// In en, this message translates to:
  /// **'Trip deleted successfully.'**
  String get tripDeleted;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select date and time'**
  String get selectDateAndTime;

  /// No description provided for @selectBothDates.
  ///
  /// In en, this message translates to:
  /// **'Please select both dates'**
  String get selectBothDates;

  /// No description provided for @endBeforeStart.
  ///
  /// In en, this message translates to:
  /// **'The end date can\'t be before the start date'**
  String get endBeforeStart;

  /// No description provided for @durationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Duration updated'**
  String get durationUpdated;

  /// No description provided for @stopUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stop updated successfully'**
  String get stopUpdated;

  /// No description provided for @cancelCaps.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelCaps;

  /// No description provided for @deleteCaps.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get deleteCaps;

  /// No description provided for @stopNoValidLocation.
  ///
  /// In en, this message translates to:
  /// **'This stop does not have a valid location.'**
  String get stopNoValidLocation;

  /// No description provided for @pleaseEnterChecklistItem.
  ///
  /// In en, this message translates to:
  /// **'Please enter a checklist item'**
  String get pleaseEnterChecklistItem;

  /// No description provided for @checklistUpdated.
  ///
  /// In en, this message translates to:
  /// **'Checklist updated'**
  String get checklistUpdated;

  /// No description provided for @attachmentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Attachment uploaded'**
  String get attachmentUploaded;

  /// No description provided for @stopNoMapLocation.
  ///
  /// In en, this message translates to:
  /// **'This stop does not have a location on the map.'**
  String get stopNoMapLocation;

  /// No description provided for @unableToGetThisLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get this location.'**
  String get unableToGetThisLocation;

  /// No description provided for @selectedStop.
  ///
  /// In en, this message translates to:
  /// **'Selected stop'**
  String get selectedStop;

  /// No description provided for @searchForStop.
  ///
  /// In en, this message translates to:
  /// **'Search for a stop'**
  String get searchForStop;

  /// No description provided for @setStop.
  ///
  /// In en, this message translates to:
  /// **'SET STOP'**
  String get setStop;

  /// No description provided for @workoutRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get workoutRunning;

  /// No description provided for @workoutWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get workoutWalking;

  /// No description provided for @workoutCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get workoutCycling;

  /// No description provided for @workoutSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get workoutSwimming;

  /// No description provided for @workoutHiking.
  ///
  /// In en, this message translates to:
  /// **'Hiking'**
  String get workoutHiking;

  /// No description provided for @workoutPushUp.
  ///
  /// In en, this message translates to:
  /// **'Push Up'**
  String get workoutPushUp;

  /// No description provided for @workoutSquats.
  ///
  /// In en, this message translates to:
  /// **'Squats'**
  String get workoutSquats;

  /// No description provided for @workoutPullUps.
  ///
  /// In en, this message translates to:
  /// **'Pull Ups'**
  String get workoutPullUps;

  /// No description provided for @workoutStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get workoutStrength;

  /// No description provided for @workoutBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get workoutBodyweight;

  /// No description provided for @workoutYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get workoutYoga;

  /// No description provided for @workoutStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get workoutStretching;

  /// No description provided for @workoutCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get workoutCardio;

  /// No description provided for @workoutSports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get workoutSports;

  /// No description provided for @workoutBadminton.
  ///
  /// In en, this message translates to:
  /// **'Badminton'**
  String get workoutBadminton;

  /// No description provided for @workoutTennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get workoutTennis;

  /// No description provided for @unitKm.
  ///
  /// In en, this message translates to:
  /// **'KM'**
  String get unitKm;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get unitMeters;

  /// No description provided for @unitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get unitMinutes;

  /// No description provided for @unitSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get unitSteps;

  /// No description provided for @unitReps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get unitReps;

  /// No description provided for @challengeWithName.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE: {name}'**
  String challengeWithName(Object name);

  /// No description provided for @finishedCaps.
  ///
  /// In en, this message translates to:
  /// **'FINISHED'**
  String get finishedCaps;

  /// No description provided for @finishedFire.
  ///
  /// In en, this message translates to:
  /// **'FINISHED 🔥'**
  String get finishedFire;

  /// No description provided for @durationSecsCaps.
  ///
  /// In en, this message translates to:
  /// **'{secs} SECS'**
  String durationSecsCaps(Object secs);

  /// No description provided for @trackingComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'{workout} Tracking Coming Soon'**
  String trackingComingSoonTitle(Object workout);

  /// No description provided for @trackingComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Tracking for {workout} is currently in active development and will be available in an upcoming update.'**
  String trackingComingSoonBody(Object workout);

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @setsOfReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} Sets of {reps} {unit}'**
  String setsOfReps(Object sets, Object reps, Object unit);

  /// No description provided for @statusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// No description provided for @statusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get statusNotStarted;

  /// No description provided for @requestedToJoinClub.
  ///
  /// In en, this message translates to:
  /// **'{name} has requested to join {club}'**
  String requestedToJoinClub(Object name, Object club);

  /// No description provided for @yourClub.
  ///
  /// In en, this message translates to:
  /// **'your club'**
  String get yourClub;

  /// No description provided for @runningTargetTitle.
  ///
  /// In en, this message translates to:
  /// **'{target} Running'**
  String runningTargetTitle(Object target);

  /// No description provided for @runningChallenge.
  ///
  /// In en, this message translates to:
  /// **'Running Challenge'**
  String get runningChallenge;

  /// No description provided for @runningDescription.
  ///
  /// In en, this message translates to:
  /// **'Run and track your route, pace, distance, and calories burned in real time.'**
  String get runningDescription;

  /// No description provided for @squatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Lower hips from standing position then stand back up to build leg and core strength.'**
  String get squatsDescription;

  /// No description provided for @pushUpDescription.
  ///
  /// In en, this message translates to:
  /// **'An exercise done to improve upper body strength, performed by resting on one\'s toes and hands and pushing one\'s weight off the floor'**
  String get pushUpDescription;

  /// No description provided for @genericChallengeDescription.
  ///
  /// In en, this message translates to:
  /// **'Challenge yourself and stay consistent to achieve your personal fitness targets.'**
  String get genericChallengeDescription;

  /// No description provided for @formExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get formExcellent;

  /// No description provided for @formGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get formGood;

  /// No description provided for @formShallow.
  ///
  /// In en, this message translates to:
  /// **'Shallow'**
  String get formShallow;

  /// No description provided for @formNoReps.
  ///
  /// In en, this message translates to:
  /// **'No Reps'**
  String get formNoReps;

  /// No description provided for @formRatingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent Form 🏆'**
  String get formRatingExcellent;

  /// No description provided for @formRatingGood.
  ///
  /// In en, this message translates to:
  /// **'Good Form 💪'**
  String get formRatingGood;

  /// No description provided for @formRatingWorkOnDepth.
  ///
  /// In en, this message translates to:
  /// **'Work on Depth ⚠️'**
  String get formRatingWorkOnDepth;

  /// No description provided for @formDeepSquat.
  ///
  /// In en, this message translates to:
  /// **'Deep Squat'**
  String get formDeepSquat;

  /// No description provided for @formGoodDepth.
  ///
  /// In en, this message translates to:
  /// **'Good Depth'**
  String get formGoodDepth;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelElite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get levelElite;

  /// No description provided for @completeTargetToFinish.
  ///
  /// In en, this message translates to:
  /// **'Complete {target} to finish this challenge.'**
  String completeTargetToFinish(Object target);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @joinedSince.
  ///
  /// In en, this message translates to:
  /// **'Joined since {year}'**
  String joinedSince(Object year);

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Club owner'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @targetWithUnit.
  ///
  /// In en, this message translates to:
  /// **'TARGET ({unit})'**
  String targetWithUnit(Object unit);

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get categoryGeneral;

  /// No description provided for @cueGoodDepthPushUp.
  ///
  /// In en, this message translates to:
  /// **'Good depth! Now push up!'**
  String get cueGoodDepthPushUp;

  /// No description provided for @cueLowerDown.
  ///
  /// In en, this message translates to:
  /// **'Lower down...'**
  String get cueLowerDown;

  /// No description provided for @cueGetReadyToLower.
  ///
  /// In en, this message translates to:
  /// **'Get ready to lower'**
  String get cueGetReadyToLower;

  /// No description provided for @cueExcellentRep.
  ///
  /// In en, this message translates to:
  /// **'Excellent Rep! 🏆'**
  String get cueExcellentRep;

  /// No description provided for @cueRepComplete.
  ///
  /// In en, this message translates to:
  /// **'Rep #{count} Complete!'**
  String cueRepComplete(Object count);

  /// No description provided for @cuePushAllTheWayUp.
  ///
  /// In en, this message translates to:
  /// **'Push all the way up!'**
  String get cuePushAllTheWayUp;

  /// No description provided for @cueGoodDepthSquat.
  ///
  /// In en, this message translates to:
  /// **'Good depth! Push up through your heels!'**
  String get cueGoodDepthSquat;

  /// No description provided for @cueLowerHips.
  ///
  /// In en, this message translates to:
  /// **'Lower your hips...'**
  String get cueLowerHips;

  /// No description provided for @cueStandTall.
  ///
  /// In en, this message translates to:
  /// **'Stand tall and begin squatting'**
  String get cueStandTall;

  /// No description provided for @cueDeepSquat.
  ///
  /// In en, this message translates to:
  /// **'Deep Squat! 🏆'**
  String get cueDeepSquat;

  /// No description provided for @cueStandAllTheWayUp.
  ///
  /// In en, this message translates to:
  /// **'Stand all the way up!'**
  String get cueStandAllTheWayUp;

  /// No description provided for @failedStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the workout'**
  String get failedStartWorkout;

  /// No description provided for @failedUpdateProgress.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your progress'**
  String get failedUpdateProgress;

  /// No description provided for @failedFinishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t finish the workout'**
  String get failedFinishWorkout;

  /// No description provided for @summaryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Workout summary not found'**
  String get summaryNotFound;

  /// No description provided for @failedSaveAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the workout analysis'**
  String get failedSaveAnalysis;

  /// No description provided for @goalNotFound.
  ///
  /// In en, this message translates to:
  /// **'Goal not found'**
  String get goalNotFound;

  /// No description provided for @challengeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Challenge not found'**
  String get challengeNotFound;

  /// No description provided for @clubNotFound.
  ///
  /// In en, this message translates to:
  /// **'Club not found'**
  String get clubNotFound;

  /// No description provided for @failedToUpdateClub.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the club. Try again.'**
  String get failedToUpdateClub;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @challengeNameCaps.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE NAME'**
  String get challengeNameCaps;

  /// No description provided for @challengeNameExample.
  ///
  /// In en, this message translates to:
  /// **'Morning Sprint Challenge'**
  String get challengeNameExample;

  /// No description provided for @startDateCaps.
  ///
  /// In en, this message translates to:
  /// **'START DATE'**
  String get startDateCaps;

  /// No description provided for @endDateCaps.
  ///
  /// In en, this message translates to:
  /// **'END DATE'**
  String get endDateCaps;

  /// No description provided for @descriptionsCaps.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTIONS'**
  String get descriptionsCaps;

  /// No description provided for @challengeDescExample.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 continuous laps of the park track.'**
  String get challengeDescExample;

  /// No description provided for @activityTypeCaps.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY TYPE'**
  String get activityTypeCaps;

  /// No description provided for @moreActivity.
  ///
  /// In en, this message translates to:
  /// **'More Activity'**
  String get moreActivity;

  /// No description provided for @challengeHasEnded.
  ///
  /// In en, this message translates to:
  /// **'Challenge Has Ended'**
  String get challengeHasEnded;

  /// No description provided for @descriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Descriptions'**
  String get descriptionsTitle;

  /// No description provided for @musclesBuiltBy.
  ///
  /// In en, this message translates to:
  /// **'MUSCLES BUILT BY'**
  String get musclesBuiltBy;

  /// No description provided for @createChallengeAgain.
  ///
  /// In en, this message translates to:
  /// **'CREATE CHALLENGE AGAIN?'**
  String get createChallengeAgain;

  /// No description provided for @joinClubChallenge.
  ///
  /// In en, this message translates to:
  /// **'Join Club Challenge'**
  String get joinClubChallenge;

  /// No description provided for @editYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit your details'**
  String get editYourDetails;

  /// No description provided for @yourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get yourDetails;

  /// No description provided for @heightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your height?'**
  String get heightQuestion;

  /// No description provided for @weightQuestion.
  ///
  /// In en, this message translates to:
  /// **'What\'s your current weight?'**
  String get weightQuestion;

  /// No description provided for @searchPeopleOnMovem.
  ///
  /// In en, this message translates to:
  /// **'Search for people on MoveM'**
  String get searchPeopleOnMovem;

  /// No description provided for @membersCountCaps.
  ///
  /// In en, this message translates to:
  /// **'MEMBERS ({count})'**
  String membersCountCaps(Object count);

  /// No description provided for @setGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Goal'**
  String get setGoal;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Workout'**
  String get todaysWorkout;

  /// No description provided for @smallStepBigChanges.
  ///
  /// In en, this message translates to:
  /// **'Small step, big changes'**
  String get smallStepBigChanges;

  /// No description provided for @startTrackingJourney.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your Fitness Journey with us now'**
  String get startTrackingJourney;

  /// No description provided for @caloriesBurnedTitle.
  ///
  /// In en, this message translates to:
  /// **'Calories Burned'**
  String get caloriesBurnedTitle;

  /// No description provided for @clubSloganSpaced.
  ///
  /// In en, this message translates to:
  /// **'MOVE MORE . BECOME MORE'**
  String get clubSloganSpaced;

  /// No description provided for @cueGetInPushUpPosition.
  ///
  /// In en, this message translates to:
  /// **'Get in push-up position'**
  String get cueGetInPushUpPosition;

  /// No description provided for @noCamerasOnDevice.
  ///
  /// In en, this message translates to:
  /// **'No cameras detected on device'**
  String get noCamerasOnDevice;

  /// No description provided for @cameraPermissionNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Camera permission not granted'**
  String get cameraPermissionNotGranted;

  /// No description provided for @simulationModePushUp.
  ///
  /// In en, this message translates to:
  /// **'Simulation Mode Active • Tap screen to count rep'**
  String get simulationModePushUp;

  /// No description provided for @cueShouldersInFrame.
  ///
  /// In en, this message translates to:
  /// **'Position shoulders and arms in frame'**
  String get cueShouldersInFrame;

  /// No description provided for @noPersonInFrame.
  ///
  /// In en, this message translates to:
  /// **'No person detected in frame'**
  String get noPersonInFrame;

  /// No description provided for @adjustPosition.
  ///
  /// In en, this message translates to:
  /// **'Adjust positioning for camera tracking'**
  String get adjustPosition;

  /// No description provided for @setCompleted.
  ///
  /// In en, this message translates to:
  /// **'Set Completed!'**
  String get setCompleted;

  /// No description provided for @setCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Awesome form! You completed Set {set} of {total}. Ready for the next set?'**
  String setCompletedBody(Object set, Object total);

  /// No description provided for @startNextSet.
  ///
  /// In en, this message translates to:
  /// **'Start Next Set'**
  String get startNextSet;

  /// No description provided for @notSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get notSaved;

  /// No description provided for @workoutNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Workout couldn\'t be saved to the server. Check your connection.'**
  String get workoutNotSaved;

  /// No description provided for @squatsChallenge.
  ///
  /// In en, this message translates to:
  /// **'Squats Challenge'**
  String get squatsChallenge;

  /// No description provided for @squatsShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Lower hips from standing position then stand back up.'**
  String get squatsShortDescription;

  /// No description provided for @strengthCategory.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strengthCategory;

  /// No description provided for @pullUpsName.
  ///
  /// In en, this message translates to:
  /// **'Pull ups'**
  String get pullUpsName;

  /// No description provided for @pullUpsDescription.
  ///
  /// In en, this message translates to:
  /// **'Upper-body exercise where you pull yourself up to a bar.'**
  String get pullUpsDescription;

  /// No description provided for @upperBody.
  ///
  /// In en, this message translates to:
  /// **'Upper Body'**
  String get upperBody;

  /// No description provided for @locationRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get locationRequiredTitle;

  /// No description provided for @locationNeededForRun.
  ///
  /// In en, this message translates to:
  /// **'Location access is needed to track your running distance, pace, and route.'**
  String get locationNeededForRun;

  /// No description provided for @locationAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationAccessRequired;

  /// No description provided for @locationSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'MoveM needs location access to track your GPS route, distance, and pace. Please enable location permissions in your device settings.'**
  String get locationSettingsBody;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Service Disabled'**
  String get locationServiceDisabled;

  /// No description provided for @turnOnGpsBody.
  ///
  /// In en, this message translates to:
  /// **'Please turn on GPS / Location service on your device so MoveM can record your run.'**
  String get turnOnGpsBody;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn On'**
  String get turnOn;

  /// No description provided for @failedLoadWorkoutHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load workout history'**
  String get failedLoadWorkoutHistory;

  /// No description provided for @cueFullView.
  ///
  /// In en, this message translates to:
  /// **'Stand in full view of the camera'**
  String get cueFullView;

  /// No description provided for @simulationModeSquat.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to count reps (Simulation Mode)'**
  String get simulationModeSquat;

  /// No description provided for @cueStepBack.
  ///
  /// In en, this message translates to:
  /// **'Step back so legs are visible'**
  String get cueStepBack;

  /// No description provided for @setCompleteRest.
  ///
  /// In en, this message translates to:
  /// **'Set {set} Complete! Take a quick rest.'**
  String setCompleteRest(Object set);

  /// No description provided for @challengeComplete.
  ///
  /// In en, this message translates to:
  /// **'Challenge Complete! 🏆'**
  String get challengeComplete;

  /// No description provided for @workoutPaused.
  ///
  /// In en, this message translates to:
  /// **'Workout Paused'**
  String get workoutPaused;

  /// No description provided for @resumingSquat.
  ///
  /// In en, this message translates to:
  /// **'Resuming... Let\'s squat!'**
  String get resumingSquat;

  /// No description provided for @fitnessChallenge.
  ///
  /// In en, this message translates to:
  /// **'Fitness Challenge'**
  String get fitnessChallenge;

  /// No description provided for @shareWorkout.
  ///
  /// In en, this message translates to:
  /// **'Share Workout'**
  String get shareWorkout;

  /// No description provided for @shareNotSaved.
  ///
  /// In en, this message translates to:
  /// **'This workout was not saved to the server, so it cannot be shared.'**
  String get shareNotSaved;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing…'**
  String get sharing;

  /// No description provided for @postingWorkout.
  ///
  /// In en, this message translates to:
  /// **'Posting your workout to the social feed.'**
  String get postingWorkout;

  /// No description provided for @workoutShared.
  ///
  /// In en, this message translates to:
  /// **'Your workout is now on the social feed.'**
  String get workoutShared;

  /// No description provided for @shareFailed.
  ///
  /// In en, this message translates to:
  /// **'Share failed'**
  String get shareFailed;

  /// No description provided for @couldNotShareWorkout.
  ///
  /// In en, this message translates to:
  /// **'Could not share this workout. Please try again.'**
  String get couldNotShareWorkout;

  /// No description provided for @clubSlogan.
  ///
  /// In en, this message translates to:
  /// **'MOVE MORE. BECOME MORE.'**
  String get clubSlogan;

  /// No description provided for @clubShareWithCode.
  ///
  /// In en, this message translates to:
  /// **'Join my club \"{name}\" on MoveM! Code: {code}'**
  String clubShareWithCode(Object name, Object code);

  /// No description provided for @clubShare.
  ///
  /// In en, this message translates to:
  /// **'Join my club \"{name}\" on MoveM!'**
  String clubShare(Object name);

  /// No description provided for @customizeOwnChallenge.
  ///
  /// In en, this message translates to:
  /// **'Customize Your Own Challenge +'**
  String get customizeOwnChallenge;

  /// No description provided for @featuredChallenges.
  ///
  /// In en, this message translates to:
  /// **'Featured Challenges'**
  String get featuredChallenges;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @clubTagline.
  ///
  /// In en, this message translates to:
  /// **'Stay active, motivate each other, and complete challenges together.'**
  String get clubTagline;

  /// No description provided for @memberNumber.
  ///
  /// In en, this message translates to:
  /// **'Member #{id}'**
  String memberNumber(Object id);

  /// No description provided for @goalCaps.
  ///
  /// In en, this message translates to:
  /// **'GOAL'**
  String get goalCaps;

  /// No description provided for @endAction.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endAction;

  /// No description provided for @viewSummary.
  ///
  /// In en, this message translates to:
  /// **'View Summary'**
  String get viewSummary;

  /// No description provided for @shareCaps.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get shareCaps;

  /// No description provided for @redoCaps.
  ///
  /// In en, this message translates to:
  /// **'REDO'**
  String get redoCaps;

  /// No description provided for @moreCaps.
  ///
  /// In en, this message translates to:
  /// **'MORE'**
  String get moreCaps;

  /// No description provided for @homeCaps.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get homeCaps;

  /// No description provided for @fitnessHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'ONE STEP\nTODAY. A\nSTRONGER YOU\nTOMORROW.'**
  String get fitnessHeroTitle;

  /// No description provided for @challengeEndedCaps.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE ENDED'**
  String get challengeEndedCaps;

  /// No description provided for @defaultClubName.
  ///
  /// In en, this message translates to:
  /// **'MoveM Fitness Club'**
  String get defaultClubName;

  /// No description provided for @clubDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your club and who should join...'**
  String get clubDescriptionHint;

  /// No description provided for @membersCountSpaced.
  ///
  /// In en, this message translates to:
  /// **'MEMBERS ( {count} )'**
  String membersCountSpaced(Object count);

  /// No description provided for @runningSession.
  ///
  /// In en, this message translates to:
  /// **'RUNNING SESSION'**
  String get runningSession;

  /// No description provided for @averagePaceCaps.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE PACE'**
  String get averagePaceCaps;

  /// No description provided for @waitingForGps.
  ///
  /// In en, this message translates to:
  /// **'Waiting for GPS'**
  String get waitingForGps;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location'**
  String get gettingLocation;

  /// No description provided for @moveOutdoors.
  ///
  /// In en, this message translates to:
  /// **'Move outdoors and try again'**
  String get moveOutdoors;

  /// No description provided for @runStartsAfterGps.
  ///
  /// In en, this message translates to:
  /// **'Run starts after GPS lock'**
  String get runStartsAfterGps;

  /// No description provided for @retryGps.
  ///
  /// In en, this message translates to:
  /// **'Retry GPS'**
  String get retryGps;

  /// No description provided for @tapCircleToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap circle to start now'**
  String get tapCircleToStart;

  /// No description provided for @stepCaps.
  ///
  /// In en, this message translates to:
  /// **'STEP'**
  String get stepCaps;

  /// No description provided for @runPauseLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'Your active running challenge will be paused. Do you want to leave?'**
  String get runPauseLeaveBody;

  /// No description provided for @exitAction.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitAction;

  /// No description provided for @unlockedOf.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} Unlocked'**
  String unlockedOf(Object earned, Object total);

  /// No description provided for @percentCompletedKeepPushing.
  ///
  /// In en, this message translates to:
  /// **'{percent}% completed • Keep pushing!'**
  String percentCompletedKeepPushing(Object percent);

  /// No description provided for @earnedCaps.
  ///
  /// In en, this message translates to:
  /// **'EARNED'**
  String get earnedCaps;

  /// No description provided for @kneeAngle.
  ///
  /// In en, this message translates to:
  /// **'KNEE ANGLE'**
  String get kneeAngle;

  /// No description provided for @workoutWillEnd.
  ///
  /// In en, this message translates to:
  /// **'Your progress for this workout will be ended.'**
  String get workoutWillEnd;

  /// No description provided for @finishAndSave.
  ///
  /// In en, this message translates to:
  /// **'Finish & Save'**
  String get finishAndSave;

  /// No description provided for @couldNotGetLocationOutdoors.
  ///
  /// In en, this message translates to:
  /// **'Could not get your current location. Move outdoors and try again.'**
  String get couldNotGetLocationOutdoors;

  /// No description provided for @heightCmValue.
  ///
  /// In en, this message translates to:
  /// **'{height} CM'**
  String heightCmValue(Object height);

  /// No description provided for @kcalValue.
  ///
  /// In en, this message translates to:
  /// **'{count} kcal'**
  String kcalValue(Object count);

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String itemDeleted(Object name);

  /// No description provided for @paceValueShort.
  ///
  /// In en, this message translates to:
  /// **'{pace} /km'**
  String paceValueShort(Object pace);

  /// No description provided for @attachmentsNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'{count} attachment change(s) could not be saved.'**
  String attachmentsNotUploaded(Object count);

  /// No description provided for @invitesNotSent.
  ///
  /// In en, this message translates to:
  /// **'{count} invite(s) could not be sent.'**
  String invitesNotSent(Object count);
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
