// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MoveM';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get home => 'Home';

  @override
  String get task => 'Task';

  @override
  String get fitness => 'Fitness';

  @override
  String get trip => 'Trip';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome!';

  @override
  String get gender => 'Gender';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get viewAll => 'View All';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get invite => 'Invite';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get finish => 'Finish';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get addFriend => 'Add Friend';

  @override
  String get remove => 'Remove';

  @override
  String get welcomeBack => 'WELCOME BACK!';

  @override
  String get emailOrPhone => 'EMAIL/PHONE NUMBER';

  @override
  String get username => 'USERNAME';

  @override
  String get firstName => 'FIRST NAME';

  @override
  String get lastName => 'LAST NAME';

  @override
  String get confirmPassword => 'CONFIRM PASSWORD';

  @override
  String get loginBtn => 'Log In';

  @override
  String get registerBtn => 'Sign Up';

  @override
  String get createAccountTitle => 'CREATE ACCOUNT';

  @override
  String get verifyOtpTitle => 'VERIFY OTP';

  @override
  String get otpCodeLabel => 'OTP CODE';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get verifyBtn => 'Verify';

  @override
  String get resetPasswordTitle => 'RESET PASSWORD';

  @override
  String get newPassword => 'NEW PASSWORD';

  @override
  String get savePasswordBtn => 'Save Password';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get welcomeBackTitle => 'WELCOME BACK';

  @override
  String get emailPhoneHint => 'Email/Phone Number';

  @override
  String get usernameHint => 'Username';

  @override
  String get setUsernameHint => 'Set Username';

  @override
  String get enterPasswordHint => 'Enter Password';

  @override
  String get setPasswordHint => 'Set Password';

  @override
  String get retypePasswordLabel => 'RE-TYPE PASSWORD';

  @override
  String get retypePasswordHint => 'Re-Type Password';

  @override
  String get registerAction => 'Register';

  @override
  String get loginAction => 'Login';

  @override
  String get noAccountSignUp => 'Doesn\'t have an account yet? Sign Up';

  @override
  String get haveAccountSignIn => 'Already have an account? Sign In';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get otpCodeHint => 'Enter 6-digit code';

  @override
  String otpSentTo(String identifier) {
    return 'Enter the code we sent to\n$identifier';
  }

  @override
  String get verifyAction => 'Verify';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get savePasswordAction => 'Save Password';

  @override
  String get fillAllFields => 'Please fill all fields.';

  @override
  String get greetings => 'Greetings';

  @override
  String get stayActiveToday => 'Stay Active Today!';

  @override
  String get todayProgress => 'Today\'s Progress';

  @override
  String get ongoingTasks => 'Ongoing Tasks';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get reminders => 'Reminders';

  @override
  String get weeklyStats => 'Weekly Stats';

  @override
  String get allTasks => 'All Tasks';

  @override
  String get createTask => 'Create Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get taskDetails => 'Task Details';

  @override
  String get addCollaborator => 'Add Collaborator';

  @override
  String get taskTitleLabel => 'TASK TITLE';

  @override
  String get taskTitleHint => 'Name your task...';

  @override
  String get descriptionLabel => 'DESCRIPTION';

  @override
  String get descriptionHint => 'Add extra notes...';

  @override
  String get deadlineLabel => 'DEADLINE';

  @override
  String get priorityLabel => 'PRIORITY';

  @override
  String get labelsLabel => 'LABELS';

  @override
  String get collaboratorsLabel => 'COLLABORATORS';

  @override
  String get checklistLabel => 'CHECKLIST';

  @override
  String get addChecklistItem => 'Add checklist item';

  @override
  String get completedTasks => 'Completed Tasks';

  @override
  String get suggested => 'Suggested';

  @override
  String get inviteCollaborators => 'Invite Collaborators';

  @override
  String get searchCollaboratorsHint => 'Search friends by name...';

  @override
  String get friends => 'FRIENDS';

  @override
  String get addFriends => 'Add Friends';

  @override
  String get friendRequests => 'Friend Requests';

  @override
  String get friendSuggestions => 'Friend Suggestions';

  @override
  String get shareYourProfile => 'Share Your Profile';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get scanQrCodeSub => 'Scan your friend\'s QR code';

  @override
  String get inviteFriendsViaLink => 'Invite Friends';

  @override
  String get inviteFriendsViaLinkSub => 'Invite friends via link';

  @override
  String get myQrCode => 'My QR Code';

  @override
  String get saveQr => 'Save';

  @override
  String get shareQr => 'Share';

  @override
  String get qrSavedToast => 'QR code saved';

  @override
  String get scanToConnect => 'Scan to connect with me on MoveM';

  @override
  String get cameraStarting => 'Starting Camera...';

  @override
  String get alignQrHint => 'Align QR code inside the frame to scan';

  @override
  String get userFound => 'User Found';

  @override
  String get movemClub => 'MoveM Club';

  @override
  String get soloChallenges => 'Solo Challenges';

  @override
  String get groupActivity => 'Group Activity';

  @override
  String get yourGoal => 'Your Goal';

  @override
  String get liveTracking => 'Live Tracking';

  @override
  String get runSummary => 'Run Summary';

  @override
  String get runHistory => 'Run History';

  @override
  String get runDetails => 'Run Details';

  @override
  String get pushUpWorkout => 'Push Up Workout';

  @override
  String get workoutDetails => 'Workout Details';

  @override
  String get createActivity => 'Create Activity';

  @override
  String get createGroup => 'Create Group';

  @override
  String get invitePeople => 'Invite people';

  @override
  String get setupGoal => 'Goal & Focus';

  @override
  String get activityNameLabel => 'ACTIVITY NAME';

  @override
  String get groupNameLabel => 'GROUP NAME';

  @override
  String get distanceKm => 'Distance (km)';

  @override
  String get avgPace => 'Avg Pace';

  @override
  String get duration => 'DURATION';

  @override
  String get caloriesBurned => 'Calories';

  @override
  String get setLabel => 'SET';

  @override
  String get repsLabel => 'REPS';

  @override
  String get tapToCount => 'Tap screen to count rep';

  @override
  String get greatJobWorkout => 'Great job! Workout completed';

  @override
  String get tripsMap => 'Trips Map';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get accountSection => 'Account';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get sessionsSection => 'Sessions';

  @override
  String get yourProfile => 'Your Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get appearances => 'Appearances';

  @override
  String get darkLightTheme => 'Dark/Light';

  @override
  String get languages => 'Languages';

  @override
  String get privacy => 'Privacy';

  @override
  String get deleteAccount => 'Delete Your Account';

  @override
  String get logOut => 'Log Out';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get myActivities => 'My Activities';

  @override
  String get achievements => 'Achievements';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English (English)';

  @override
  String get languageKhmer => 'ភាសាខ្មែរ (Khmer)';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get yourInviteLink => 'YOUR INVITE LINK';

  @override
  String get yourToken => 'YOUR TOKEN';

  @override
  String get shareVia => 'SHARE VIA';

  @override
  String get inviteLinkCopied => 'Invite link copied to clipboard';

  @override
  String get inviteTokenCopied => 'Invite token copied to clipboard';

  @override
  String get copied => 'Copied';

  @override
  String get comments => 'Comments';

  @override
  String get writeComment => 'Write a comment...';

  @override
  String get editComment => 'Edit Comment';

  @override
  String get editingComment => 'Editing Comment';

  @override
  String get editYourComment => 'Edit your comment...';

  @override
  String get deleteComment => 'Delete Comment';

  @override
  String get deleteCommentConfirm =>
      'Are you sure you want to delete this comment? This action cannot be undone.';

  @override
  String get copyText => 'Copy Text';

  @override
  String get noCommentsYet => 'No comments yet';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get searchResults => 'Search Results';

  @override
  String get loading => 'Loading...';

  @override
  String get beTheFirstToComment =>
      'Be the first to leave a comment or ask a question about this task.';

  @override
  String get commentCopiedToast => 'Comment copied to clipboard';

  @override
  String get edited => 'edited';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get deleteTaskConfirm =>
      'Are you sure you want to delete this task? This action cannot be undone.';

  @override
  String get taskDeletedSuccess => 'Task deleted successfully';

  @override
  String get createNewTrip => 'Create New Trip';

  @override
  String get tripStepName => 'NAME';

  @override
  String get tripStepLocation => 'LOCATION';

  @override
  String get tripStepDuration => 'DURATION';

  @override
  String get tripStepStops => 'STOPS';

  @override
  String get tripStepFriends => 'FRIENDS';

  @override
  String get continueButton => 'CONTINUE';

  @override
  String get tripNameLabel => 'TRIP NAME';

  @override
  String get tripNameHint => 'Enter your trip name...';

  @override
  String get tripNameRequired => 'Please enter your trip name.';

  @override
  String get tripNameTitle => 'What\'s the Trip Called?';

  @override
  String get tripNameSubtitle => 'Give your adventure a name';

  @override
  String get tripLocationTitle => 'Where are you going?';

  @override
  String get tripLocationSubtitle =>
      'Search for a place or tap the map to choose it';

  @override
  String get tripLocationSearchHint => 'Search destination...';

  @override
  String get tripLocationSelected => 'Selected location';

  @override
  String get tripLocationRequired => 'Please select your destination.';

  @override
  String get tripLocationSearchFailed =>
      'Couldn\'t search for locations. Please try again.';

  @override
  String get tripLocationNotFound => 'No locations found.';

  @override
  String get tripLocationPermissionDenied =>
      'Location permission is required to use your current location.';

  @override
  String get tripLocationServiceDisabled => 'Please turn on location services.';

  @override
  String get tripLocationSearching => 'Searching...';

  @override
  String get tripDurationTitle => 'Duration & Budget';

  @override
  String get tripDurationSubtitle => 'How long and how much?';

  @override
  String get tripDurationLabel => 'Trip Duration';

  @override
  String get tripDaysLabel => 'days';

  @override
  String get tripSetupDates => 'Set up dates';

  @override
  String get tripDurationRequired => 'Please select your trip dates.';

  @override
  String get tripBudgetTitle => 'Trip Budget';

  @override
  String get tripBudgetSubtitle => 'Set the budget for your adventure';

  @override
  String get tripBudgetLabel => 'Budget';

  @override
  String get tripBudgetHint => '0';

  @override
  String get tripStopsTitle => 'Plan your stops';

  @override
  String get tripStopsSubtitle => 'Add checkpoints along your route';

  @override
  String get tripAddStop => 'Add a stop';

  @override
  String get tripStopsEmpty => 'No stops added yet';

  @override
  String get tripUnnamedStop => 'Unnamed stop';

  @override
  String get tripStepPacking => 'PACKING';

  @override
  String get tripStepChecklist => 'CHECKLIST';

  @override
  String get tripFriendsTitle => 'WHO\'S COMING?';

  @override
  String get tripFriendsSubtitle => 'Invite friends to join your trip';

  @override
  String get tripFriendsSearchHint => 'Invite Friends';

  @override
  String get tripFriendsInvitedTitle => 'Invited Friends';

  @override
  String get tripFriendsSuggestedTitle => 'Suggested Friends';

  @override
  String get tripFriendsSearchResultsTitle => 'Search Results';

  @override
  String get tripFriendsNoFriendsFound => 'No friends found';

  @override
  String get tripYourTrip => 'Your Trip';

  @override
  String get tripLocationFallback => 'Location';

  @override
  String get tripDay => 'DAY';

  @override
  String get tripDays => 'DAYS';

  @override
  String get tripStop => 'STOP';

  @override
  String get tripStops => 'STOPS';

  @override
  String get tripPackingTitle => 'NEED HELP WITH WHAT TO PACK?';

  @override
  String get tripPackingDescription =>
      'Check what you and your friends need to pack!';

  @override
  String get tripEssentials => 'Trip Essentials';

  @override
  String get packingItemsHint => 'List packing items...';

  @override
  String get tripChecklistTitle => 'TRIP CHECKLIST';

  @override
  String get tripChecklistDescription =>
      'Make sure everything is ready for your trip!';

  @override
  String get checklistItemsHint => 'List checklist items...';

  @override
  String get tripSummaryTitle => 'Trip Summary';

  @override
  String get readyButton => 'READY';

  @override
  String get yourTrip => 'YOUR TRIP';

  @override
  String get locationNotSelected => 'Location not selected';

  @override
  String get destination => 'DESTINATION';

  @override
  String get budget => 'BUDGET';

  @override
  String get stops => 'STOPS';

  @override
  String get places => 'Places';

  @override
  String get essentials => 'ESSENTIALS';

  @override
  String get itemsToBePacked => 'Items to be packed';

  @override
  String get routes => 'ROUTES';

  @override
  String get noStopsAdded => 'No stops added';

  @override
  String get unnamedStop => 'Unnamed stop';

  @override
  String get editTripTitle => 'Edit Trip';

  @override
  String get error => 'Error';

  @override
  String get editTripName => 'Trip Name';

  @override
  String get editTripDuration => 'Duration';

  @override
  String get editTripMembers => 'Members';

  @override
  String get editTripStops => 'STOPS';

  @override
  String get editTripPacking => 'Packing Items';

  @override
  String get editTripChecklist => 'Checklist';

  @override
  String get editTripAttachments => 'Attachments';

  @override
  String get editTripStartDate => 'Start Date';

  @override
  String get editTripEndDate => 'End Date';

  @override
  String get editTripSaveChanges => 'SAVE CHANGES';

  @override
  String get editTripNameHint => 'Enter trip name';

  @override
  String get editTripNameRequired => 'Trip name cannot be empty';

  @override
  String get editTripNameUpdated => 'Trip name updated';

  @override
  String get editTripUpdateSuccess => 'Success';

  @override
  String get editTripUpdateFailed => 'Failed to update trip';

  @override
  String get editTripAddItem => 'Add Item';

  @override
  String get editTripAddMember => 'Add Member';

  @override
  String get editTripUploadAttachment => 'Upload Attachment';

  @override
  String get editTripNoMembers => 'No members yet';

  @override
  String get editTripNoAttachments => 'No attachments yet';

  @override
  String get editTripNoPackingItems => 'No packing items yet';

  @override
  String get editTripNoChecklistItems => 'No checklist items yet';

  @override
  String get editTripReorderStops => 'Drag to reorder stops';

  @override
  String get editTripSectionTripName => 'Trip Name';

  @override
  String get editTripSectionDuration => 'Duration';

  @override
  String get editTripSectionMembers => 'Members';

  @override
  String get editTripSectionStops => 'Stops';

  @override
  String get editTripSectionPacking => 'Packing Items';

  @override
  String get editTripSectionChecklist => 'Checklist';

  @override
  String get editTripSectionAttachments => 'Attachments';

  @override
  String get editTripSectionBudget => 'Budget';

  @override
  String get editTripSectionRoutes => 'Routes';

  @override
  String get editTripDetails => 'Trip Details';

  @override
  String get editTripDatesNotSet => 'Dates not set';

  @override
  String get editTripNotSelected => 'Not selected';

  @override
  String get editTripDestination => 'DESTINATION';

  @override
  String get editTripBudget => 'BUDGET';

  @override
  String get editTripFriends => 'FRIENDS';

  @override
  String get editTripDurations => 'DURATIONS';

  @override
  String get editTripEssentials => 'ESSENTIALS';

  @override
  String get editTripItemsToBePacked => 'Items to be packed';

  @override
  String get editTripChecklists => 'CHECKLISTS';

  @override
  String get editTripRoutes => 'ROUTES';

  @override
  String get editTripNoStopsAdded => 'No stops added';

  @override
  String get editTripUnnamedStop => 'Unnamed stop';

  @override
  String get editTripItem => 'Item';

  @override
  String get editTripItems => 'Items';

  @override
  String get editTripToBePrepared => 'to be prepared';

  @override
  String get createClub => 'Create Club';

  @override
  String get clubNameLabel => 'CLUB NAME';

  @override
  String get clubNameHint => 'Enter club name';

  @override
  String get clubDescriptionLabel => 'CLUB DESCRIPTION';

  @override
  String get searchForClub => 'Search for Club';

  @override
  String get clubInvitations => 'Invitations';

  @override
  String get clubMembers => 'Members';

  @override
  String get clubOverview => 'Overview';

  @override
  String get exploreClubs => 'Explore Clubs';

  @override
  String get publicLabel => 'Public';

  @override
  String get privateLabel => 'Private';

  @override
  String get selectPrivacy => 'Select Privacy';

  @override
  String get requiredField => 'Required';

  @override
  String get pleaseEnterClubName => 'Please enter a club name';

  @override
  String get myFriends => 'My Friends';

  @override
  String get myRequests => 'My Requests';

  @override
  String get suggestionsTab => 'Suggestions';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get noFriendsYetSub => 'People you add will appear here.';

  @override
  String get noFriendRequests => 'No friend requests';

  @override
  String get noFriendRequestsSub =>
      'When someone sends you a request, it will show up here.';

  @override
  String get noRequestsSent => 'No requests sent';

  @override
  String get noRequestsSentSub => 'Friend requests you send will appear here.';

  @override
  String get noSuggestionsFound => 'No suggestions found';

  @override
  String get noSuggestionsFoundSub =>
      'We do not have anyone to suggest right now.';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get nothingMatchesSearch => 'Nothing matches your search.';

  @override
  String get workoutChallenge => 'Workout Challenge';

  @override
  String get filterChallenges => 'Filter Challenges';

  @override
  String get allFilter => 'All';

  @override
  String get noChallengesFound => 'No challenges found';

  @override
  String get workoutHistory => 'Workout History';

  @override
  String get noWorkoutsYet => 'No workouts yet';

  @override
  String get noWorkoutsYetSub => 'Finish a run or workout to see it here.';

  @override
  String get noWorkoutSessionsYet => 'No workout sessions yet';

  @override
  String get noWorkoutSessionsYetSub =>
      'Complete a run or push-up workout to see it here!';

  @override
  String get tryAgain => 'Try again';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get challengeAction => 'Challenge';

  @override
  String get fitnessClubAction => 'Fitness Club';

  @override
  String get historyTitle => 'History';

  @override
  String get noActivityYet => 'No activity yet';

  @override
  String get noActivityYetSub => 'Updates for this task will appear here.';

  @override
  String get retry => 'Retry';

  @override
  String get noNotificationsSub =>
      'When something happens, you will see it here.';

  @override
  String get endWorkout => 'End Workout?';

  @override
  String get endWorkoutConfirm => 'Your progress will be saved.';

  @override
  String get keepGoing => 'Keep Going';

  @override
  String get exitRun => 'Exit Run?';

  @override
  String get exitRunConfirm => 'Your run progress will be saved.';

  @override
  String get unfriend => 'Unfriend';

  @override
  String get newsFeed => 'News Feed';

  @override
  String get feedEmptySub =>
      'Workouts and updates from your circle will show up here.';

  @override
  String get writeAComment => 'Write a comment';

  @override
  String get joinClub => 'Join Club';

  @override
  String get joinClubSub => 'Find an active club';

  @override
  String get createClubSub => 'Create your own community';

  @override
  String get noClubsFound => 'No clubs found';

  @override
  String get noClubsAvailable => 'No clubs yet';

  @override
  String get noClubsAvailableSub =>
      'Create a club or look around to find friends to train with.';

  @override
  String get yourClubs => 'Your Clubs';

  @override
  String get discoverClubs => 'Discover Clubs';

  @override
  String get exploreAll => 'Explore all';

  @override
  String get beFirstClub => 'Be the first to start a club!';

  @override
  String get haventJoinedClubs => 'You haven\'t joined a club yet';

  @override
  String get haventJoinedClubsSub =>
      'Join a club or start your own to train together.';

  @override
  String get noClubInvitations => 'No club invitations';

  @override
  String get noClubInvitationsSub =>
      'Invites to join a club will show up here.';

  @override
  String get noJoinRequests => 'No join requests';

  @override
  String get noJoinRequestsSub =>
      'When someone asks to join your club, you\'ll see it here.';

  @override
  String get noMembersYet => 'No members yet';

  @override
  String get inviteToGrowClub => 'Invite friends to grow this club.';

  @override
  String get noCompletedChallenges => 'No finished challenges yet';

  @override
  String get createChallenge => 'Create Challenge';

  @override
  String get pleaseEnterChallengeName => 'Please enter a challenge name.';

  @override
  String get endDateAfterStart => 'End date must be after the start date.';

  @override
  String get achievementsBadges => 'Achievements';

  @override
  String get noAchievementsFound => 'No achievements yet';

  @override
  String get noAchievementsYet => 'No achievements yet';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noMutuals => 'No mutual friends';

  @override
  String get invitation => 'Invitation';

  @override
  String get invitationsLabel => 'INVITATIONS';

  @override
  String get noInvitations => 'No invitations';

  @override
  String get noInvitationsSub =>
      'Task invitations you receive will show up here.';

  @override
  String get noFriendsFoundInvite => 'No friends found';

  @override
  String get addFriendsThenInvite =>
      'Add friends first, then invite them to this club.';

  @override
  String get createButton => 'Create';

  @override
  String get success => 'Done';

  @override
  String get errorTitle => 'Oops';

  @override
  String get taskTitleEmpty => 'Please name your task.';

  @override
  String get taskCreatedSuccess => 'Task created!';

  @override
  String get taskUpdatedSuccess => 'Task updated!';

  @override
  String get labelCreatedSuccess => 'Label created!';

  @override
  String get cannotEditAfterDeadline =>
      'This task can\'t be changed after the deadline.';

  @override
  String get noLabelsAvailable => 'No labels yet.';

  @override
  String get taskMarkedComplete => 'Nice! Task marked complete.';

  @override
  String get pleaseEnterHeight => 'Please enter your height.';

  @override
  String get pleaseEnterWeight => 'Please enter your weight.';

  @override
  String get profileUpdated => 'Profile saved.';

  @override
  String get enterHeightRange => 'Enter height in cm (50–300).';

  @override
  String get enterWeightRange => 'Enter weight in kg (20–500).';

  @override
  String get swipeToStart => 'Swipe to start';

  @override
  String get mainGoalQuestion => 'What\'s your main goal?';

  @override
  String get targetWeightQuestion => 'What\'s your target weight?';

  @override
  String get targetDateQuestion => 'What\'s your target date?';

  @override
  String get workoutLevelQuestion => 'Which workout level feels right?';

  @override
  String get fitnessAssessment => 'Fitness check';

  @override
  String get pleaseSelectMainGoal => 'Please pick a main goal.';

  @override
  String get pleaseEnterTargetWeight => 'Please enter a target weight.';

  @override
  String get pleaseSelectFutureDate => 'Please pick a future date.';

  @override
  String get pleaseSelectWorkoutLevel => 'Please pick a workout level.';

  @override
  String get locationRequired => 'We need location to track your run.';

  @override
  String get enableLocation => 'Please turn on location services.';

  @override
  String get alreadyMember => 'Already in this task.';

  @override
  String get alreadyInvited => 'Already invited.';

  @override
  String get noSoloChallenges => 'No solo challenges right now';

  @override
  String get anyoneCanJoin => 'Anyone can find and join this club';

  @override
  String get requiresInvite => 'Needs an invite to join';

  @override
  String get searchClubsHint => 'Search clubs by name...';

  @override
  String get movemClubs => 'MoveM Clubs';

  @override
  String get clubInvitationsTitle => 'Club Invitations';

  @override
  String get noClubChallenges => 'No club challenges yet';

  @override
  String get createOneToStart => 'Create one to get started.';

  @override
  String get noMembersJoined => 'No members have joined yet';

  @override
  String get endSessionBody => 'Want to stop and see your summary?';

  @override
  String get exitRunBody => 'Your run will be paused. Leave now?';

  @override
  String get kgUnit => 'kg';

  @override
  String get lbsUnit => 'lbs';

  @override
  String get join => 'Join';

  @override
  String get requestJoin => 'Request';

  @override
  String get next => 'Next';

  @override
  String get submit => 'Submit';

  @override
  String get invited => 'Invited';

  @override
  String get joinedTitle => 'You\'re in!';

  @override
  String get requestSentTitle => 'Request sent';

  @override
  String get savedTitle => 'Saved';

  @override
  String get removedTitle => 'Removed';

  @override
  String clubCreatedMsg(String name) {
    return 'Club \"$name\" is ready!';
  }

  @override
  String challengeCreatedMsg(String name) {
    return 'Challenge \"$name\" is ready!';
  }

  @override
  String joinedClubMsg(String name) {
    return 'You\'re now in $name';
  }

  @override
  String joinRequestSentMsg(String name) {
    return 'Your request to join $name is waiting.';
  }

  @override
  String get failedToCreateClub => 'Couldn\'t create the club. Try again.';

  @override
  String get failedToJoinClub => 'Couldn\'t join the club. Try again.';

  @override
  String get failedToSubmitJoinRequest =>
      'Couldn\'t send the join request. Try again.';

  @override
  String get failedToCreateChallenge =>
      'Couldn\'t create the challenge. Try again.';

  @override
  String get failedToRemoveMember => 'Couldn\'t remove this member.';

  @override
  String get couldNotApproveRequest => 'Couldn\'t approve that request.';

  @override
  String get couldNotRejectRequest => 'Couldn\'t reject that request.';

  @override
  String get couldNotCancelRequest => 'Couldn\'t cancel that request.';

  @override
  String enterTargetInUnit(String unit) {
    return 'Enter a target in $unit.';
  }

  @override
  String get loadingChallenges => 'Loading challenges...';

  @override
  String membersCount(int count) {
    return 'Members ($count)';
  }

  @override
  String get completedChallengesLabel => 'Completed challenges';

  @override
  String get viewAllArrow => 'View all >>';

  @override
  String get heightLabel => 'Height';

  @override
  String get weightLabel => 'Weight';

  @override
  String get challengeNameTitle => 'Challenge name';

  @override
  String get datesTitle => 'Dates';

  @override
  String get targetTitle => 'Target';

  @override
  String get failedToSaveProfile => 'Couldn\'t save your profile. Try again.';

  @override
  String get failedToUpdateProfile =>
      'Couldn\'t update your profile. Try again.';

  @override
  String get invalidHeight =>
      'Please enter a valid height in cm (for example 170).';

  @override
  String get invalidWeight =>
      'Please enter a valid weight in kg (for example 65).';

  @override
  String get goalSetSuccess => 'Your goal is saved!';

  @override
  String get failedToSetGoal => 'Couldn\'t set your goal. Try again.';

  @override
  String get permissionDeniedTitle => 'Permission needed';

  @override
  String get serviceDisabledTitle => 'Location is off';

  @override
  String get noTaskData => 'No task data found.';

  @override
  String get updateFailedTitle => 'Couldn\'t update';

  @override
  String get unexpectedError => 'Something went wrong. Try again.';

  @override
  String get copiedProfileLink => 'Profile link copied';

  @override
  String get unableToCancelFriendRequest =>
      'Couldn\'t cancel that request. Try later.';

  @override
  String get failedToSendComment => 'Couldn\'t post that comment right now.';

  @override
  String get alreadyMemberTitle => 'Already a member';

  @override
  String get alreadyInvitedTitle => 'Already invited';

  @override
  String membersAdded(int count, String name) {
    return '$count added to $name.';
  }

  @override
  String get couldNotAddMembers => 'Couldn\'t add members. Try again.';

  @override
  String get removeMemberTitle => 'Remove member';

  @override
  String removeMemberConfirm(String name, String club) {
    return 'Remove $name from $club?';
  }

  @override
  String get thisMember => 'this member';

  @override
  String memberRemoved(String name, String club) {
    return '$name was removed from $club.';
  }

  @override
  String youJoinedChallenge(String name) {
    return 'You\'re in $name.';
  }

  @override
  String get failedToJoinChallenge => 'Couldn\'t join this challenge.';

  @override
  String get membersJoinedLabel => 'Members joined';

  @override
  String get addFriendsForTask =>
      'Add friends so you can invite them to this task.';

  @override
  String get loseWeightGoal => 'Lose weight';

  @override
  String get buildMuscleGoal => 'Build muscle';

  @override
  String get keepFitGoal => 'Keep fit';

  @override
  String get noviceLevel => 'Just starting';

  @override
  String get noviceLevelSub =>
      'Small steps, big changes. Perfect if you\'re new to fitness.';

  @override
  String get intermediateLevel => 'A little experience';

  @override
  String get intermediateLevelSub =>
      'You know the basics. Great if you exercise now and then.';

  @override
  String get advancedLevel => 'Fitness fan';

  @override
  String get advancedLevelSub => 'Push yourself. For people who train often.';

  @override
  String get requestsLabel => 'REQUESTS';

  @override
  String youRequestedJoin(String name) {
    return 'You asked to join $name';
  }

  @override
  String get aClub => 'a club';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get createTaskToStart => 'Create a task to get started.';

  @override
  String get goals => 'Goals';

  @override
  String get history => 'History';

  @override
  String get profileAndGoal => 'PROFILE & GOAL';

  @override
  String get editFitnessProfile => 'Edit Fitness Profile >>';

  @override
  String get editFitnessGoal => 'Edit Fitness Goal >>';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get currentHeight => 'Current Height';

  @override
  String get fitnessLevel => 'Fitness Level';

  @override
  String get targetDateLabel => 'Target Date';

  @override
  String get targetWeightLabel => 'Target Weight';

  @override
  String get noneValue => 'None';

  @override
  String get notClubMember => 'Join this club first to create a challenge.';
}
