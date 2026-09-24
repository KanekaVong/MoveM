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

  /// No description provided for @joinClubSub.
  ///
  /// In en, this message translates to:
  /// **'Find an active club'**
  String get joinClubSub;

  /// No description provided for @createClubSub.
  ///
  /// In en, this message translates to:
  /// **'Create your own community'**
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

  /// No description provided for @yourClubs.
  ///
  /// In en, this message translates to:
  /// **'Your Clubs'**
  String get yourClubs;

  /// No description provided for @discoverClubs.
  ///
  /// In en, this message translates to:
  /// **'Discover Clubs'**
  String get discoverClubs;

  /// No description provided for @exploreAll.
  ///
  /// In en, this message translates to:
  /// **'Explore all'**
  String get exploreAll;

  /// No description provided for @beFirstClub.
  ///
  /// In en, this message translates to:
  /// **'Be the first to start a club!'**
  String get beFirstClub;

  /// No description provided for @haventJoinedClubs.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined a club yet'**
  String get haventJoinedClubs;

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
  /// **'No achievements yet'**
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

  /// No description provided for @membersCount.
  ///
  /// In en, this message translates to:
  /// **'Members ({count})'**
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
  /// **'History'**
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
