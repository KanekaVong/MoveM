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
  String get edit => 'កែប្រែ';

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
  String get accept => 'យល់ព្រម';

  @override
  String get reject => 'បដិសេធ';

  @override
  String get addFriend => 'បន្ថែមជាមិត្ត';

  @override
  String get remove => 'ដកចេញ';

  @override
  String get welcomeBack => 'សូមស្វាគមន៍ការត្រឡប់មកវិញ!';

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
  String get didntGetCode => 'មិនបានទទួលលេខកូដ?';

  @override
  String resendCodeIn(String time) {
    return 'ផ្ញើម្ដងទៀតក្នុង $time';
  }

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
  String get welcomeBackTitle => 'សូមស្វាគមន៍ការត្រឡប់មកវិញ';

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
  String get passwordsDoNotMatch => 'ពាក្យសម្ងាត់ទាំងពីរមិនដូចគ្នាទេ។';

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
  String get sendOtp => 'ផ្ញើលេខកូដ';

  @override
  String get savePasswordAction => 'រក្សាទុកពាក្យសម្ងាត់';

  @override
  String get fillAllFields => 'សូមបំពេញព័ត៌មានទាំងអស់។';

  @override
  String get greetings => 'សួស្ដី';

  @override
  String get stayActiveToday => 'ថ្ងៃនេះ តោះធ្វើចលនាទាំងអស់គ្នា!';

  @override
  String get todayProgress => 'វឌ្ឍនភាពថ្ងៃនេះ';

  @override
  String get ongoingTasks => 'កិច្ចការកំពុងធ្វើ';

  @override
  String get upcoming => 'ខាងមុខ';

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
  String get addCollaborator => 'អញ្ជើញអ្នកចូលរួម';

  @override
  String get taskTitleLabel => 'ឈ្មោះកិច្ចការ';

  @override
  String get taskTitleHint => 'ដាក់ឈ្មោះកិច្ចការរបស់អ្នក...';

  @override
  String get descriptionLabel => 'ការពិពណ៌នា';

  @override
  String get descriptionHint => 'បញ្ចូលការពិពណ៌នា';

  @override
  String get deadlineLabel => 'កាលបរិច្ឆេទកំណត់';

  @override
  String get priorityLabel => 'កម្រិតអាទិភាព';

  @override
  String get labelsLabel => 'ស្លាកសម្គាល់';

  @override
  String get collaboratorsLabel => 'អ្នកចូលរួម';

  @override
  String get checklistLabel => 'បញ្ជីត្រូវធ្វើ';

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
  String get qrSavedToast => 'បានរក្សាទុក QR Code';

  @override
  String get scanToConnect => 'ស្កេនដើម្បីភ្ជាប់មិត្តជាមួយខ្ញុំនៅលើ MoveM';

  @override
  String get cameraStarting => 'កំពុងបើកកាមេរ៉ា...';

  @override
  String get alignQrHint => 'ដាក់ QR Code ឲ្យនៅក្នុងស៊ុម ដើម្បីស្កេន';

  @override
  String get userFound => 'រកឃើញអ្នកប្រើ';

  @override
  String get movemClub => 'ក្លឹប MoveM';

  @override
  String get soloChallenges => 'ហាត់តែឯង';

  @override
  String get groupActivity => 'ហាត់ជាក្រុម';

  @override
  String get yourGoal => 'គោលដៅរបស់អ្នក';

  @override
  String get liveTracking => 'កំពុងតាមដានការរត់';

  @override
  String get runSummary => 'សង្ខេបការរត់';

  @override
  String get runHistory => 'ប្រវត្តិការរត់';

  @override
  String get runDetails => 'ព័ត៌មានលម្អិតការរត់';

  @override
  String get pushUpWorkout => 'ហាត់ពុះដី';

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
  String get tapToCount => 'ប៉ះអេក្រង់ដើម្បីរាប់ចំនួនដង';

  @override
  String get greatJobWorkout => 'អស្ចារ្យណាស់! អ្នកហាត់រួចរាល់ហើយ';

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
  String get sessionsSection => 'ការចូលប្រើ';

  @override
  String get yourProfile => 'ប្រវត្តិរូបរបស់អ្នក';

  @override
  String get changePassword => 'ផ្លាស់ប្ដូរពាក្យសម្ងាត់';

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
  String get inviteLinkCopied => 'បានចម្លងតំណអញ្ជើញរួចហើយ';

  @override
  String get inviteTokenCopied => 'បានចម្លងកូដអញ្ជើញរួចហើយ';

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
      'តើអ្នកពិតជាចង់លុបមតិនេះមែនទេ? លុបហើយមិនអាចយកមកវិញបានទេ។';

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
  String get loadingMore => 'កំពុងផ្ទុកបន្ថែម...';

  @override
  String get beTheFirstToComment =>
      'ជាមនុស្សដំបូងដែលបញ្ចេញមតិ ឬសួរសំណួរអំពីកិច្ចការនេះ។';

  @override
  String get commentCopiedToast => 'បានចម្លងមតិយោបល់រួចរាល់';

  @override
  String get edited => 'បានកែប្រែ';

  @override
  String get deleteTask => 'លុបកិច្ចការ';

  @override
  String get deleteTaskConfirm =>
      'តើអ្នកពិតជាចង់លុបកិច្ចការនេះមែនទេ? លុបហើយមិនអាចយកមកវិញបានទេ។';

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
      'តើធ្វើដំណើររយៈពេលប៉ុន្មាន ហើយចំណាយប៉ុន្មាន?';

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
  String get tripPackingTitle => 'មិនដឹងត្រូវវេចខ្ចប់អ្វីខ្លះមែនទេ?';

  @override
  String get tripPackingDescription =>
      'ពិនិត្យមើលរបស់ដែលអ្នក និងមិត្តភក្តិត្រូវវេចខ្ចប់!';

  @override
  String get tripEssentials => 'សម្ភារៈចាំបាច់សម្រាប់ដំណើរ';

  @override
  String get packingItemsHint => 'បន្ថែមរបស់ដែលត្រូវវេចខ្ចប់...';

  @override
  String get tripChecklistTitle => 'បញ្ជីត្រួតពិនិត្យដំណើរ';

  @override
  String get tripChecklistDescription =>
      'ត្រូវប្រាកដថាអ្វីៗរួចរាល់សម្រាប់ដំណើររបស់អ្នក!';

  @override
  String get checklistItemsHint => 'បន្ថែមចំណុចដែលត្រូវរៀបចំ...';

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
  String get unnamedStop => 'ចំណតគ្មានឈ្មោះ';

  @override
  String get editTripTitle => 'កែដំណើរកម្សាន្ត';

  @override
  String get error => 'កំហុស';

  @override
  String get editTripName => 'ឈ្មោះដំណើរកម្សាន្ត';

  @override
  String get editTripDuration => 'រយៈពេល';

  @override
  String get editTripMembers => 'សមាជិក';

  @override
  String get editTripStops => 'ចំណត';

  @override
  String get editTripPacking => 'របស់ត្រូវវេចខ្ចប់';

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
  String get editTripNameHint => 'បញ្ចូលឈ្មោះដំណើរកម្សាន្ត';

  @override
  String get editTripNameRequired => 'ឈ្មោះដំណើរកម្សាន្តមិនអាចទទេបានទេ';

  @override
  String get editTripNameUpdated => 'បានកែឈ្មោះដំណើរកម្សាន្តរួចរាល់';

  @override
  String get editTripUpdateSuccess => 'ជោគជ័យ';

  @override
  String get editTripUpdateFailed => 'មិនអាចកែដំណើរកម្សាន្តបានទេ';

  @override
  String get editTripAddItem => 'បន្ថែមរបស់';

  @override
  String get editTripAddMember => 'បន្ថែមសមាជិក';

  @override
  String get editTripUploadAttachment => 'បង្ហោះឯកសារភ្ជាប់';

  @override
  String get editTripNoMembers => 'មិនទាន់មានសមាជិក';

  @override
  String get editTripNoAttachments => 'មិនទាន់មានឯកសារភ្ជាប់';

  @override
  String get editTripNoPackingItems => 'មិនទាន់មានរបស់ត្រូវវេចខ្ចប់ទេ';

  @override
  String get editTripNoChecklistItems => 'មិនទាន់មានបញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripReorderStops => 'អូសដើម្បីរៀបលំដាប់ចំណត';

  @override
  String get editTripSectionTripName => 'ឈ្មោះដំណើរកម្សាន្ត';

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
  String get editTripItem => 'របស់';

  @override
  String get editTripItems => 'របស់';

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
      'ឥឡូវនេះមិនទាន់មាននរណាម្នាក់ដើម្បីណែនាំទេ។';

  @override
  String get noUsersFound => 'រកមិនឃើញអ្នកប្រើប្រាស់';

  @override
  String get nothingMatchesSearch => 'រកមិនឃើញលទ្ធផលដែលត្រូវនឹងការស្វែងរកទេ។';

  @override
  String get workoutChallenge => 'ការហាត់ប្រាណ';

  @override
  String get filterChallenges => 'ជ្រើសប្រភេទការហាត់';

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
  String get noWorkoutSessionsYetSub => 'រត់ ឬពុះដីឲ្យរួច ដើម្បីមើលវានៅទីនេះ!';

  @override
  String get tryAgain => 'ព្យាយាមម្តងទៀត';

  @override
  String get quickActions => 'សកម្មភាពរហ័ស';

  @override
  String get challengeAction => 'ការហាត់';

  @override
  String get fitnessClubAction => 'ក្លឹបហាត់ប្រាណ';

  @override
  String get historyTitle => 'ប្រវត្តិ';

  @override
  String get noActivityYet => 'មិនទាន់មានសកម្មភាពនៅឡើយទេ';

  @override
  String get noActivityYetSub => 'បច្ចុប្បន្នភាពនៃកិច្ចការនេះនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get retry => 'ព្យាយាមម្ដងទៀត';

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
  String get feedEmptySub =>
      'ការហាត់ និងសកម្មភាពរបស់មិត្តភក្តិនឹងបង្ហាញនៅទីនេះ។';

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
  String get noMembersYet => 'មិនទាន់មានសមាជិក';

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
  String get next => 'បន្ទាប់';

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
    return '$count សមាជិក';
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
  String get unexpectedError => 'មានបញ្ហាបន្តិច។ សូមព្យាយាមម្ដងទៀត។';

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
  String get history => 'ប្រវត្តិចំណាយ';

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

  @override
  String get congratulationOnYour => 'សូមអបអរសាទរចំពោះ';

  @override
  String get first10Kilometers => '១០ គីឡូម៉ែត្រដំបូង!';

  @override
  String get firstWorkout => 'ការហាត់ដំបូង!';

  @override
  String get newAchievement => 'សមិទ្ធផលថ្មី!';

  @override
  String get awesome => 'អស្ចារ្យ!!!';

  @override
  String get verificationFailed => 'ការផ្ទៀងផ្ទាត់បរាជ័យ';

  @override
  String get tripMembers => 'សមាជិកដំណើរកម្សាន្ត';

  @override
  String get pendingInvitations => 'ការអញ្ជើញដែលកំពុងរង់ចាំ';

  @override
  String get noPendingInvitations => 'មិនមានការអញ្ជើញដែលកំពុងរង់ចាំ';

  @override
  String get pending => 'មិនទាន់ទូទាត់';

  @override
  String get inviteFriend => 'អញ្ជើញមិត្តភក្តិ';

  @override
  String get searchFriends => 'ស្វែងរកមិត្តភក្តិ';

  @override
  String get searchFriendsHint => 'ស្វែងរកតាមឈ្មោះអ្នកប្រើ ឬអ៊ីមែល';

  @override
  String get searchToFindFriends => 'ស្វែងរកដើម្បីរកមិត្តភក្តិ';

  @override
  String get invitationPending => 'ការអញ្ជើញកំពុងរង់ចាំ';

  @override
  String get invitationSent => 'បានផ្ញើការអញ្ជើញរួចរាល់';

  @override
  String get failedToSendInvitation => 'ផ្ញើការអញ្ជើញមិនបានទេ';

  @override
  String get tripInvitations => 'ការអញ្ជើញចូលរួមដំណើរកម្សាន្ត';

  @override
  String get noTripInvitations => 'មិនមានការអញ្ជើញចូលរួមដំណើរកម្សាន្ត';

  @override
  String get invitedYouToTrip => 'បានអញ្ជើញអ្នកចូលរួមដំណើរកម្សាន្ត';

  @override
  String get invitationAccepted => 'បានទទួលយកការអញ្ជើញ';

  @override
  String get tripAddedToYourTrips =>
      'ដំណើរកម្សាន្តនេះត្រូវបានបន្ថែមទៅក្នុងបញ្ជីរបស់អ្នកហើយ។';

  @override
  String get invitationRejected => 'បានបដិសេធការអញ្ជើញ';

  @override
  String get addExpense => 'បន្ថែមចំណាយ';

  @override
  String get addBudget => 'បន្ថែមថវិកា';

  @override
  String get expense => 'ចំណាយ';

  @override
  String get amount => 'ចំនួនទឹកប្រាក់';

  @override
  String get description => 'ការពិពណ៌នា';

  @override
  String get type => 'ប្រភេទ';

  @override
  String get tapToEnterAmount => 'ប៉ះដើម្បីបញ្ចូលចំនួនទឹកប្រាក់';

  @override
  String get tripExpenses => 'ចំណាយសម្រាប់ដំណើរ';

  @override
  String get totalBudget => 'ថវិកាសរុប';

  @override
  String get spent => 'បានចំណាយ';

  @override
  String get remaining => 'នៅសល់';

  @override
  String get categories => 'ប្រភេទចំណាយ';

  @override
  String get addExpenseBudget => 'បន្ថែមចំណាយ / ថវិកា';

  @override
  String get foodsAndDrinks => 'អាហារ និង ភេសជ្ជៈ';

  @override
  String get accommodations => 'កន្លែងស្នាក់នៅ';

  @override
  String get transportation => 'ការធ្វើដំណើរ';

  @override
  String get others => 'ផ្សេងៗ';

  @override
  String paidBy(Object amount, Object payerName) {
    return '$amount • បង់ដោយ $payerName';
  }

  @override
  String get trackAllYourExpenses => 'តាមដានចំណាយទាំងអស់របស់អ្នក';

  @override
  String get allCategories => 'គ្រប់ប្រភេទ';

  @override
  String get filterExpenses => 'ត្រងចំណាយ';

  @override
  String get splitBills => 'ចែកវិក្កយបត្រ';

  @override
  String get noExpensesYet => 'មិនទាន់មានចំណាយទេ';

  @override
  String get expensesWillAppearHere =>
      'ចំណាយសម្រាប់ដំណើររបស់អ្នកនឹងបង្ហាញនៅទីនេះ។';

  @override
  String get deleteExpense => 'លុបចំណាយ?';

  @override
  String deleteExpenseConfirmation(Object description) {
    return 'តើអ្នកប្រាកដថាចង់លុប \"$description\" មែនទេ?';
  }

  @override
  String get unknown => 'មិនស្គាល់';

  @override
  String get allocatedAmount => 'ចំនួនថវិកាដែលបានបែងចែក';

  @override
  String editCategory(Object category) {
    return 'កែប្រែ $category';
  }

  @override
  String get addDescriptions => 'បន្ថែមការពិពណ៌នា';

  @override
  String get descriptionDetailsHint =>
      'សរសេរព័ត៌មានបន្ថែមអំពីចំណាយនេះ ដើម្បីឲ្យមិត្តភក្តិដឹងថាចាយលើអ្វី។';

  @override
  String expensePaidBy(Object amount, Object payerName) {
    return '$amount បង់ដោយ $payerName';
  }

  @override
  String get splitBetween => 'ចែកឲ្យ';

  @override
  String get amountOwed => 'ចំនួនត្រូវបង់';

  @override
  String get settled => 'បានទូទាត់';

  @override
  String get unsettled => 'មិនទាន់ទូទាត់';

  @override
  String get noSplitInformation => 'មិនទាន់មានព័ត៌មានចែកវិក្កយបត្រទេ។';

  @override
  String get splitBillsWithFriends => 'ចែកវិក្កយបត្រជាមួយមិត្តភក្តិ!';

  @override
  String get members => 'សមាជិក';

  @override
  String get expenseAmount => 'ចំនួនចំណាយ';

  @override
  String get splitType => 'ប្រភេទការចែក';

  @override
  String get equal => 'ស្មើគ្នា';

  @override
  String get custom => 'កំណត់ខ្លួនឯង';

  @override
  String get splitAmount => 'ចំនួនទឹកប្រាក់ចែក';

  @override
  String get createSplitBill => 'ចែកវិក្កយបត្រ';

  @override
  String get comingSoon => 'នឹងមកដល់ឆាប់ៗនេះ';

  @override
  String get splitBillComingSoon => 'មុខងារចែកវិក្កយបត្រនឹងមកដល់ឆាប់ៗនេះ។';

  @override
  String get ok => 'យល់ព្រម';

  @override
  String totalSpent(Object amount) {
    return 'ចំណាយសរុប៖ $amount\$';
  }

  @override
  String get addTripCover => 'បន្ថែមរូបភាពគម្របដំណើរកម្សាន្ត';

  @override
  String get changeTripCover => 'ប្តូររូបភាពគម្របដំណើរកម្សាន្ត';

  @override
  String get addTripCoverImage => 'បន្ថែមរូបភាពគម្របដំណើរកម្សាន្ត';

  @override
  String get changeCurrentImage => 'ប្តូររូបភាពបច្ចុប្បន្ន';

  @override
  String get recentTrips => 'ដំណើរកម្សាន្តថ្មីៗ';

  @override
  String get sortBy => 'តម្រៀបតាម';

  @override
  String get newestDate => 'ថ្មីបំផុត';

  @override
  String get oldestDate => 'ចាស់បំផុត';

  @override
  String get highestSpent => 'ចំណាយច្រើនបំផុត';

  @override
  String get noTripsYet => 'មិនទាន់មានដំណើរទេ។';

  @override
  String get editTripDeleteStop => 'លុបចំណត';

  @override
  String get editTripDeleteStopConfirmation =>
      'តើអ្នកប្រាកដថាចង់លុបចំណតនេះមែនទេ?';

  @override
  String get editTripEditStop => 'កែសម្រួលចំណត';

  @override
  String get editTripEditStopNotImplemented => 'ការកែសម្រួលចំណតនឹងមាននៅទីនេះ។';

  @override
  String get editTripAddStop => 'បន្ថែមចំណត';

  @override
  String get editTripAddStopSuccess => 'បានបន្ថែមចំណតរួចរាល់';

  @override
  String get editTripDeleteChecklist => 'លុបបញ្ជីត្រួតពិនិត្យ';

  @override
  String get editTripDeleteChecklistConfirm =>
      'តើអ្នកពិតជាចង់លុបចំណុចនេះចេញពីបញ្ជីមែនទេ?';

  @override
  String get editTripDelete => 'លុប';

  @override
  String get editTripCancel => 'បោះបង់';

  @override
  String get editTripDeleteChecklistSuccess => 'បានលុបចំណុចចេញពីបញ្ជីរួចរាល់';

  @override
  String get editTripDeleteChecklistFailed => 'មិនអាចលុបចំណុចនេះបានទេ';

  @override
  String get editTripEdit => 'កែសម្រួល';

  @override
  String get viewBills => 'មើលវិក្កយបត្រ';

  @override
  String get alreadySettled => 'បានទូទាត់រួចហើយ?';

  @override
  String get paid => 'បានទូទាត់';

  @override
  String get confirmSettlement => 'បញ្ជាក់ទូទាត់';

  @override
  String get confirmSettlementMessage =>
      'តើអ្នកពិតជាចង់សម្គាល់ថាបានបង់ចំណែករបស់អ្នករួចហើយមែនទេ?';

  @override
  String get settle => 'សម្គាល់ថាបានទូទាត់';

  @override
  String get noRecentTripsYet => 'មិនទាន់មានដំណើរកម្សាន្តថ្មីៗទេ។';

  @override
  String get notAvailable => 'មិនមាន';

  @override
  String get apiRequestCancelled => 'សំណើត្រូវបានបោះបង់។';

  @override
  String get apiTimeout => 'ការតភ្ជាប់យឺតពេក។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get apiNoInternet =>
      'មិនមានអ៊ីនធឺណិតទេ។ សូមពិនិត្យការតភ្ជាប់របស់អ្នក។';

  @override
  String get serverBadResponse =>
      'ម៉ាស៊ីនមេឆ្លើយតបមិនត្រឹមត្រូវ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get apiUnauthorized => 'វគ្គប្រើប្រាស់បានផុតកំណត់។ សូមចូលគណនីម្ដងទៀត។';

  @override
  String get apiForbidden => 'អ្នកមិនមានសិទ្ធិធ្វើសកម្មភាពនេះទេ។';

  @override
  String get apiNotFound => 'រកមិនឃើញអ្វីដែលអ្នកកំពុងស្វែងរកទេ។';

  @override
  String get apiServerError =>
      'ម៉ាស៊ីនមេកំពុងមានបញ្ហា។ សូមព្យាយាមម្ដងទៀតពេលក្រោយ។';

  @override
  String apiAlreadyTaken(Object field, Object value) {
    return '$field \'$value\' មានគេប្រើរួចហើយ។ សូមសាកមួយផ្សេងទៀត។';
  }

  @override
  String unitKmValue(Object value) {
    return '$value គ.ម';
  }

  @override
  String unitMeterValue(Object value) {
    return '$value ម៉ែត្រ';
  }

  @override
  String get homeDailyQuote =>
      '“ជោគជ័យ គឺការដើរពីការបរាជ័យមួយ ទៅការបរាជ័យមួយទៀត ដោយមិនបាត់បង់ភាពរំភើបចិត្ត” - វីនស្តុន ឆឺឈីល';

  @override
  String get homeSloganMove => 'ធ្វើចលនា';

  @override
  String get homeSloganExplore => 'ស្វែងយល់';

  @override
  String get homeSloganAchieve => 'សម្រេចគោលដៅ';

  @override
  String get notifChannelImportant => 'ការជូនដំណឹងសំខាន់ៗ';

  @override
  String get notifChannelImportantDesc =>
      'សម្រាប់ការជូនដំណឹង និងការព្រមានសំខាន់ៗ។';

  @override
  String get notifChannelTaskReminders => 'ការរំលឹកកិច្ចការ';

  @override
  String get notifChannelTaskRemindersDesc =>
      'ជូនដំណឹងពេលកិច្ចការជិតដល់ថ្ងៃកំណត់';

  @override
  String taskReminderTitle(Object title) {
    return 'រំលឹកកិច្ចការ៖ $title';
  }

  @override
  String get taskReminderBody => 'កុំភ្លេចធ្វើកិច្ចការនេះឲ្យរួចណា!';

  @override
  String get authVerifiedTitle => 'ផ្ទៀងផ្ទាត់រួចរាល់';

  @override
  String get authOtpVerified => 'ផ្ទៀងផ្ទាត់លេខកូដបានជោគជ័យ!';

  @override
  String get authCodeSentTitle => 'បានផ្ញើលេខកូដ';

  @override
  String get authNewCodeSent => 'យើងបានផ្ញើលេខកូដថ្មីទៅអ៊ីមែលរបស់អ្នកហើយ។';

  @override
  String get authEmailVerified => 'ផ្ទៀងផ្ទាត់អ៊ីមែលបានជោគជ័យ!';

  @override
  String get authNewVerificationCodeSent =>
      'យើងបានផ្ញើលេខកូដផ្ទៀងផ្ទាត់ថ្មីទៅអ៊ីមែលរបស់អ្នកហើយ។';

  @override
  String get authOtpSentTitle => 'បានផ្ញើលេខកូដ';

  @override
  String authOtpSentTo(Object email) {
    return 'យើងបានផ្ញើលេខកូដទៅ $email ហើយ។';
  }

  @override
  String get authPasswordResetTitle => 'បានប្ដូរពាក្យសម្ងាត់';

  @override
  String get authPasswordResetDone =>
      'ពាក្យសម្ងាត់របស់អ្នកត្រូវបានប្ដូររួចរាល់។';

  @override
  String get authTagline => 'ជីវិតអ្នក ពោរពេញដោយចលនា';

  @override
  String get activitySteps => 'ជំហាន';

  @override
  String activityDurationMins(Object mins) {
    return '$mins នាទី';
  }

  @override
  String get activityCalories => 'កាឡូរី';

  @override
  String get activityAvgPace => 'ល្បឿនមធ្យម';

  @override
  String get activityChallenge => 'ការហាត់';

  @override
  String get activityCompleted => 'បានបញ្ចប់ 🔥';

  @override
  String likesCount(Object count) {
    return '$count ចូលចិត្ត';
  }

  @override
  String commentsCount(Object count) {
    return '$count មតិ';
  }

  @override
  String get activityWorkout => 'ការហាត់';

  @override
  String get homeMovemUser => 'អ្នកប្រើ MoveM';

  @override
  String feedCompletedRunDistance(Object distance) {
    return 'រត់បាន $distance រួចរាល់! 🔥';
  }

  @override
  String get feedCompletedRun => 'រត់រួចរាល់! 🔥';

  @override
  String get feedCompletedPushUp => 'ពុះដីរួចរាល់! 🔥';

  @override
  String get feedCompletedSquat => 'អង្គុយក្រោករួចរាល់! 🔥';

  @override
  String feedCompletedWorkout(Object type) {
    return 'បញ្ចប់ការហាត់ $type រួចរាល់! 🔥';
  }

  @override
  String get homeMovemAthlete => 'អ្នកហាត់ MoveM';

  @override
  String caloriesValue(Object count) {
    return '$count កាឡូរី';
  }

  @override
  String stepsValue(Object count) {
    return '$count ជំហាន';
  }

  @override
  String durHoursMins(Object hours, Object mins) {
    return '$hours ម៉ោង $mins នាទី';
  }

  @override
  String durHours(Object hours) {
    return '$hours ម៉ោង';
  }

  @override
  String durMins(Object mins) {
    return '$mins នាទី';
  }

  @override
  String paceValue(Object pace) {
    return '$pace / គ.ម';
  }

  @override
  String runSprintName(Object km) {
    return 'រត់ប្រណាំង $km គីឡូម៉ែត្រ';
  }

  @override
  String get activityRun => 'រត់';

  @override
  String durMinsSecs(Object mins, Object secs) {
    return '$mins នាទី $secs វិនាទី';
  }

  @override
  String durSecs(Object secs) {
    return '$secs វិនាទី';
  }

  @override
  String get changeEmail => 'ប្ដូរអ៊ីមែល';

  @override
  String get addPhone => 'បន្ថែមលេខទូរសព្ទ';

  @override
  String get emailAddress => 'អាសយដ្ឋានអ៊ីមែល';

  @override
  String get phoneNumberLower => 'លេខទូរសព្ទ';

  @override
  String get emailPrivacyNote =>
      'អ៊ីមែលរបស់អ្នកភ្ជាប់ជាមួយគណនី ហើយត្រូវបានរក្សាជាការសម្ងាត់។ បើអ្នកប្ដូរ យើងអាចរក្សាអ៊ីមែលចាស់ទុក ដើម្បីជួយសង្គ្រោះគណនីពេលចាំបាច់។';

  @override
  String get phoneUpdateNote =>
      'លេខទូរសព្ទរបស់អ្នកនឹងត្រូវបានកែនៅក្នុងប្រវត្តិរូប។';

  @override
  String get change => 'ប្ដូរ';

  @override
  String get pleaseEnterEmail => 'សូមបញ្ចូលអាសយដ្ឋានអ៊ីមែល';

  @override
  String get pleaseEnterValidPhone => 'សូមបញ្ចូលលេខទូរសព្ទឲ្យបានត្រឹមត្រូវ';

  @override
  String get phoneUpdated => 'បានប្ដូរលេខទូរសព្ទរួចរាល់';

  @override
  String get logOutConfirm => 'តើអ្នកពិតជាចង់ចាកចេញពីគណនីមែនទេ?';

  @override
  String get region => 'តំបន់';

  @override
  String get chooseRegion => 'ជ្រើសរើសតំបន់របស់អ្នក';

  @override
  String get chooseRegionSub => 'ជ្រើសរើសប្រទេស និងខេត្ត ឬរដ្ឋរបស់អ្នក។';

  @override
  String get country => 'ប្រទេស';

  @override
  String get selectCountry => 'ជ្រើសរើសប្រទេស';

  @override
  String get searchCountry => 'ស្វែងរកប្រទេស...';

  @override
  String get regionStateProvince => 'តំបន់ / រដ្ឋ / ខេត្ត';

  @override
  String get selectRegionLower => 'ជ្រើសរើសតំបន់';

  @override
  String get searchRegion => 'ស្វែងរកតំបន់...';

  @override
  String get passwordChanged => 'ពាក្យសម្ងាត់របស់អ្នកត្រូវបានប្ដូររួចរាល់។';

  @override
  String get changeYourPassword => 'ប្ដូរពាក្យសម្ងាត់របស់អ្នក';

  @override
  String get changePasswordSub =>
      'បញ្ចូលពាក្យសម្ងាត់បច្ចុប្បន្ន រួចជ្រើសរើសពាក្យសម្ងាត់ថ្មី។';

  @override
  String get currentPassword => 'ពាក្យសម្ងាត់បច្ចុប្បន្ន';

  @override
  String get enterCurrentPassword => 'បញ្ចូលពាក្យសម្ងាត់បច្ចុប្បន្ន';

  @override
  String get pleaseEnterCurrentPassword => 'សូមបញ្ចូលពាក្យសម្ងាត់បច្ចុប្បន្ន។';

  @override
  String get newPasswordTitle => 'ពាក្យសម្ងាត់ថ្មី';

  @override
  String get pleaseEnterNewPassword => 'សូមបញ្ចូលពាក្យសម្ងាត់ថ្មី។';

  @override
  String get passwordMin8 => 'ពាក្យសម្ងាត់ត្រូវមានយ៉ាងហោចណាស់ ៨ តួអក្សរ។';

  @override
  String get confirmNewPassword => 'បញ្ជាក់ពាក្យសម្ងាត់ថ្មី';

  @override
  String get confirmNewPasswordHint => 'វាយពាក្យសម្ងាត់ថ្មីម្ដងទៀត';

  @override
  String get pleaseConfirmNewPassword => 'សូមវាយពាក្យសម្ងាត់ថ្មីម្ដងទៀត។';

  @override
  String get forgotPasswordLower => 'ភ្លេចពាក្យសម្ងាត់?';

  @override
  String get changeProfilePhoto => 'ប្ដូររូបប្រវត្តិរូប';

  @override
  String get chooseFromLibrary => 'ជ្រើសពីវិចិត្រសាល';

  @override
  String get takePhoto => 'ថតរូប';

  @override
  String get removeCurrentPhoto => 'លុបរូបបច្ចុប្បន្ន';

  @override
  String get couldNotSelectImage => 'មិនអាចជ្រើសរូបភាពបានទេ។';

  @override
  String get failedToSaveProfileChanges =>
      'រក្សាទុកការកែប្រែមិនបានទេ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get uploadFailed => 'បង្ហោះមិនបាន';

  @override
  String get photoUploadFailed =>
      'ម៉ាស៊ីនមេមិនអាចរក្សាទុករូបរបស់អ្នកបានទេ។ សូមព្យាយាមម្ដងទៀតពេលក្រោយ។';

  @override
  String get firstNameField => 'នាមខ្លួន';

  @override
  String get lastNameField => 'នាមត្រកូល';

  @override
  String get bio => 'អំពីខ្ញុំ';

  @override
  String get male => 'ប្រុស';

  @override
  String get female => 'ស្រី';

  @override
  String get other => 'ផ្សេងទៀត';

  @override
  String get preferNotToSay => 'មិនចង់បញ្ជាក់';

  @override
  String get yourEmailAddress => 'អ៊ីមែលរបស់អ្នក៖';

  @override
  String get yourPhoneNumber => 'លេខទូរសព្ទរបស់អ្នក៖';

  @override
  String get phonePrivacyNote =>
      'លេខទូរសព្ទរបស់អ្នកភ្ជាប់ជាមួយគណនី ហើយត្រូវបានរក្សាជាការសម្ងាត់។ បើអ្នកប្ដូរ យើងអាចរក្សាលេខចាស់ទុក ដើម្បីជួយសង្គ្រោះគណនីពេលចាំបាច់។';

  @override
  String get changePhoneNumber => 'ប្ដូរលេខទូរសព្ទ';

  @override
  String get verifyEmail => 'ផ្ទៀងផ្ទាត់អ៊ីមែល';

  @override
  String get verifyEmailSub =>
      'យើងបានផ្ញើលេខកូដផ្ទៀងផ្ទាត់ទៅអ៊ីមែលរបស់អ្នក ដើម្បីបញ្ជាក់ថាជាអ្នកពិតប្រាកដ។ សូមពិនិត្យប្រអប់សំបុត្រ ហើយបញ្ចូលលេខកូដ។';

  @override
  String resendCodeInSeconds(Object seconds) {
    return 'ផ្ញើលេខកូដម្ដងទៀតក្នុង $seconds វិនាទី';
  }

  @override
  String get resendCodeLower => 'ផ្ញើលេខកូដម្ដងទៀត';

  @override
  String get pleaseEnter6DigitCode => 'សូមបញ្ចូលលេខកូដផ្ទៀងផ្ទាត់ ៦ ខ្ទង់';

  @override
  String get pleaseEnterYourEmail => 'សូមបញ្ចូលអ៊ីមែលរបស់អ្នក។';

  @override
  String get pleaseEnterOtp => 'សូមបញ្ចូលលេខកូដ OTP។';

  @override
  String get forgotPasswordTitle => 'ភ្លេចពាក្យសម្ងាត់';

  @override
  String get resetYourPassword => 'កំណត់ពាក្យសម្ងាត់ថ្មី';

  @override
  String get resetPasswordSub =>
      'បញ្ចូលអ៊ីមែលរបស់អ្នក ហើយប្រើលេខកូដ OTP ដែលយើងផ្ញើទៅ ដើម្បីបង្កើតពាក្យសម្ងាត់ថ្មី។';

  @override
  String get otpCodeField => 'លេខកូដ OTP';

  @override
  String get enter6DigitOtp => 'បញ្ចូលលេខកូដ ៦ ខ្ទង់';

  @override
  String get resend => 'ផ្ញើម្ដងទៀត';

  @override
  String get otpExpiryNote =>
      'លេខកូដ OTP នឹងផុតសុពលភាពក្នុងរយៈពេលខ្លី សម្រាប់សុវត្ថិភាពគណនីរបស់អ្នក។';

  @override
  String get resetPasswordAction => 'កំណត់ពាក្យសម្ងាត់ថ្មី';

  @override
  String get friendRequestAccepted => 'បានទទួលយកសំណើមិត្តភាព';

  @override
  String get friendRequestRejected => 'បានបដិសេធសំណើមិត្តភាព';

  @override
  String get challengesCompleted => 'ការហាត់បានបញ្ចប់';

  @override
  String get tripPlans => 'ផែនការដំណើរកម្សាន្ត';

  @override
  String get friendsTitle => 'មិត្តភក្តិ';

  @override
  String get recentAchievementsLead => '';

  @override
  String get mutualFriendsLead => '';

  @override
  String get requestSent => 'បានផ្ញើសំណើ';

  @override
  String get moveWithPurpose => 'ធ្វើចលនាដោយមានគោលដៅ';

  @override
  String get addFriendsHeadline =>
      'ស្វែងរក និងភ្ជាប់ទំនាក់ទំនងជាមួយមិត្តភក្តិ ដើម្បីហាត់ប្រាណជាមួយគ្នា';

  @override
  String inviteShareMessage(Object link) {
    return 'មកហាត់ប្រាណជាមួយខ្ញុំនៅលើ MoveM! ប្រើតំណអញ្ជើញរបស់ខ្ញុំ៖ $link';
  }

  @override
  String get qrCaptureFailed => 'មិនអាចថតរូប QR Code បានទេ';

  @override
  String get qrConvertFailed => 'មិនអាចបម្លែង QR Code ទៅជារូបភាពបានទេ';

  @override
  String get permissionNeededTitle => 'ត្រូវការការអនុញ្ញាត';

  @override
  String get allowPhotoAccessQr =>
      'សូមអនុញ្ញាតឲ្យចូលប្រើរូបថត ដើម្បីរក្សាទុក QR Code';

  @override
  String get qrSaveFailed => 'រក្សាទុក QR Code ទៅក្នុងរូបថតមិនបានទេ';

  @override
  String get shared => 'បានចែករំលែក';

  @override
  String profileLinkCopiedWithLink(Object link) {
    return 'បានចម្លងតំណប្រវត្តិរូប៖ $link';
  }

  @override
  String get friendRequestSent => 'បានផ្ញើសំណើមិត្តភាព។';

  @override
  String get nowFriends => 'ឥឡូវអ្នកទាំងពីរជាមិត្តភក្តិហើយ។';

  @override
  String get cameraPermissionRequired => 'ត្រូវការការអនុញ្ញាតឲ្យប្រើកាមេរ៉ា';

  @override
  String get noCameraFound => 'រកមិនឃើញកាមេរ៉ាទេ';

  @override
  String get cameraInitFailed => 'មិនអាចបើកកាមេរ៉ាបានទេ';

  @override
  String get couldNotOpenImage => 'មិនអាចបើករូបភាពដែលបានជ្រើសបានទេ';

  @override
  String get invalidQr => 'QR មិនត្រឹមត្រូវ';

  @override
  String get noQrInImage => 'រកមិនឃើញ QR Code ត្រឹមត្រូវក្នុងរូបភាពនេះទេ';

  @override
  String get qrGalleryScanFailed => 'មិនអាចស្កេន QR ពីរូបភាពបានទេ';

  @override
  String get noUserInQr => 'រកមិនឃើញអ្នកប្រើក្នុង QR Code នេះទេ';

  @override
  String get notSet => 'មិនទាន់កំណត់';

  @override
  String get priorityUrgent => 'បន្ទាន់';

  @override
  String get priorityHigh => 'ខ្ពស់';

  @override
  String get priorityMedium => 'មធ្យម';

  @override
  String get priorityLow => 'ទាប';

  @override
  String get repeatDaily => 'រាល់ថ្ងៃ';

  @override
  String get repeatWeekly => 'រាល់សប្ដាហ៍';

  @override
  String get repeatMonthly => 'រាល់ខែ';

  @override
  String get repeatYearly => 'រាល់ឆ្នាំ';

  @override
  String get repeatRecurring => 'ធ្វើម្ដងទៀត';

  @override
  String get taskStatusInProgress => 'កំពុងធ្វើ';

  @override
  String get taskStatusComplete => 'បានបញ្ចប់';

  @override
  String get taskStatusCancelled => 'បានបោះបង់';

  @override
  String get taskStatusDeleted => 'បានលុប';

  @override
  String get taskStatusCompleted => 'បានបញ្ចប់';

  @override
  String get deadlinePassed => 'ហួសថ្ងៃកំណត់ហើយ';

  @override
  String get markAsComplete => 'សម្គាល់ថាបានបញ្ចប់';

  @override
  String get dueOverdue => 'ហួសកំណត់';

  @override
  String get dueToday => 'ត្រូវធ្វើថ្ងៃនេះ';

  @override
  String get dueTomorrow => 'ត្រូវធ្វើថ្ងៃស្អែក';

  @override
  String dueInDays(Object days) {
    return 'នៅសល់ $days ថ្ងៃទៀត';
  }

  @override
  String get dueNextWeek => 'ត្រូវធ្វើសប្ដាហ៍ក្រោយ';

  @override
  String dueOnDate(Object date) {
    return 'ត្រូវធ្វើនៅ $date';
  }

  @override
  String get dueSoon => 'ជិតដល់ថ្ងៃកំណត់';

  @override
  String overdueOnDate(Object date) {
    return 'ហួសកំណត់ · $date';
  }

  @override
  String deadlineOnDate(Object date) {
    return 'ថ្ងៃកំណត់៖ $date';
  }

  @override
  String get member => 'សមាជិក';

  @override
  String inviteQuery(Object query) {
    return 'អញ្ជើញ \"$query\"';
  }

  @override
  String get deadlinesLabel => 'ថ្ងៃកំណត់';

  @override
  String get repeatLabelTitle => 'ធ្វើម្ដងទៀត';

  @override
  String get yourNextReminder => 'ការរំលឹកលើកក្រោយ';

  @override
  String attachmentsCount(Object count) {
    return 'ឯកសារភ្ជាប់   ($count)';
  }

  @override
  String get labelTitle => 'ស្លាក';

  @override
  String get detailsTitle => 'ព័ត៌មានលម្អិត';

  @override
  String collaboratorsCount(Object count) {
    return 'អ្នកចូលរួម   ($count)';
  }

  @override
  String get attachment => 'ឯកសារភ្ជាប់';

  @override
  String get titleLabel => 'ចំណងជើង';

  @override
  String get taskTitlePlaceholder => 'ឈ្មោះកិច្ចការ';

  @override
  String get taskDescriptionHint => 'សរសេរព័ត៌មានអំពីកិច្ចការនេះ...';

  @override
  String get selectLabel => 'ជ្រើសស្លាក';

  @override
  String get addAnItem => 'បន្ថែមចំណុចថ្មី';

  @override
  String get addCollaboratorsCaps => 'អញ្ជើញអ្នកចូលរួម';

  @override
  String get noAttachmentsAdded => 'មិនទាន់មានឯកសារភ្ជាប់';

  @override
  String get uploaded => 'បានបង្ហោះ';

  @override
  String get readyToUploadOnSave => 'នឹងបង្ហោះពេលរក្សាទុក';

  @override
  String get addAttachmentsCaps => 'បន្ថែមឯកសារភ្ជាប់';

  @override
  String get saveChanges => 'រក្សាទុកការកែប្រែ';

  @override
  String get uploadPhoto => 'បង្ហោះរូបភាព';

  @override
  String get chooseFromGallery => 'ជ្រើសពីវិចិត្រសាល';

  @override
  String get takeAPhoto => 'ថតរូប';

  @override
  String get taskReminderOptIn => 'ទទួលការរំលឹក មុនពេលកិច្ចការដល់ថ្ងៃកំណត់';

  @override
  String get createCaps => 'បង្កើត';

  @override
  String get createLabelTitle => 'បង្កើតស្លាក';

  @override
  String get enterLabelName => 'បញ្ចូលឈ្មោះស្លាក';

  @override
  String get colorLabel => 'ពណ៌';

  @override
  String get progressTitle => 'វឌ្ឍនភាព';

  @override
  String get allTasksCaps => 'កិច្ចការទាំងអស់';

  @override
  String get filter => 'តម្រង';

  @override
  String get filterTasks => 'តម្រងកិច្ចការ';

  @override
  String get reset => 'កំណត់ឡើងវិញ';

  @override
  String get statusLabel => 'ស្ថានភាព';

  @override
  String get applyFilters => 'ប្រើតម្រង';

  @override
  String get taskHeroTitle =>
      'ត្រៀមខ្លួនហើយឬនៅ\nដើម្បីធ្វើកិច្ចការឲ្យកាន់តែល្អ?';

  @override
  String get completedTasksCaps => 'កិច្ចការបានបញ្ចប់';

  @override
  String get createTaskCaps => 'បង្កើតកិច្ចការ';

  @override
  String get createTaskSub => 'ទុកវានៅទីនេះ ហើយឲ្យខួរក្បាលបានសម្រាក។';

  @override
  String get completedCaps => 'បានបញ្ចប់';

  @override
  String get upcomingTasks => 'កិច្ចការខាងមុខ';

  @override
  String get noUpcomingTasks => 'មិនមានកិច្ចការខាងមុខទេ';

  @override
  String get ongoingTasksTitle => 'កិច្ចការកំពុងធ្វើ';

  @override
  String get noOngoingTasks => 'មិនមានកិច្ចការកំពុងធ្វើទេ';

  @override
  String get noDeadline => 'គ្មានថ្ងៃកំណត់';

  @override
  String progressionPercent(Object percent) {
    return 'វឌ្ឍនភាព៖ $percent%';
  }

  @override
  String get someone => 'នរណាម្នាក់';

  @override
  String get aTask => 'កិច្ចការមួយ';

  @override
  String get invitedYouToCollaborate => 'បានអញ្ជើញអ្នកឲ្យចូលរួមក្នុង';

  @override
  String get failedToLoadHistory => 'មិនអាចបង្ហាញប្រវត្តិបានទេ';

  @override
  String get failedToSend => 'ផ្ញើមិនបាន';

  @override
  String get updatedTitle => 'បានកែប្រែ';

  @override
  String get commentUpdated => 'កែមតិរួចរាល់';

  @override
  String get updateFailed => 'កែមិនបាន';

  @override
  String get commentDeleted => 'បានលុបមតិរួចរាល់';

  @override
  String get failedToLoadInvitations => 'មិនអាចបង្ហាញការអញ្ជើញបានទេ';

  @override
  String youJoinedName(Object name) {
    return 'អ្នកបានចូលរួម $name ហើយ';
  }

  @override
  String get youJoinedTask => 'អ្នកបានចូលរួមកិច្ចការហើយ';

  @override
  String get couldNotAccept => 'មិនអាចទទួលយកបានទេ';

  @override
  String get pleaseTryAgain => 'សូមព្យាយាមម្ដងទៀត';

  @override
  String get couldNotDecline => 'មិនអាចបដិសេធបានទេ';

  @override
  String get repeatNone => 'មិនធ្វើម្ដងទៀត';

  @override
  String get repeatCustom => 'កំណត់ខ្លួនឯង';

  @override
  String get taskStatusUpcoming => 'ខាងមុខ';

  @override
  String get taskStatusPending => 'កំពុងរង់ចាំ';

  @override
  String get travelDriving => 'បើកឡាន';

  @override
  String get travelWalking => 'ដើរ';

  @override
  String get travelCycling => 'ជិះកង់';

  @override
  String get travelRiding => 'ជិះម៉ូតូ';

  @override
  String noRouteForMode(Object mode) {
    return 'រកមិនឃើញផ្លូវ$modeសម្រាប់ដំណើរនេះទេ។';
  }

  @override
  String deleteTripConfirm(Object name) {
    return 'តើអ្នកពិតជាចង់លុប \"$name\" មែនទេ? លុបហើយមិនអាចយកមកវិញបានទេ។';
  }

  @override
  String get tripHeroEnhance => 'ធ្វើឲ្យដំណើររបស់អ្នក\\nកាន់តែពិសេសជាមួយយើង។';

  @override
  String get buildingRoute => 'កំពុងរៀបចំផ្លូវ...';

  @override
  String get placeHasNoCoordinates => 'ទីកន្លែងដែលបានជ្រើសមិនមានកូអរដោនេទេ។';

  @override
  String get unknownLocation => 'ទីតាំងមិនស្គាល់';

  @override
  String get tripWelcomeTitle => 'ស្វែងយល់\nពិភពលោក\nជាមួយយើង';

  @override
  String get tripWelcomeSub => 'ធ្វើដំណើរដោយមានគោលដៅជានិច្ច';

  @override
  String get slideToExplore => 'អូសដើម្បីចាប់ផ្ដើម';

  @override
  String get goLabel => 'ទៅ';

  @override
  String get failedToSearchUsers => 'មិនអាចស្វែងរកអ្នកប្រើបានទេ';

  @override
  String get invitationSentTitle => 'បានផ្ញើការអញ្ជើញ';

  @override
  String invitationSentTo(Object name) {
    return 'បានផ្ញើការអញ្ជើញទៅ $name ហើយ';
  }

  @override
  String get invitationFailedTitle => 'ផ្ញើការអញ្ជើញមិនបាន';

  @override
  String couldNotInviteName(Object name) {
    return 'មិនអាចអញ្ជើញ $name បានទេ';
  }

  @override
  String get routeDetails => 'ព័ត៌មានផ្លូវ';

  @override
  String routeDistanceAndTime(Object km, Object time) {
    return '$km គ.ម • $time';
  }

  @override
  String get distanceCaps => 'ចម្ងាយ';

  @override
  String kmValueLower(Object km) {
    return '$km គ.ម';
  }

  @override
  String get estTime => 'រយៈពេលប៉ាន់ស្មាន';

  @override
  String get travelModeCaps => 'មធ្យោបាយធ្វើដំណើរ';

  @override
  String get noStopsAvailable => 'មិនមានចំណតទេ។';

  @override
  String get routeStop => 'ចំណតតាមផ្លូវ';

  @override
  String get locationServicesOff => 'សេវាទីតាំងត្រូវបានបិទ។ សូមបើកវាសិន។';

  @override
  String get locationNeededForRoute =>
      'ត្រូវការការអនុញ្ញាតទីតាំង ដើម្បីបង្ហាញផ្លូវ។';

  @override
  String get unableToGetLocation => 'មិនអាចរកទីតាំងរបស់អ្នកបានទេ។';

  @override
  String get tripDestinationMissing =>
      'ដំណើរនេះមិនទាន់មានទីតាំងគោលដៅនៅលើផែនទីទេ។';

  @override
  String get yourLocation => 'ទីតាំងរបស់អ្នក';

  @override
  String stopNumber(Object number) {
    return 'ចំណតទី $number';
  }

  @override
  String get destinationTitle => 'គោលដៅ';

  @override
  String get tripNameRequiredShort => 'សូមបញ្ចូលឈ្មោះដំណើរកម្សាន្ត។';

  @override
  String get startDateRequired => 'សូមជ្រើសថ្ងៃចាប់ផ្ដើម។';

  @override
  String get tripHeroTitle => 'តើគម្រោង\nបន្ទាប់របស់\nអ្នកគឺអ្វី?';

  @override
  String get planYourJourney => 'រៀបចំដំណើររបស់អ្នក';

  @override
  String get deleteTrip => 'លុបដំណើរកម្សាន្ត';

  @override
  String get tripDeleted => 'បានលុបដំណើរកម្សាន្តរួចរាល់។';

  @override
  String get selectDateAndTime => 'ជ្រើសថ្ងៃ និងម៉ោង';

  @override
  String get selectBothDates => 'សូមជ្រើសទាំងថ្ងៃចាប់ផ្ដើម និងថ្ងៃបញ្ចប់';

  @override
  String get endBeforeStart => 'ថ្ងៃបញ្ចប់មិនអាចមុនថ្ងៃចាប់ផ្ដើមបានទេ';

  @override
  String get durationUpdated => 'បានកែរយៈពេលរួចរាល់';

  @override
  String get stopUpdated => 'បានកែចំណតរួចរាល់';

  @override
  String get cancelCaps => 'បោះបង់';

  @override
  String get deleteCaps => 'លុប';

  @override
  String get stopNoValidLocation => 'ចំណតនេះមិនមានទីតាំងត្រឹមត្រូវទេ។';

  @override
  String get pleaseEnterChecklistItem => 'សូមបញ្ចូលចំណុចក្នុងបញ្ជី';

  @override
  String get checklistUpdated => 'បានកែបញ្ជីរួចរាល់';

  @override
  String get attachmentUploaded => 'បានបង្ហោះឯកសារភ្ជាប់';

  @override
  String get stopNoMapLocation => 'ចំណតនេះមិនមានទីតាំងនៅលើផែនទីទេ។';

  @override
  String get unableToGetThisLocation => 'មិនអាចយកទីតាំងនេះបានទេ។';

  @override
  String get selectedStop => 'ចំណតដែលបានជ្រើស';

  @override
  String get searchForStop => 'ស្វែងរកចំណត';

  @override
  String get setStop => 'កំណត់ចំណត';

  @override
  String get workoutRunning => 'រត់';

  @override
  String get workoutWalking => 'ដើរ';

  @override
  String get workoutCycling => 'ជិះកង់';

  @override
  String get workoutSwimming => 'ហែលទឹក';

  @override
  String get workoutHiking => 'ឡើងភ្នំ';

  @override
  String get workoutPushUp => 'ពុះដី';

  @override
  String get workoutSquats => 'អង្គុយក្រោក';

  @override
  String get workoutPullUps => 'ទាញខ្លួនឡើង';

  @override
  String get workoutStrength => 'ហាត់កម្លាំង';

  @override
  String get workoutBodyweight => 'ហាត់ទម្ងន់ខ្លួន';

  @override
  String get workoutYoga => 'យូហ្គា';

  @override
  String get workoutStretching => 'លាតសាច់ដុំ';

  @override
  String get workoutCardio => 'កាឌីយ៉ូ';

  @override
  String get workoutSports => 'កីឡា';

  @override
  String get workoutBadminton => 'វាយសី';

  @override
  String get workoutTennis => 'តិន្នីស';

  @override
  String get unitKm => 'គ.ម';

  @override
  String get unitMeters => 'ម៉ែត្រ';

  @override
  String get unitMinutes => 'នាទី';

  @override
  String get unitSteps => 'ជំហាន';

  @override
  String get unitReps => 'ដង';

  @override
  String challengeWithName(Object name) {
    return 'ការហាត់៖ $name';
  }

  @override
  String get finishedCaps => 'បានបញ្ចប់';

  @override
  String get finishedFire => 'បានបញ្ចប់ 🔥';

  @override
  String durationSecsCaps(Object secs) {
    return '$secs វិនាទី';
  }

  @override
  String trackingComingSoonTitle(Object workout) {
    return 'ការតាមដាន$workout នឹងមកដល់ឆាប់ៗ';
  }

  @override
  String trackingComingSoonBody(Object workout) {
    return 'យើងកំពុងរៀបចំការតាមដាន$workout ហើយនឹងដាក់ឲ្យប្រើក្នុងកំណែក្រោយ។';
  }

  @override
  String get gotIt => 'យល់ហើយ';

  @override
  String setsOfReps(Object sets, Object reps, Object unit) {
    return '$unit $sets ឈុត × $reps ដង';
  }

  @override
  String get statusPaused => 'បានផ្អាក';

  @override
  String get statusNotStarted => 'មិនទាន់ចាប់ផ្ដើម';

  @override
  String requestedToJoinClub(Object name, Object club) {
    return '$name បានស្នើសុំចូល $club';
  }

  @override
  String get yourClub => 'ក្លឹបរបស់អ្នក';

  @override
  String runningTargetTitle(Object target) {
    return 'រត់ $target';
  }

  @override
  String get runningChallenge => 'ការហាត់រត់';

  @override
  String get runningDescription =>
      'រត់ ហើយតាមដានផ្លូវ ល្បឿន ចម្ងាយ និងកាឡូរីដែលបានដុត ភ្លាមៗ។';

  @override
  String get squatsDescription =>
      'បន្ទាបត្រគាកពីការឈរ រួចក្រោកឈរវិញ ដើម្បីពង្រឹងជើង និងសាច់ដុំពោះ។';

  @override
  String get pushUpDescription =>
      'លំហាត់ពង្រឹងកម្លាំងផ្នែកខាងលើ ដោយទប់ខ្លួនលើចុងជើង និងបាតដៃ ហើយរុញខ្លួនឡើងពីដី។';

  @override
  String get genericChallengeDescription =>
      'សាកល្បងខ្លួនឯង ហើយហាត់ឲ្យទៀងទាត់ ដើម្បីសម្រេចគោលដៅសុខភាពរបស់អ្នក។';

  @override
  String get formExcellent => 'ល្អឥតខ្ចោះ';

  @override
  String get formGood => 'ល្អ';

  @override
  String get formShallow => 'មិនទាន់ជ្រៅ';

  @override
  String get formNoReps => 'មិនទាន់មានចំនួនដង';

  @override
  String get formRatingExcellent => 'ក្បាច់ល្អឥតខ្ចោះ 🏆';

  @override
  String get formRatingGood => 'ក្បាច់ល្អ 💪';

  @override
  String get formRatingWorkOnDepth => 'ចុះឲ្យជ្រៅជាងនេះ ⚠️';

  @override
  String get formDeepSquat => 'អង្គុយបានជ្រៅ';

  @override
  String get formGoodDepth => 'ជម្រៅល្អ';

  @override
  String get levelBeginner => 'អ្នកចាប់ផ្ដើម';

  @override
  String get levelIntermediate => 'កម្រិតមធ្យម';

  @override
  String get levelAdvanced => 'កម្រិតខ្ពស់';

  @override
  String get levelElite => 'កម្រិតកំពូល';

  @override
  String completeTargetToFinish(Object target) {
    return 'ធ្វើឲ្យបាន $target ដើម្បីបញ្ចប់ការហាត់នេះ។';
  }

  @override
  String get close => 'បិទ';

  @override
  String joinedSince(Object year) {
    return 'ចូលរួមតាំងពីឆ្នាំ $year';
  }

  @override
  String get roleOwner => 'ម្ចាស់ក្លឹប';

  @override
  String get roleAdmin => 'អ្នកគ្រប់គ្រង';

  @override
  String targetWithUnit(Object unit) {
    return 'គោលដៅ ($unit)';
  }

  @override
  String get categoryGeneral => 'ទូទៅ';

  @override
  String get cueGoodDepthPushUp => 'ចុះបានជ្រៅល្អ! ឥឡូវរុញឡើង!';

  @override
  String get cueLowerDown => 'ចុះទៀតបន្តិច...';

  @override
  String get cueGetReadyToLower => 'ត្រៀមខ្លួនចុះ';

  @override
  String get cueExcellentRep => 'ល្អណាស់! 🏆';

  @override
  String cueRepComplete(Object count) {
    return 'ដងទី $count រួចរាល់!';
  }

  @override
  String get cuePushAllTheWayUp => 'រុញឡើងឲ្យត្រង់ដៃ!';

  @override
  String get cueGoodDepthSquat => 'ជ្រៅល្អ! រុញឡើងដោយប្រើកែងជើង!';

  @override
  String get cueLowerHips => 'បន្ទាបត្រគាកចុះ...';

  @override
  String get cueStandTall => 'ឈរត្រង់ រួចចាប់ផ្ដើមអង្គុយ';

  @override
  String get cueDeepSquat => 'អង្គុយបានជ្រៅ! 🏆';

  @override
  String get cueStandAllTheWayUp => 'ក្រោកឈរឲ្យត្រង់!';

  @override
  String get failedStartWorkout => 'មិនអាចចាប់ផ្ដើមការហាត់បានទេ';

  @override
  String get failedUpdateProgress => 'មិនអាចរក្សាទុកវឌ្ឍនភាពបានទេ';

  @override
  String get failedFinishWorkout => 'មិនអាចបញ្ចប់ការហាត់បានទេ';

  @override
  String get summaryNotFound => 'រកមិនឃើញសង្ខេបការហាត់ទេ';

  @override
  String get failedSaveAnalysis => 'មិនអាចរក្សាទុកការវិភាគការហាត់បានទេ';

  @override
  String get goalNotFound => 'រកមិនឃើញគោលដៅទេ';

  @override
  String get challengeNotFound => 'រកមិនឃើញការហាត់នេះទេ';

  @override
  String get clubNotFound => 'រកមិនឃើញក្លឹបនេះទេ';

  @override
  String get failedToUpdateClub => 'មិនអាចកែក្លឹបបានទេ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get skip => 'រំលង';

  @override
  String get challengeNameCaps => 'ឈ្មោះការហាត់';

  @override
  String get challengeNameExample => 'ឧ. ការហាត់រត់ពេលព្រឹក';

  @override
  String get startDateCaps => 'ថ្ងៃចាប់ផ្ដើម';

  @override
  String get endDateCaps => 'ថ្ងៃបញ្ចប់';

  @override
  String get descriptionsCaps => 'ការពិពណ៌នា';

  @override
  String get challengeDescExample => 'ឧ. រត់ជុំវិញសួនឲ្យបាន ៥ ជុំជាប់គ្នា។';

  @override
  String get activityTypeCaps => 'ប្រភេទលំហាត់';

  @override
  String get moreActivity => 'លំហាត់ផ្សេងទៀត';

  @override
  String get challengeHasEnded => 'ការហាត់នេះបានបញ្ចប់ហើយ';

  @override
  String get descriptionsTitle => 'ការពិពណ៌នា';

  @override
  String get musclesBuiltBy => 'សាច់ដុំដែលបានហាត់ដោយ';

  @override
  String get createChallengeAgain => 'បង្កើតការហាត់នេះម្ដងទៀត?';

  @override
  String get joinClubChallenge => 'ចូលរួមការហាត់ក្លឹប';

  @override
  String get editYourDetails => 'កែព័ត៌មានរបស់អ្នក';

  @override
  String get yourDetails => 'ព័ត៌មានរបស់អ្នក';

  @override
  String get heightQuestion => 'តើអ្នកមានកម្ពស់ប៉ុន្មាន?';

  @override
  String get weightQuestion => 'បច្ចុប្បន្នអ្នកមានទម្ងន់ប៉ុន្មាន?';

  @override
  String get searchPeopleOnMovem => 'ស្វែងរកមនុស្សនៅលើ MoveM';

  @override
  String membersCountCaps(Object count) {
    return 'សមាជិក ($count)';
  }

  @override
  String get setGoal => 'កំណត់គោលដៅ';

  @override
  String get todaysWorkout => 'ការហាត់ថ្ងៃនេះ';

  @override
  String get smallStepBigChanges => 'ជំហានតូច ការផ្លាស់ប្ដូរធំ';

  @override
  String get startTrackingJourney =>
      'ចាប់ផ្ដើមតាមដានដំណើរហាត់ប្រាណរបស់អ្នកជាមួយយើងឥឡូវនេះ';

  @override
  String get caloriesBurnedTitle => 'កាឡូរីដែលបានដុត';

  @override
  String get clubSloganSpaced => 'ហាត់ច្រើន ល្អប្រសើរច្រើន';

  @override
  String get cueGetInPushUpPosition => 'ចូលទីតាំងពុះដី';

  @override
  String get noCamerasOnDevice => 'រកមិនឃើញកាមេរ៉ានៅលើឧបករណ៍នេះទេ';

  @override
  String get cameraPermissionNotGranted => 'មិនទាន់អនុញ្ញាតឲ្យប្រើកាមេរ៉ាទេ';

  @override
  String get simulationModePushUp => 'ម៉ូដសាកល្បង • ប៉ះអេក្រង់ដើម្បីរាប់';

  @override
  String get cueShouldersInFrame => 'ដាក់ស្មា និងដៃឲ្យនៅក្នុងកាមេរ៉ា';

  @override
  String get noPersonInFrame => 'រកមិនឃើញមនុស្សក្នុងកាមេរ៉ាទេ';

  @override
  String get adjustPosition => 'សូមកែទីតាំងឲ្យកាមេរ៉ាមើលឃើញ';

  @override
  String get setCompleted => 'ឈុតនេះរួចរាល់!';

  @override
  String setCompletedBody(Object set, Object total) {
    return 'ក្បាច់ល្អណាស់! អ្នកបានហាត់ឈុត $set ក្នុងចំណោម $total។ ត្រៀមខ្លួនសម្រាប់ឈុតបន្ទាប់ហើយឬនៅ?';
  }

  @override
  String get startNextSet => 'ចាប់ផ្ដើមឈុតបន្ទាប់';

  @override
  String get notSaved => 'មិនបានរក្សាទុក';

  @override
  String get workoutNotSaved =>
      'មិនអាចរក្សាទុកការហាត់ទៅម៉ាស៊ីនមេបានទេ។ សូមពិនិត្យការតភ្ជាប់។';

  @override
  String get squatsChallenge => 'ការហាត់អង្គុយក្រោក';

  @override
  String get squatsShortDescription => 'បន្ទាបត្រគាកពីការឈរ រួចក្រោកឈរវិញ។';

  @override
  String get strengthCategory => 'កម្លាំង';

  @override
  String get pullUpsName => 'ទាញខ្លួនឡើង';

  @override
  String get pullUpsDescription => 'លំហាត់ផ្នែកខាងលើ ដោយទាញខ្លួនឡើងលើរបារ។';

  @override
  String get upperBody => 'ផ្នែកខាងលើ';

  @override
  String get locationRequiredTitle => 'ត្រូវការទីតាំង';

  @override
  String get locationNeededForRun =>
      'ត្រូវការទីតាំង ដើម្បីតាមដានចម្ងាយ ល្បឿន និងផ្លូវរត់របស់អ្នក។';

  @override
  String get locationAccessRequired => 'ត្រូវការការអនុញ្ញាតទីតាំង';

  @override
  String get locationSettingsBody =>
      'MoveM ត្រូវការទីតាំង ដើម្បីតាមដានផ្លូវ ចម្ងាយ និងល្បឿនរត់របស់អ្នក។ សូមបើកការអនុញ្ញាតទីតាំងនៅក្នុងការកំណត់ឧបករណ៍។';

  @override
  String get locationServiceDisabled => 'សេវាទីតាំងត្រូវបានបិទ';

  @override
  String get turnOnGpsBody =>
      'សូមបើក GPS / សេវាទីតាំងនៅលើឧបករណ៍ ដើម្បីឲ្យ MoveM អាចកត់ត្រាការរត់របស់អ្នក។';

  @override
  String get turnOn => 'បើក';

  @override
  String get failedLoadWorkoutHistory => 'មិនអាចបង្ហាញប្រវត្តិហាត់ប្រាណបានទេ';

  @override
  String get cueFullView => 'សូមឈរឲ្យកាមេរ៉ាមើលឃើញខ្លួនទាំងមូល';

  @override
  String get simulationModeSquat => 'ម៉ូដសាកល្បង • ប៉ះកន្លែងណាក៏បានដើម្បីរាប់';

  @override
  String get cueStepBack => 'ថយក្រោយបន្តិច ឲ្យកាមេរ៉ាឃើញជើង';

  @override
  String setCompleteRest(Object set) {
    return 'ឈុតទី $set រួចរាល់! សម្រាកបន្តិចសិន។';
  }

  @override
  String get challengeComplete => 'ការហាត់រួចរាល់! 🏆';

  @override
  String get workoutPaused => 'បានផ្អាកការហាត់';

  @override
  String get resumingSquat => 'កំពុងបន្ត... តោះអង្គុយក្រោក!';

  @override
  String get fitnessChallenge => 'ការហាត់ប្រាណ';

  @override
  String get shareWorkout => 'ចែករំលែកការហាត់';

  @override
  String get shareNotSaved =>
      'ការហាត់នេះមិនទាន់រក្សាទុកទៅម៉ាស៊ីនមេទេ ដូច្នេះមិនអាចចែករំលែកបានទេ។';

  @override
  String get sharing => 'កំពុងចែករំលែក…';

  @override
  String get postingWorkout => 'កំពុងបង្ហោះការហាត់របស់អ្នកទៅព័ត៌មានថ្មី។';

  @override
  String get workoutShared => 'ការហាត់របស់អ្នកបានបង្ហោះទៅព័ត៌មានថ្មីហើយ។';

  @override
  String get shareFailed => 'ចែករំលែកមិនបាន';

  @override
  String get couldNotShareWorkout =>
      'មិនអាចចែករំលែកការហាត់នេះបានទេ។ សូមព្យាយាមម្ដងទៀត។';

  @override
  String get clubSlogan => 'ហាត់ច្រើន ល្អប្រសើរច្រើន។';

  @override
  String clubShareWithCode(Object name, Object code) {
    return 'មកចូលក្លឹប \"$name\" របស់ខ្ញុំនៅលើ MoveM! កូដ៖ $code';
  }

  @override
  String clubShare(Object name) {
    return 'មកចូលក្លឹប \"$name\" របស់ខ្ញុំនៅលើ MoveM!';
  }

  @override
  String get customizeOwnChallenge => 'បង្កើតការហាត់ផ្ទាល់ខ្លួន +';

  @override
  String get featuredChallenges => 'ការហាត់ពិសេសៗ';

  @override
  String get getStarted => 'ចាប់ផ្ដើម';

  @override
  String get clubTagline =>
      'ហាត់ប្រាណជាប្រចាំ លើកទឹកចិត្តគ្នា ហើយបញ្ចប់ការហាត់ជាមួយគ្នា។';

  @override
  String memberNumber(Object id) {
    return 'សមាជិក #$id';
  }

  @override
  String get goalCaps => 'គោលដៅ';

  @override
  String get endAction => 'បញ្ចប់';

  @override
  String get viewSummary => 'មើលសង្ខេប';

  @override
  String get shareCaps => 'ចែករំលែក';

  @override
  String get redoCaps => 'ហាត់ម្ដងទៀត';

  @override
  String get moreCaps => 'ផ្សេងទៀត';

  @override
  String get homeCaps => 'ទំព័រដើម';

  @override
  String get fitnessHeroTitle =>
      'ជំហានតូចថ្ងៃនេះ\nខ្លួនអ្នកខ្លាំងជាង\nនៅថ្ងៃស្អែក។';

  @override
  String get challengeEndedCaps => 'ការហាត់បានបញ្ចប់';

  @override
  String get defaultClubName => 'ក្លឹបហាត់ប្រាណ MoveM';

  @override
  String get clubDescriptionHint => 'ពិពណ៌នាអំពីក្លឹប និងអ្នកណាគួរចូលរួម...';

  @override
  String membersCountSpaced(Object count) {
    return 'សមាជិក ( $count )';
  }

  @override
  String get runningSession => 'វគ្គរត់';

  @override
  String get averagePaceCaps => 'ល្បឿនមធ្យម';

  @override
  String get waitingForGps => 'កំពុងរង់ចាំ GPS';

  @override
  String get gettingLocation => 'កំពុងរកទីតាំងរបស់អ្នក';

  @override
  String get moveOutdoors => 'សូមចេញទៅខាងក្រៅ ហើយព្យាយាមម្ដងទៀត';

  @override
  String get runStartsAfterGps => 'ការរត់ចាប់ផ្ដើមពេល GPS ភ្ជាប់រួច';

  @override
  String get retryGps => 'ព្យាយាម GPS ម្ដងទៀត';

  @override
  String get tapCircleToStart => 'ប៉ះរង្វង់ដើម្បីចាប់ផ្ដើមភ្លាម';

  @override
  String get stepCaps => 'ជំហាន';

  @override
  String get runPauseLeaveBody =>
      'ការរត់របស់អ្នកនឹងត្រូវផ្អាក។ តើអ្នកចង់ចាកចេញមែនទេ?';

  @override
  String get exitAction => 'ចាកចេញ';

  @override
  String unlockedOf(Object earned, Object total) {
    return 'បានដោះសោ $earned ក្នុងចំណោម $total';
  }

  @override
  String percentCompletedKeepPushing(Object percent) {
    return 'បានបញ្ចប់ $percent% • បន្តទៀត!';
  }

  @override
  String get earnedCaps => 'ទទួលបាន';

  @override
  String get kneeAngle => 'មុំជង្គង់';

  @override
  String get workoutWillEnd => 'ការហាត់នេះនឹងត្រូវបញ្ចប់។';

  @override
  String get finishAndSave => 'បញ្ចប់ និងរក្សាទុក';

  @override
  String get couldNotGetLocationOutdoors =>
      'មិនអាចរកទីតាំងរបស់អ្នកបានទេ។ សូមចេញទៅខាងក្រៅ ហើយព្យាយាមម្ដងទៀត។';

  @override
  String heightCmValue(Object height) {
    return '$height សង់ទីម៉ែត្រ';
  }

  @override
  String kcalValue(Object count) {
    return '$count កាឡូរី';
  }

  @override
  String get you => 'អ្នក';

  @override
  String itemDeleted(Object name) {
    return 'បានលុប $name';
  }

  @override
  String paceValueShort(Object pace) {
    return '$pace /គ.ម';
  }
}
