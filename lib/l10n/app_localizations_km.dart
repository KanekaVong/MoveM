// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get appTitle => 'MoveM';

  @override
  String get login => 'ចូលប្រើ';

  @override
  String get logout => 'ចាកចេញ';

  @override
  String get email => 'អ៊ីមែល';

  @override
  String get password => 'ពាក្យសម្ងាត់';

  @override
  String get home => 'ទំព័រដើម';

  @override
  String get task => 'កិច្ចការ';

  @override
  String get fitness => 'ហាត់ប្រាណ';

  @override
  String get trip => 'ដំណើរកម្សាន្ត';

  @override
  String get settings => 'ការកំណត់';

  @override
  String get welcome => 'សូមស្វាគមន៍!';

  @override
  String get gender => 'ភេទ';

  @override
  String welcomeUser(String name) {
    return 'សូមស្វាគមន៍, $name!';
  }

  @override
  String get cancel => 'បោះបង់';

  @override
  String get done => 'រួចរាល់';

  @override
  String get save => 'រក្សាទុក';

  @override
  String get edit => 'កែសម្រួល';

  @override
  String get delete => 'លុប';

  @override
  String get search => 'ស្វែងរក';

  @override
  String get viewAll => 'មើលទាំងអស់';

  @override
  String get confirm => 'បញ្ជាក់';

  @override
  String get back => 'ត្រឡប់ក្រោយ';

  @override
  String get invite => 'អញ្ជើញ';

  @override
  String get start => 'ចាប់ផ្ដើម';

  @override
  String get pause => 'ផ្អាក';

  @override
  String get resume => 'បន្ត';

  @override
  String get finish => 'បញ្ចប់';

  @override
  String get accept => 'ទទួលយក';

  @override
  String get reject => 'បដិសេធ';

  @override
  String get addFriend => 'បន្ថែមជាមិត្ត';

  @override
  String get remove => 'ដកចេញ';

  @override
  String get welcomeBack => 'ស្វាគមន៍ការត្រឡប់មកវិញ!';

  @override
  String get emailOrPhone => 'អ៊ីមែល ឬ លេខទូរសព្ទ';

  @override
  String get username => 'ឈ្មោះគណនី';

  @override
  String get firstName => 'នាម';

  @override
  String get lastName => 'នាមត្រកូល';

  @override
  String get confirmPassword => 'បញ្ជាក់ពាក្យសម្ងាត់';

  @override
  String get loginBtn => 'ចូលប្រើ';

  @override
  String get registerBtn => 'ចុះឈ្មោះ';

  @override
  String get createAccountTitle => 'បង្កើតគណនីថ្មី';

  @override
  String get verifyOtpTitle => 'ផ្ទៀងផ្ទាត់លេខកូដ';

  @override
  String get otpCodeLabel => 'លេខកូដ ៦ ខ្ទង់';

  @override
  String get resendCode => 'ផ្ញើលេខកូដម្ដងទៀត';

  @override
  String get verifyBtn => 'ផ្ទៀងផ្ទាត់';

  @override
  String get resetPasswordTitle => 'កំណត់ពាក្យសម្ងាត់ថ្មី';

  @override
  String get newPassword => 'ពាក្យសម្ងាត់ថ្មី';

  @override
  String get savePasswordBtn => 'រក្សាទុកពាក្យសម្ងាត់';

  @override
  String get forgotPasswordQuestion => 'ភ្លេចពាក្យសម្ងាត់?';

  @override
  String get welcomeBackTitle => 'ស្វាគមន៍ការត្រឡប់មកវិញ';

  @override
  String get emailPhoneHint => 'អ៊ីមែល/លេខទូរសព្ទ';

  @override
  String get usernameHint => 'ឈ្មោះគណនី';

  @override
  String get setUsernameHint => 'កំណត់ឈ្មោះគណនី';

  @override
  String get enterPasswordHint => 'បញ្ចូលពាក្យសម្ងាត់';

  @override
  String get setPasswordHint => 'កំណត់ពាក្យសម្ងាត់';

  @override
  String get retypePasswordLabel => 'វាយពាក្យសម្ងាត់ម្តងទៀត';

  @override
  String get retypePasswordHint => 'វាយពាក្យសម្ងាត់ម្តងទៀត';

  @override
  String get registerAction => 'ចុះឈ្មោះ';

  @override
  String get loginAction => 'ចូលប្រើ';

  @override
  String get noAccountSignUp => 'មិនទាន់មានគណនីមែនទេ? ចុះឈ្មោះ';

  @override
  String get haveAccountSignIn => 'មានគណនីរួចហើយមែនទេ? ចូលប្រើ';

  @override
  String get passwordsDoNotMatch => 'ពាក្យសម្ងាត់មិនដូចគ្នាទេ។';

  @override
  String get otpCodeHint => 'បញ្ចូលលេខកូដ ៦ ខ្ទង់';

  @override
  String otpSentTo(String identifier) {
    return 'បញ្ចូលលេខកូដដែលយើងបានផ្ញើទៅ\n$identifier';
  }

  @override
  String get verifyAction => 'ផ្ទៀងផ្ទាត់';

  @override
  String get emailHint => 'បញ្ចូលអ៊ីមែលរបស់អ្នក';

  @override
  String get newPasswordHint => 'បញ្ចូលពាក្យសម្ងាត់ថ្មី';

  @override
  String get sendOtp => 'ផ្ញើ OTP';

  @override
  String get savePasswordAction => 'រក្សាទុកពាក្យសម្ងាត់';

  @override
  String get fillAllFields => 'សូមបំពេញព័ត៌មានទាំងអស់។';

  @override
  String get greetings => 'សួស្ដី';

  @override
  String get stayActiveToday => 'សូមរក្សាភាពសកម្មថ្ងៃនេះ!';

  @override
  String get todayProgress => 'វឌ្ឍនភាពថ្ងៃនេះ';

  @override
  String get ongoingTasks => 'កិច្ចការកំពុងធ្វើ';

  @override
  String get upcoming => 'កិច្ចការបន្ទាប់';

  @override
  String get reminders => 'ការរំលឹក';

  @override
  String get weeklyStats => 'ស្ថិតិប្រចាំសប្ដាហ៍';

  @override
  String get allTasks => 'កិច្ចការទាំងអស់';

  @override
  String get createTask => 'បង្កើតកិច្ចការ';

  @override
  String get editTask => 'កែសម្រួលកិច្ចការ';

  @override
  String get taskDetails => 'ព័ត៌មានលម្អិតកិច្ចការ';

  @override
  String get addCollaborator => 'អញ្ជើញមិត្ត';

  @override
  String get taskTitleLabel => 'ឈ្មោះកិច្ចការ';

  @override
  String get taskTitleHint => 'ដាក់ឈ្មោះការងាររបស់អ្នក...';

  @override
  String get descriptionLabel => 'ការពិពណ៌នា';

  @override
  String get descriptionHint => 'សរសេរកំណត់ចំណាំបន្ថែម...';

  @override
  String get deadlineLabel => 'កាលបរិច្ឆេទកំណត់';

  @override
  String get priorityLabel => 'កម្រិតអាទិភាព';

  @override
  String get labelsLabel => 'ស្លាកសម្គាល់';

  @override
  String get collaboratorsLabel => 'មិត្តចូលរួម';

  @override
  String get checklistLabel => 'បញ្ជីការងារ';

  @override
  String get addChecklistItem => 'បន្ថែមចំណុច';

  @override
  String get completedTasks => 'កិច្ចការបានបញ្ចប់';

  @override
  String get suggested => 'បានណែនាំ';

  @override
  String get inviteCollaborators => 'អញ្ជើញមិត្តចូលរួម';

  @override
  String get searchCollaboratorsHint => 'ស្វែងរកមិត្តភក្តិតាមឈ្មោះ...';

  @override
  String get friends => 'មិត្តភក្តិ';

  @override
  String get addFriends => 'បន្ថែមមិត្តភក្តិ';

  @override
  String get friendRequests => 'សំណើមិត្តភក្តិ';

  @override
  String get friendSuggestions => 'ការណែនាំមិត្តភក្តិ';

  @override
  String get shareYourProfile => 'ចែករំលែកប្រវត្តិរូបរបស់អ្នក';

  @override
  String get scanQrCode => 'ស្កេន QR Code';

  @override
  String get scanQrCodeSub => 'ស្កេន QR Code របស់មិត្តភក្តិ';

  @override
  String get inviteFriendsViaLink => 'អញ្ជើញមិត្តភក្តិ';

  @override
  String get inviteFriendsViaLinkSub => 'អញ្ជើញមិត្តភក្តិតាមរយៈតំណភ្ជាប់';

  @override
  String get myQrCode => 'QR Code របស់ខ្ញុំ';

  @override
  String get saveQr => 'រក្សាទុក';

  @override
  String get shareQr => 'ចែករំលែក';

  @override
  String get qrSavedToast => 'QR Code បានរក្សាទុក';

  @override
  String get scanToConnect => 'ស្កេនដើម្បីភ្ជាប់ទំនាក់ទំនងជាមួយខ្ញុំនៅលើ MoveM';

  @override
  String get cameraStarting => 'កំពុងដំណើរការកាមេរ៉ា...';

  @override
  String get alignQrHint => 'ដាក់កាមេរ៉ាឱ្យចំ QR Code ដើម្បីស្កេន';

  @override
  String get userFound => 'បានរកឃើញមិត្តភក្តិ';

  @override
  String get movemClub => 'ក្លឹប MoveM';

  @override
  String get soloChallenges => 'ហាត់តែឯង';

  @override
  String get groupActivity => 'ហាត់ជាក្រុម';

  @override
  String get yourGoal => 'គោលដៅរបស់អ្នក';

  @override
  String get liveTracking => 'កំពុងរត់';

  @override
  String get runSummary => 'សង្ខេបការរត់';

  @override
  String get runHistory => 'ប្រវត្តិការរត់';

  @override
  String get runDetails => 'ព័ត៌មានលម្អិតការរត់';

  @override
  String get pushUpWorkout => 'ហាត់ឡើងចុះ';

  @override
  String get workoutDetails => 'ព័ត៌មានលម្អិតការហាត់';

  @override
  String get createActivity => 'បង្កើតសកម្មភាព';

  @override
  String get createGroup => 'បង្កើតក្រុម';

  @override
  String get invitePeople => 'អញ្ជើញមិត្ត';

  @override
  String get setupGoal => 'កំណត់គោលដៅ';

  @override
  String get activityNameLabel => 'ឈ្មោះសកម្មភាព';

  @override
  String get groupNameLabel => 'ឈ្មោះក្រុម';

  @override
  String get distanceKm => 'ចម្ងាយ (គ.ម)';

  @override
  String get avgPace => 'ល្បឿនមធ្យម';

  @override
  String get duration => 'រយៈពេល';

  @override
  String get caloriesBurned => 'កាឡូរី';

  @override
  String get setLabel => 'ឈុត';

  @override
  String get repsLabel => 'ចំនួនដង';

  @override
  String get tapToCount => 'ប៉ះអេក្រង់ដើម្បីរាប់';

  @override
  String get greatJobWorkout => 'អស្ចារ្យ! អ្នកហាត់រួចហើយ';

  @override
  String get tripsMap => 'ផែនទីដំណើរកម្សាន្ត';

  @override
  String get notifications => 'ការជូនដំណឹង';

  @override
  String get noNotifications => 'មិនទាន់មានការជូនដំណឹងនៅឡើយទេ';

  @override
  String get accountSection => 'គណនី';

  @override
  String get preferencesSection => 'ចំណូលចិត្ត';

  @override
  String get sessionsSection => 'សុវត្ថិភាព & វគ្គប្រើប្រាស់';

  @override
  String get yourProfile => 'ប្រវត្តិរូបរបស់អ្នក';

  @override
  String get changePassword => 'ផ្លាស់ប្តូរពាក្យសម្ងាត់';

  @override
  String get appearances => 'រូបរាង';

  @override
  String get darkLightTheme => 'ងងឹត/ភ្លឺ';

  @override
  String get languages => 'ភាសា';

  @override
  String get privacy => 'ភាពឯកជន';

  @override
  String get deleteAccount => 'លុបគណនីរបស់អ្នក';

  @override
  String get logOut => 'ចាកចេញពីគណនី';

  @override
  String get editProfile => 'កែប្រែប្រវត្តិរូប';

  @override
  String get personalInfo => 'ព័ត៌មានផ្ទាល់ខ្លួន';

  @override
  String get myActivities => 'សកម្មភាពរបស់ខ្ញុំ';

  @override
  String get achievements => 'សមិទ្ធផលទទួលបាន';

  @override
  String get selectLanguage => 'ជ្រើសរើសភាសា';

  @override
  String get languageEnglish => 'English (English)';

  @override
  String get languageKhmer => 'ភាសាខ្មែរ (Khmer)';

  @override
  String get inviteFriends => 'អញ្ជើញមិត្តភក្តិ';

  @override
  String get yourInviteLink => 'តំណភ្ជាប់អញ្ជើញរបស់អ្នក';

  @override
  String get yourToken => 'កូដអញ្ជើញរបស់អ្នក';

  @override
  String get shareVia => 'ចែករំលែកតាមរយៈ';

  @override
  String get inviteLinkCopied => 'បានចម្លងតំណភ្ជាប់អញ្ជើញរួចរាល់';

  @override
  String get inviteTokenCopied => 'បានចម្លងកូដអញ្ជើញរួចរាល់';

  @override
  String get copied => 'បានចម្លង';

  @override
  String get comments => 'មតិយោបល់';

  @override
  String get writeComment => 'សរសេរមតិយោបល់...';

  @override
  String get editComment => 'កែប្រែមតិ';

  @override
  String get editingComment => 'កំពុងកែសម្រួលមតិ';

  @override
  String get editYourComment => 'កែសម្រួលមតិរបស់អ្នក...';

  @override
  String get deleteComment => 'លុបមតិ';

  @override
  String get deleteCommentConfirm =>
      'តើអ្នកច្បាស់ទេថាចង់លុបមតិយោបល់នេះ? សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ។';

  @override
  String get copyText => 'ចម្លងអត្ថបទ';

  @override
  String get noCommentsYet => 'មិនទាន់មានមតិយោបល់នៅឡើយទេ';

  @override
  String get today => 'ថ្ងៃនេះ';

  @override
  String get yesterday => 'ម្សិលមិញ';

  @override
  String get searchResults => 'លទ្ធផលស្វែងរក';

  @override
  String get loading => 'កំពុងដំណើរការ...';

  @override
  String get beTheFirstToComment =>
      'ចូលរួមបញ្ចេញមតិយោបល់ដំបូងគេ ឬ សួរសំណួរអំពីកិច្ចការនេះ';

  @override
  String get commentCopiedToast => 'បានចម្លងមតិយោបល់រួចរាល់';

  @override
  String get edited => 'បានកែប្រែ';

  @override
  String get deleteTask => 'លុបកិច្ចការ';

  @override
  String get deleteTaskConfirm =>
      'តើអ្នកចង់លុបកិច្ចការនេះមែនទេ? មិនអាចត្រឡប់វិញបានទេ។';

  @override
  String get taskDeletedSuccess => 'បានលុបកិច្ចការហើយ';

  @override
  String get createNewTrip => 'បង្កើតដំណើរកម្សាន្តថ្មី';

  @override
  String get tripStepName => 'ឈ្មោះ';

  @override
  String get tripStepLocation => 'ទីតាំង';

  @override
  String get tripStepDuration => 'រយៈពេល';

  @override
  String get tripStepStops => 'ចំណត';

  @override
  String get tripStepFriends => 'មិត្តភក្តិ';

  @override
  String get continueButton => 'បន្ត';

  @override
  String get tripNameLabel => 'ឈ្មោះដំណើរកម្សាន្ត';

  @override
  String get tripNameHint => 'បញ្ចូលឈ្មោះដំណើរកម្សាន្តរបស់អ្នក...';

  @override
  String get tripNameRequired => 'សូមបញ្ចូលឈ្មោះដំណើរកម្សាន្តរបស់អ្នក។';

  @override
  String get tripNameTitle => 'តើដំណើរកម្សាន្តនេះមានឈ្មោះអ្វី?';

  @override
  String get tripNameSubtitle => 'ដាក់ឈ្មោះឱ្យដំណើរផ្សងព្រេងរបស់អ្នក';

  @override
  String get tripLocationTitle => 'តើអ្នកកំពុងទៅណា?';

  @override
  String get tripLocationSubtitle =>
      'ស្វែងរកទីកន្លែង ឬចុចលើផែនទីដើម្បីជ្រើសរើស';

  @override
  String get tripLocationSearchHint => 'ស្វែងរកទីតាំង...';

  @override
  String get tripLocationSelected => 'ទីតាំងដែលបានជ្រើសរើស';

  @override
  String get tripLocationRequired => 'សូមជ្រើសរើសគោលដៅរបស់អ្នក។';

  @override
  String get tripLocationSearchFailed =>
      'មិនអាចស្វែងរកទីតាំងបានទេ។ សូមព្យាយាមម្តងទៀត។';

  @override
  String get tripLocationNotFound => 'រកមិនឃើញទីតាំងទេ។';

  @override
  String get tripLocationPermissionDenied =>
      'ត្រូវការការអនុញ្ញាតទីតាំង ដើម្បីប្រើទីតាំងបច្ចុប្បន្នរបស់អ្នក។';

  @override
  String get tripLocationServiceDisabled => 'សូមបើកសេវាកម្មទីតាំង។';

  @override
  String get tripLocationSearching => 'កំពុងស្វែងរក...';

  @override
  String get tripDurationTitle => 'រយៈពេល និងថវិកា';

  @override
  String get tripDurationSubtitle =>
      'តើត្រូវចំណាយពេលប៉ុន្មាន និងចំណាយប៉ុន្មាន?';

  @override
  String get tripDurationLabel => 'រយៈពេលដំណើរកម្សាន្ត';

  @override
  String get tripDaysLabel => 'ថ្ងៃ';

  @override
  String get tripSetupDates => 'កំណត់កាលបរិច្ឆេទ';

  @override
  String get tripDurationRequired =>
      'សូមជ្រើសរើសកាលបរិច្ឆេទដំណើរកម្សាន្តរបស់អ្នក។';

  @override
  String get tripBudgetTitle => 'ថវិកាដំណើរកម្សាន្ត';

  @override
  String get tripBudgetSubtitle => 'កំណត់ថវិកាសម្រាប់ដំណើរផ្សងព្រេងរបស់អ្នក';

  @override
  String get tripBudgetLabel => 'ថវិកា';

  @override
  String get tripBudgetHint => '0';

  @override
  String get tripStopsTitle => 'រៀបចំចំណតរបស់អ្នក';

  @override
  String get tripStopsSubtitle => 'បន្ថែមចំណតនៅតាមផ្លូវរបស់អ្នក';

  @override
  String get tripAddStop => 'បន្ថែមចំណត';

  @override
  String get tripStopsEmpty => 'មិនទាន់មានចំណតទេ';

  @override
  String get tripUnnamedStop => 'ចំណតគ្មានឈ្មោះ';

  @override
  String get tripStepPacking => 'រៀបចំអីវ៉ាន់';

  @override
  String get tripStepChecklist => 'បញ្ជីត្រួតពិនិត្យ';

  @override
  String get tripFriendsTitle => 'អ្នកណាខ្លះនឹងមក?';

  @override
  String get tripFriendsSubtitle =>
      'អញ្ជើញមិត្តភក្តិឱ្យចូលរួមដំណើរកម្សាន្តរបស់អ្នក';

  @override
  String get tripFriendsSearchHint => 'អញ្ជើញមិត្តភក្តិ';

  @override
  String get tripFriendsInvitedTitle => 'មិត្តភក្តិដែលបានអញ្ជើញ';

  @override
  String get tripFriendsSuggestedTitle => 'មិត្តភក្តិដែលបានណែនាំ';

  @override
  String get tripFriendsSearchResultsTitle => 'លទ្ធផលស្វែងរក';

  @override
  String get tripFriendsNoFriendsFound => 'រកមិនឃើញមិត្តភក្តិទេ';

  @override
  String get tripYourTrip => 'ដំណើរកម្សាន្តរបស់អ្នក';

  @override
  String get tripLocationFallback => 'ទីតាំង';

  @override
  String get tripDay => 'ថ្ងៃ';

  @override
  String get tripDays => 'ថ្ងៃ';

  @override
  String get tripStop => 'ចំណត';

  @override
  String get tripStops => 'ចំណត';

  @override
  String get tripPackingTitle => 'ត្រូវការជំនួយថាតើត្រូវខ្ចប់អ្វីខ្លះ?';

  @override
  String get tripPackingDescription =>
      'ពិនិត្យមើលអ្វីដែលអ្នក និងមិត្តភក្តិរបស់អ្នកត្រូវខ្ចប់!';

  @override
  String get tripEssentials => 'សម្ភារៈចាំបាច់សម្រាប់ដំណើរ';

  @override
  String get packingItemsHint => 'បន្ថែមសម្ភារៈដែលត្រូវខ្ចប់...';

  @override
  String get tripChecklistTitle => 'បញ្ជីត្រួតពិនិត្យដំណើរ';

  @override
  String get tripChecklistDescription =>
      'ត្រូវប្រាកដថាអ្វីៗគ្រប់យ៉ាងត្រូវបានរៀបចំរួចរាល់សម្រាប់ដំណើរកម្សាន្តរបស់អ្នក!';

  @override
  String get checklistItemsHint => 'បន្ថែមកិច្ចការត្រួតពិនិត្យ...';

  @override
  String get tripSummaryTitle => 'សង្ខេបដំណើរ';

  @override
  String get readyButton => 'រួចរាល់';

  @override
  String get yourTrip => 'ដំណើររបស់អ្នក';

  @override
  String get locationNotSelected => 'មិនទាន់ជ្រើសរើសទីតាំង';

  @override
  String get destination => 'គោលដៅ';

  @override
  String get budget => 'ថវិកា';

  @override
  String get stops => 'ចំណត';

  @override
  String get places => 'កន្លែង';

  @override
  String get essentials => 'របស់ចាំបាច់';

  @override
  String get itemsToBePacked => 'របស់ដែលត្រូវវេចខ្ចប់';

  @override
  String get routes => 'ផ្លូវធ្វើដំណើរ';

  @override
  String get noStopsAdded => 'មិនទាន់បានបន្ថែមចំណត';

  @override
  String get unnamedStop => 'ចំណតមិនទាន់មានឈ្មោះ';

  @override
  String get editTripTitle => 'កែសម្រួលការធ្វើដំណើរ';

  @override
  String get error => 'កំហុស';

  @override
  String get editTripName => 'ឈ្មោះការធ្វើដំណើរ';

  @override
  String get editTripDuration => 'រយៈពេល';

  @override
  String get editTripMembers => 'សមាជិក';

  @override
  String get editTripStops => 'ចំណត';

  @override
  String get editTripPacking => 'របស់ត្រូវយក';

  @override
  String get editTripChecklist => 'បញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripAttachments => 'ឯកសារភ្ជាប់';

  @override
  String get editTripStartDate => 'ថ្ងៃចាប់ផ្តើម';

  @override
  String get editTripEndDate => 'ថ្ងៃបញ្ចប់';

  @override
  String get editTripSaveChanges => 'រក្សាទុកការផ្លាស់ប្តូរ';

  @override
  String get editTripNameHint => 'បញ្ចូលឈ្មោះការធ្វើដំណើរ';

  @override
  String get editTripNameRequired => 'ឈ្មោះការធ្វើដំណើរមិនអាចទទេបានទេ';

  @override
  String get editTripNameUpdated => 'បានធ្វើបច្ចុប្បន្នភាពឈ្មោះការធ្វើដំណើរ';

  @override
  String get editTripUpdateSuccess => 'ជោគជ័យ';

  @override
  String get editTripUpdateFailed =>
      'បរាជ័យក្នុងការធ្វើបច្ចុប្បន្នភាពការធ្វើដំណើរ';

  @override
  String get editTripAddItem => 'បន្ថែមសម្ភារៈ';

  @override
  String get editTripAddMember => 'បន្ថែមសមាជិក';

  @override
  String get editTripUploadAttachment => 'បង្ហោះឯកសារភ្ជាប់';

  @override
  String get editTripNoMembers => 'មិនទាន់មានសមាជិក';

  @override
  String get editTripNoAttachments => 'មិនទាន់មានឯកសារភ្ជាប់';

  @override
  String get editTripNoPackingItems => 'មិនទាន់មានរបស់ត្រូវយក';

  @override
  String get editTripNoChecklistItems => 'មិនទាន់មានបញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripReorderStops => 'អូសដើម្បីរៀបលំដាប់ចំណត';

  @override
  String get editTripSectionTripName => 'ឈ្មោះការធ្វើដំណើរ';

  @override
  String get editTripSectionDuration => 'រយៈពេល';

  @override
  String get editTripSectionMembers => 'សមាជិក';

  @override
  String get editTripSectionStops => 'ចំណត';

  @override
  String get editTripSectionPacking => 'របស់របរត្រូវវេចខ្ចប់';

  @override
  String get editTripSectionChecklist => 'បញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripSectionAttachments => 'ឯកសារភ្ជាប់';

  @override
  String get editTripSectionBudget => 'ថវិកា';

  @override
  String get editTripSectionRoutes => 'ផ្លូវ';

  @override
  String get editTripDetails => 'ព័ត៌មានដំណើរកម្សាន្ត';

  @override
  String get editTripDatesNotSet => 'មិនបានកំណត់កាលបរិច្ឆេទ';

  @override
  String get editTripNotSelected => 'មិនបានជ្រើសរើស';

  @override
  String get editTripDestination => 'គោលដៅ';

  @override
  String get editTripBudget => 'ថវិកា';

  @override
  String get editTripFriends => 'មិត្តភក្តិ';

  @override
  String get editTripDurations => 'រយៈពេល';

  @override
  String get editTripEssentials => 'របស់ចាំបាច់';

  @override
  String get editTripItemsToBePacked => 'របស់របរត្រូវវេចខ្ចប់';

  @override
  String get editTripChecklists => 'បញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripRoutes => 'ផ្លូវ';

  @override
  String get editTripNoStopsAdded => 'មិនទាន់មានចំណត';

  @override
  String get editTripUnnamedStop => 'ចំណតគ្មានឈ្មោះ';

  @override
  String get editTripItem => 'ធាតុ';

  @override
  String get editTripItems => 'ធាតុ';

  @override
  String get editTripToBePrepared => 'ត្រូវរៀបចំ';

  @override
  String get createClub => 'បង្កើតក្លឹប';

  @override
  String get clubNameLabel => 'ឈ្មោះក្លឹប';

  @override
  String get clubNameHint => 'បញ្ចូលឈ្មោះក្លឹប';

  @override
  String get clubDescriptionLabel => 'ការពិពណ៌នាក្លឹប';

  @override
  String get searchForClub => 'ស្វែងរកក្លឹប';

  @override
  String get clubInvitations => 'ការអញ្ជើញ';

  @override
  String get clubMembers => 'សមាជិក';

  @override
  String get clubOverview => 'ទិដ្ឋភាពទូទៅ';

  @override
  String get exploreClubs => 'រកមើលក្លឹប';

  @override
  String get publicLabel => 'សាធារណៈ';

  @override
  String get privateLabel => 'ឯកជន';

  @override
  String get selectPrivacy => 'ជ្រើសរើសភាពឯកជន';

  @override
  String get requiredField => 'សូមបំពេញ';

  @override
  String get pleaseEnterClubName => 'សូមបញ្ចូលឈ្មោះក្លឹប';

  @override
  String get myFriends => 'មិត្តភក្តិខ្ញុំ';

  @override
  String get myRequests => 'សំណើរបស់ខ្ញុំ';

  @override
  String get suggestionsTab => 'ការណែនាំ';

  @override
  String get noFriendsYet => 'មិនទាន់មានមិត្តភក្តិនៅឡើយទេ';

  @override
  String get noFriendsYetSub => 'មនុស្សដែលអ្នកបន្ថែមនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noFriendRequests => 'មិនមានសំណើមិត្តភក្តិទេ';

  @override
  String get noFriendRequestsSub =>
      'ពេលមានគេផ្ញើសំណើមកអ្នក វានឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noRequestsSent => 'មិនទាន់បានផ្ញើសំណើទេ';

  @override
  String get noRequestsSentSub => 'សំណើមិត្តភក្តិដែលអ្នកផ្ញើនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noSuggestionsFound => 'រកមិនឃើញការណែនាំទេ';

  @override
  String get noSuggestionsFoundSub =>
      'បច្ចុប្បន្នមិនមាននរណាម្នាក់ដើម្បីណែនាំទេ។';

  @override
  String get noUsersFound => 'រកមិនឃើញមិត្តទេ';

  @override
  String get nothingMatchesSearch => 'គ្មានអ្វីត្រូវនឹងការស្វែងរករបស់អ្នកទេ។';

  @override
  String get workoutChallenge => 'ការហាត់ប្រកួត';

  @override
  String get filterChallenges => 'ជ្រើសប្រភេទ';

  @override
  String get allFilter => 'ទាំងអស់';

  @override
  String get noChallengesFound => 'រកមិនឃើញការប្រកួតទេ';

  @override
  String get workoutHistory => 'ប្រវត្តិការហាត់';

  @override
  String get noWorkoutsYet => 'មិនទាន់មានការហាត់នៅឡើយទេ';

  @override
  String get noWorkoutsYetSub => 'បញ្ចប់ការរត់ ឬការហាត់ដើម្បីមើលនៅទីនេះ។';

  @override
  String get noWorkoutSessionsYet => 'មិនទាន់មានវគ្គហាត់នៅឡើយទេ';

  @override
  String get noWorkoutSessionsYetSub =>
      'បញ្ចប់ការរត់ ឬការហាត់អាវ៉ង់ដើម្បីមើលនៅទីនេះ!';

  @override
  String get tryAgain => 'ព្យាយាមម្តងទៀត';

  @override
  String get quickActions => 'សកម្មភាពរហ័ស';

  @override
  String get challengeAction => 'ហាត់ប្រកួត';

  @override
  String get fitnessClubAction => 'ក្លឹបហាត់ប្រាណ';

  @override
  String get historyTitle => 'ប្រវត្តិ';

  @override
  String get noActivityYet => 'មិនទាន់មានសកម្មភាពនៅឡើយទេ';

  @override
  String get noActivityYetSub => 'បច្ចុប្បន្នភាពនៃកិច្ចការនេះនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get retry => 'ព្យាយាមម្តងទៀត';

  @override
  String get noNotificationsSub => 'ពេលមានអ្វីកើតឡើង អ្នកនឹងឃើញនៅទីនេះ។';

  @override
  String get endWorkout => 'បញ្ចប់ការហាត់?';

  @override
  String get endWorkoutConfirm => 'វឌ្ឍនភាពរបស់អ្នកនឹងត្រូវបានរក្សាទុក។';

  @override
  String get keepGoing => 'បន្តហាត់';

  @override
  String get exitRun => 'ចាកចេញពីការរត់?';

  @override
  String get exitRunConfirm => 'វឌ្ឍនភាពការរត់របស់អ្នកនឹងត្រូវបានរក្សាទុក។';

  @override
  String get unfriend => 'លែងជាមិត្ត';

  @override
  String get newsFeed => 'ព័ត៌មានថ្មី';

  @override
  String get feedEmptySub => 'ការហាត់ និងសកម្មភាពរបស់មិត្តនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get writeAComment => 'សរសេរមតិ';

  @override
  String get joinClub => 'ចូលក្លឹប';

  @override
  String get createClubSub =>
      'បង្កើតសហគមន៍ផ្ទាល់ខ្លួន និងភ្ជាប់ទំនាក់ទំនងជាមួយយើង';

  @override
  String get noClubsFound => 'រកមិនឃើញក្លឹបទេ';

  @override
  String get noClubsAvailable => 'មិនទាន់មានក្លឹបទេ';

  @override
  String get noClubsAvailableSub =>
      'បង្កើតក្លឹប ឬរកមើលក្លឹបដើម្បីហាត់ជាមួយមិត្ត។';

  @override
  String get discoverClubs => 'រកមើលក្លឹប';

  @override
  String get beFirstClub => 'ក្លាយជាអ្នកបង្កើតក្លឹបដំបូង!';

  @override
  String get haventJoinedClubsSub =>
      'ចូលក្លឹប ឬបង្កើតក្លឹបថ្មី ដើម្បីហាត់ជាមួយគ្នា។';

  @override
  String get noClubInvitations => 'មិនមានការអញ្ជើញក្លឹបទេ';

  @override
  String get noClubInvitationsSub =>
      'ពេលមានគេអញ្ជើញអ្នកចូលក្លឹប នឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noJoinRequests => 'មិនមានសំណើចូលក្លឹបទេ';

  @override
  String get noJoinRequestsSub =>
      'ពេលមានគេសុំចូលក្លឹបរបស់អ្នក នឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noMembersYet => 'មិនទាន់មានសមាជិកទេ';

  @override
  String get inviteToGrowClub => 'អញ្ជើញមិត្តដើម្បីពង្រីកក្លឹបនេះ។';

  @override
  String get noCompletedChallenges => 'មិនទាន់មានការហាត់បានបញ្ចប់ទេ';

  @override
  String get createChallenge => 'បង្កើតការហាត់';

  @override
  String get pleaseEnterChallengeName => 'សូមដាក់ឈ្មោះការហាត់។';

  @override
  String get endDateAfterStart => 'ថ្ងៃបញ្ចប់ត្រូវនៅក្រោយថ្ងៃចាប់ផ្ដើម។';

  @override
  String get achievementsBadges => 'សមិទ្ធផល';

  @override
  String get noAchievementsFound => 'មិនទាន់មានសមិទ្ធផលទេ';

  @override
  String get noAchievementsYet => 'មិនទាន់មានសមិទ្ធផលទេ';

  @override
  String get profileTitle => 'ប្រវត្តិរូប';

  @override
  String get noMutuals => 'មិនមានមិត្តរួមទេ';

  @override
  String get invitation => 'ការអញ្ជើញ';

  @override
  String get invitationsLabel => 'ការអញ្ជើញ';

  @override
  String get noInvitations => 'មិនមានការអញ្ជើញទេ';

  @override
  String get noInvitationsSub => 'ការអញ្ជើញកិច្ចការនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get noFriendsFoundInvite => 'រកមិនឃើញមិត្តទេ';

  @override
  String get addFriendsThenInvite => 'បន្ថែមមិត្តសិន រួចអញ្ជើញពួកគេចូលក្លឹប។';

  @override
  String get createButton => 'បង្កើត';

  @override
  String get success => 'រួចរាល់';

  @override
  String get errorTitle => 'អូ៎';

  @override
  String get taskTitleEmpty => 'សូមដាក់ឈ្មោះកិច្ចការ។';

  @override
  String get taskCreatedSuccess => 'បានបង្កើតកិច្ចការហើយ!';

  @override
  String get taskUpdatedSuccess => 'បានកែកិច្ចការហើយ!';

  @override
  String get labelCreatedSuccess => 'បានបង្កើតស្លាកហើយ!';

  @override
  String get cannotEditAfterDeadline =>
      'កិច្ចការនេះមិនអាចកែបានទៀតទេ បន្ទាប់ពីផុតកំណត់។';

  @override
  String get noLabelsAvailable => 'មិនទាន់មានស្លាកទេ។';

  @override
  String get taskMarkedComplete => 'ល្អណាស់! កិច្ចការបានបញ្ចប់។';

  @override
  String get pleaseEnterHeight => 'សូមបញ្ចូលកម្ពស់។';

  @override
  String get pleaseEnterWeight => 'សូមបញ្ចូលទម្ងន់។';

  @override
  String get profileUpdated => 'បានរក្សាទុកប្រវត្តិរូបហើយ។';

  @override
  String get enterHeightRange => 'បញ្ចូលកម្ពស់ជា cm (៥០–៣០០)។';

  @override
  String get enterWeightRange => 'បញ្ចូលទម្ងន់ជា kg (២០–៥០០)។';

  @override
  String get swipeToStart => 'អូសដើម្បីចាប់ផ្ដើម';

  @override
  String get mainGoalQuestion => 'គោលដៅចម្បងរបស់អ្នកគឺអ្វី?';

  @override
  String get targetWeightQuestion => 'ទម្ងន់គោលដៅរបស់អ្នកគឺប៉ុន្មាន?';

  @override
  String get targetDateQuestion => 'ចង់សម្រេចឲ្យបាននៅថ្ងៃណា?';

  @override
  String get workoutLevelQuestion => 'កម្រិតហាត់មួយណាល្មមសម្រាប់អ្នក?';

  @override
  String get fitnessAssessment => 'ពិនិត្យសុខភាព';

  @override
  String get pleaseSelectMainGoal => 'សូមជ្រើសគោលដៅចម្បង។';

  @override
  String get pleaseEnterTargetWeight => 'សូមបញ្ចូលទម្ងន់គោលដៅ។';

  @override
  String get pleaseSelectFutureDate => 'សូមជ្រើសថ្ងៃនៅខាងមុខ។';

  @override
  String get pleaseSelectWorkoutLevel => 'សូមជ្រើសកម្រិតហាត់។';

  @override
  String get locationRequired => 'ត្រូវការទីតាំងដើម្បីតាមដានការរត់។';

  @override
  String get enableLocation => 'សូមបើកសេវាទីតាំង។';

  @override
  String get alreadyMember => 'មិត្តនេះនៅក្នុងកិច្ចការរួចហើយ។';

  @override
  String get alreadyInvited => 'បានអញ្ជើញរួចហើយ។';

  @override
  String get noSoloChallenges => 'មិនទាន់មានការហាត់តែឯងទេ';

  @override
  String get anyoneCanJoin => 'អ្នកណាក៏អាចរកឃើញ និងចូលក្លឹបនេះបាន';

  @override
  String get requiresInvite => 'ត្រូវការការអញ្ជើញដើម្បីចូល';

  @override
  String get searchClubsHint => 'ស្វែងរកក្លឹបតាមឈ្មោះ...';

  @override
  String get movemClubs => 'ក្លឹប MoveM';

  @override
  String get clubInvitationsTitle => 'ការអញ្ជើញក្លឹប';

  @override
  String get noClubChallenges => 'មិនទាន់មានការហាត់ក្នុងក្លឹបទេ';

  @override
  String get createOneToStart => 'បង្កើតមួយដើម្បីចាប់ផ្ដើម។';

  @override
  String get noMembersJoined => 'មិនទាន់មានសមាជិកចូលរួមទេ';

  @override
  String get endSessionBody => 'ចង់ឈប់ ហើយមើលសង្ខេបទេ?';

  @override
  String get exitRunBody => 'ការរត់នឹងត្រូវផ្អាក។ ចង់ចេញឥឡូវទេ?';

  @override
  String get kgUnit => 'kg';

  @override
  String get lbsUnit => 'lbs';

  @override
  String get join => 'ចូល';

  @override
  String get requestJoin => 'សុំចូល';

  @override
  String get next => 'បន្ត';

  @override
  String get submit => 'បញ្ជូន';

  @override
  String get invited => 'បានអញ្ជើញ';

  @override
  String get joinedTitle => 'ចូលហើយ!';

  @override
  String get requestSentTitle => 'បានផ្ញើសំណើ';

  @override
  String get savedTitle => 'បានរក្សាទុក';

  @override
  String get removedTitle => 'បានដកចេញ';

  @override
  String clubCreatedMsg(String name) {
    return 'ក្លឹប \"$name\" រួចរាល់ហើយ!';
  }

  @override
  String challengeCreatedMsg(String name) {
    return 'ការហាត់ \"$name\" រួចរាល់ហើយ!';
  }

  @override
  String joinedClubMsg(String name) {
    return 'អ្នកនៅក្នុង $name ហើយ';
  }

  @override
  String joinRequestSentMsg(String name) {
    return 'សំណើចូល $name កំពុងរង់ចាំ។';
  }

  @override
  String get failedToCreateClub => 'បង្កើតក្លឹបមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get failedToJoinClub => 'ចូលក្លឹបមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get failedToSubmitJoinRequest => 'ផ្ញើសំណើចូលមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get failedToCreateChallenge => 'បង្កើតការហាត់មិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get failedToRemoveMember => 'ដកសមាជិកនេះមិនបានទេ។';

  @override
  String get couldNotApproveRequest => 'យល់ព្រមសំណើនេះមិនបានទេ។';

  @override
  String get couldNotRejectRequest => 'បដិសេធសំណើនេះមិនបានទេ។';

  @override
  String get couldNotCancelRequest => 'បោះបង់សំណើនេះមិនបានទេ។';

  @override
  String enterTargetInUnit(String unit) {
    return 'សូមបញ្ចូលគោលដៅជា $unit។';
  }

  @override
  String get loadingChallenges => 'កំពុងផ្ទុកការហាត់...';

  @override
  String membersCount(int count) {
    return 'សមាជិក ($count)';
  }

  @override
  String get completedChallengesLabel => 'ការហាត់បានបញ្ចប់';

  @override
  String get viewAllArrow => 'មើលទាំងអស់ >>';

  @override
  String get heightLabel => 'កម្ពស់';

  @override
  String get weightLabel => 'ទម្ងន់';

  @override
  String get challengeNameTitle => 'ឈ្មោះការហាត់';

  @override
  String get datesTitle => 'កាលបរិច្ឆេទ';

  @override
  String get targetTitle => 'គោលដៅ';

  @override
  String get failedToSaveProfile => 'រក្សាទុកប្រវត្តិរូបមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get failedToUpdateProfile => 'កែប្រវត្តិរូបមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get invalidHeight => 'សូមបញ្ចូលកម្ពស់ត្រឹមត្រូវជា cm (ឧ. ១៧០)។';

  @override
  String get invalidWeight => 'សូមបញ្ចូលទម្ងន់ត្រឹមត្រូវជា kg (ឧ. ៦៥)។';

  @override
  String get goalSetSuccess => 'បានរក្សាទុកគោលដៅហើយ!';

  @override
  String get failedToSetGoal => 'កំណត់គោលដៅមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get permissionDeniedTitle => 'ត្រូវការការអនុញ្ញាត';

  @override
  String get serviceDisabledTitle => 'ទីតាំងបានបិទ';

  @override
  String get noTaskData => 'រកមិនឃើញទិន្នន័យកិច្ចការទេ។';

  @override
  String get updateFailedTitle => 'កែមិនបាន';

  @override
  String get unexpectedError => 'មានអ្វីមួយខុស។ សាកម្តងទៀត។';

  @override
  String get copiedProfileLink => 'បានចម្លងតំណប្រវត្តិរូប';

  @override
  String get unableToCancelFriendRequest => 'បោះបង់សំណើមិនបានទេ។ សាកពេលក្រោយ។';

  @override
  String get failedToSendComment => 'ផ្ញើមតិមិនបានទេឥឡូវនេះ។';

  @override
  String get alreadyMemberTitle => 'ជាសមាជិករួចហើយ';

  @override
  String get alreadyInvitedTitle => 'បានអញ្ជើញរួចហើយ';

  @override
  String membersAdded(int count, String name) {
    return 'បានបន្ថែម $count នាក់ទៅ $name។';
  }

  @override
  String get couldNotAddMembers => 'បន្ថែមសមាជិកមិនបានទេ។ សាកម្តងទៀត។';

  @override
  String get removeMemberTitle => 'ដកសមាជិក';

  @override
  String removeMemberConfirm(String name, String club) {
    return 'ដក $name ចេញពី $club?';
  }

  @override
  String get thisMember => 'សមាជិកនេះ';

  @override
  String memberRemoved(String name, String club) {
    return 'បានដក $name ចេញពី $club។';
  }

  @override
  String youJoinedChallenge(String name) {
    return 'អ្នកនៅក្នុង $name ហើយ។';
  }

  @override
  String get failedToJoinChallenge => 'ចូលការហាត់នេះមិនបានទេ។';

  @override
  String get membersJoinedLabel => 'សមាជិកបានចូលរួម';

  @override
  String get addFriendsForTask =>
      'បន្ថែមមិត្តសិន រួចអញ្ជើញពួកគេចូលកិច្ចការនេះ។';

  @override
  String get loseWeightGoal => 'សម្រកទម្ងន់';

  @override
  String get buildMuscleGoal => 'បង្កើនសាច់ដុំ';

  @override
  String get keepFitGoal => 'រក្សាសុខភាព';

  @override
  String get noviceLevel => 'ទើបចាប់ផ្ដើម';

  @override
  String get noviceLevelSub =>
      'ជំហានតូចៗ ប៉ុន្តែផ្លាស់ប្ដូរធំ។ ល្អសម្រាប់អ្នកថ្មី។';

  @override
  String get intermediateLevel => 'មានបទពិសោធខ្លះ';

  @override
  String get intermediateLevelSub =>
      'អ្នកស្គាល់មូលដ្ឋាន។ ល្អប្រសិនហាត់ម្តងម្កាល។';

  @override
  String get advancedLevel => 'អ្នកចូលចិត្តហាត់';

  @override
  String get advancedLevelSub => 'រុញខ្លួនអ្នក។ សម្រាប់អ្នកហាត់ញឹកញាប់។';

  @override
  String get requestsLabel => 'សំណើ';

  @override
  String youRequestedJoin(String name) {
    return 'អ្នកបានសុំចូល $name';
  }

  @override
  String get aClub => 'ក្លឹបមួយ';

  @override
  String get noTasksYet => 'មិនទាន់មានកិច្ចការទេ';

  @override
  String get createTaskToStart => 'បង្កើតកិច្ចការមួយដើម្បីចាប់ផ្ដើម។';

  @override
  String get goals => 'គោលដៅ';

  @override
  String get history => 'ប្រវត្តិ';

  @override
  String get profileAndGoal => 'ប្រវត្តិរូប និងគោលដៅ';

  @override
  String get editFitnessProfile => 'កែប្រវត្តិរូបហាត់ >>';

  @override
  String get editFitnessGoal => 'កែគោលដៅហាត់ >>';

  @override
  String get currentWeight => 'ទម្ងន់បច្ចុប្បន្ន';

  @override
  String get currentHeight => 'កម្ពស់បច្ចុប្បន្ន';

  @override
  String get fitnessLevel => 'កម្រិតហាត់';

  @override
  String get targetDateLabel => 'ថ្ងៃគោលដៅ';

  @override
  String get targetWeightLabel => 'ទម្ងន់គោលដៅ';

  @override
  String get noneValue => 'មិនទាន់មាន';

  @override
  String get notClubMember => 'ចូលក្លឹបនេះសិន ទើបបង្កើតការហាត់បាន។';

  @override
  String get unknownUser => 'អ្នកប្រើមិនស្គាល់';

  @override
  String get notSetUp => 'មិនទាន់កំណត់';

  @override
  String get taskCompleted => 'កិច្ចការបានបញ្ចប់';

  @override
  String get steps => 'ជំហាន';

  @override
  String get daysUntilYourTrip => 'ថ្ងៃទៀតដល់ដំណើរកម្សាន្ត';

  @override
  String get tasksStat => 'កិច្ចការ';

  @override
  String get workoutsStat => 'ការហាត់';

  @override
  String get tripsStat => 'ដំណើរកម្សាន្ត';

  @override
  String get badgesStat => 'សញ្ញា';

  @override
  String get unlinkPhoneTitle => 'ផ្តាច់លេខទូរសព្ទ?';

  @override
  String get unlinkPhoneConfirm => 'តើអ្នកចង់ផ្តាច់លេខទូរសព្ទចេញពីគណនីមែនទេ?';

  @override
  String get unlink => 'ផ្តាច់';

  @override
  String get selectDateOfBirth => 'ជ្រើសថ្ងៃខែឆ្នាំកំណើត';

  @override
  String get selectRegion => 'ជ្រើសតំបន់';

  @override
  String get phoneNumber => 'លេខទូរសព្ទ';

  @override
  String get dateOfBirth => 'ថ្ងៃខែឆ្នាំកំណើត';

  @override
  String get location => 'ទីតាំង';
}
