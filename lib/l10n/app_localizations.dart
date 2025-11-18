import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Zyntra'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Zyntra!'**
  String get welcome;

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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register here'**
  String get noAccount;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by: Aguirre & Díaz'**
  String get developedBy;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height (m)'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// No description provided for @trainingLevel.
  ///
  /// In en, this message translates to:
  /// **'Training Level'**
  String get trainingLevel;

  /// No description provided for @recruit.
  ///
  /// In en, this message translates to:
  /// **'Recruit'**
  String get recruit;

  /// No description provided for @cadet.
  ///
  /// In en, this message translates to:
  /// **'Cadet'**
  String get cadet;

  /// No description provided for @warrior.
  ///
  /// In en, this message translates to:
  /// **'Warrior'**
  String get warrior;

  /// No description provided for @gladiator.
  ///
  /// In en, this message translates to:
  /// **'Gladiator'**
  String get gladiator;

  /// No description provided for @elite.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get elite;

  /// No description provided for @master.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get master;

  /// No description provided for @titan.
  ///
  /// In en, this message translates to:
  /// **'Titan'**
  String get titan;

  /// No description provided for @legend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legend;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterAge;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get enterHeight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight'**
  String get enterWeight;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get enterPassword;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @minCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minCharacters;

  /// No description provided for @userRegistered.
  ///
  /// In en, this message translates to:
  /// **'User registered successfully ✅'**
  String get userRegistered;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error while signing in'**
  String get loginError;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful ✅'**
  String get loginSuccess;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @trainings.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get trainings;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @gymTitle.
  ///
  /// In en, this message translates to:
  /// **'Virtual Gym'**
  String get gymTitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @dataUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully ✅'**
  String get dataUpdated;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @vipAvatars.
  ///
  /// In en, this message translates to:
  /// **'VIP Avatars'**
  String get vipAvatars;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'coins'**
  String get coins;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @notEnoughCoins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins 💸'**
  String get notEnoughCoins;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'You purchased {item} ✅'**
  String purchaseSuccess(Object item);

  /// No description provided for @userCoinsLabel.
  ///
  /// In en, this message translates to:
  /// **'💰 {amount} coins'**
  String userCoinsLabel(Object amount);

  /// No description provided for @gripGloves.
  ///
  /// In en, this message translates to:
  /// **'Nitrotech performance'**
  String get gripGloves;

  /// No description provided for @powerBelt.
  ///
  /// In en, this message translates to:
  /// **'Crea Bolic'**
  String get powerBelt;

  /// No description provided for @nonSlipBoots.
  ///
  /// In en, this message translates to:
  /// **'Rack'**
  String get nonSlipBoots;

  /// No description provided for @titanGold.
  ///
  /// In en, this message translates to:
  /// **'Golden Titan'**
  String get titanGold;

  /// No description provided for @cyberWarrior.
  ///
  /// In en, this message translates to:
  /// **'Cyber Warrior'**
  String get cyberWarrior;

  /// No description provided for @masterPower.
  ///
  /// In en, this message translates to:
  /// **'Master of Power'**
  String get masterPower;

  /// No description provided for @accessoryDescription1.
  ///
  /// In en, this message translates to:
  /// **'Scientifically developed whey isolate formula.'**
  String get accessoryDescription1;

  /// No description provided for @accessoryDescription2.
  ///
  /// In en, this message translates to:
  /// **'Powder that combines isomaltulose and amino acids'**
  String get accessoryDescription2;

  /// No description provided for @accessoryDescription3.
  ///
  /// In en, this message translates to:
  /// **'Hexagonal Dumbbell Rack'**
  String get accessoryDescription3;

  /// No description provided for @avatarDescription1.
  ///
  /// In en, this message translates to:
  /// **'Legendary four-legged avatar'**
  String get avatarDescription1;

  /// No description provided for @avatarDescription2.
  ///
  /// In en, this message translates to:
  /// **'Futuristic design with green energy'**
  String get avatarDescription2;

  /// No description provided for @avatarDescription3.
  ///
  /// In en, this message translates to:
  /// **'Exclusive elite avatar'**
  String get avatarDescription3;

  /// No description provided for @rechargeSuccess.
  ///
  /// In en, this message translates to:
  /// **'You earned 500 coins 💰'**
  String get rechargeSuccess;

  /// No description provided for @purchaseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Purchased ✅'**
  String get purchaseCompleted;

  /// No description provided for @adLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading ad... please try again'**
  String get adLoading;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activated.
  ///
  /// In en, this message translates to:
  /// **'activated!'**
  String get activated;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'deactivated!'**
  String get deactivated;

  /// No description provided for @strength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get strength;

  /// No description provided for @endurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get endurance;

  /// No description provided for @flexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get flexibility;

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level Progress'**
  String get levelProgress;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @resistance.
  ///
  /// In en, this message translates to:
  /// **'Resistance'**
  String get resistance;

  /// No description provided for @force.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get force;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @planSomething.
  ///
  /// In en, this message translates to:
  /// **'Plan a workout while the day is still young!'**
  String get planSomething;

  /// No description provided for @planNow.
  ///
  /// In en, this message translates to:
  /// **'Plan something'**
  String get planNow;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any events yet'**
  String get noEventsYet;

  /// No description provided for @plannedEvents.
  ///
  /// In en, this message translates to:
  /// **'Planned Events'**
  String get plannedEvents;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields'**
  String get completeAllFields;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Event description'**
  String get eventDescription;

  /// No description provided for @planEvent.
  ///
  /// In en, this message translates to:
  /// **'Plan a new event'**
  String get planEvent;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Resistance training'**
  String get training;

  /// No description provided for @progress_r.
  ///
  /// In en, this message translates to:
  /// **'Resistance progress'**
  String get progress_r;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'🏆 Congratulations! You have earned 100 points'**
  String get congratulations;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'🔥 Excellent! Your stamina has increased'**
  String get excellent;

  /// No description provided for @r_name1.
  ///
  /// In en, this message translates to:
  /// **'Strenuous hike'**
  String get r_name1;

  /// No description provided for @r_name2.
  ///
  /// In en, this message translates to:
  /// **'Skipping rope'**
  String get r_name2;

  /// No description provided for @r_name3.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get r_name3;

  /// No description provided for @r_name4.
  ///
  /// In en, this message translates to:
  /// **'Go up stairs'**
  String get r_name4;

  /// No description provided for @r_description1.
  ///
  /// In en, this message translates to:
  /// **'Walk briskly for 30 minutes'**
  String get r_description1;

  /// No description provided for @r_description2.
  ///
  /// In en, this message translates to:
  /// **'Perform 3 sets of 2 minutes of jumping'**
  String get r_description2;

  /// No description provided for @r_description3.
  ///
  /// In en, this message translates to:
  /// **'Cycle for 40 minutes at a moderate pace'**
  String get r_description3;

  /// No description provided for @r_description4.
  ///
  /// In en, this message translates to:
  /// **'Climb stairs for 10 minutes without stopping'**
  String get r_description4;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add new exercise'**
  String get add;

  /// No description provided for @name_add.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get name_add;

  /// No description provided for @des_add.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get des_add;

  /// No description provided for @aum_add.
  ///
  /// In en, this message translates to:
  /// **'Progress increase (0.01 - 0.2)'**
  String get aum_add;

  /// No description provided for @btn_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btn_add;

  /// No description provided for @btn_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btn_cancel;

  /// No description provided for @nutrition_title.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Plans'**
  String get nutrition_title;

  /// No description provided for @nutrition_progress.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Progress'**
  String get nutrition_progress;

  /// No description provided for @diet_name1.
  ///
  /// In en, this message translates to:
  /// **'Balanced Diet'**
  String get diet_name1;

  /// No description provided for @diet_desc1.
  ///
  /// In en, this message translates to:
  /// **'Includes fruits, vegetables, lean proteins and whole grains.'**
  String get diet_desc1;

  /// No description provided for @diet_name2.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get diet_name2;

  /// No description provided for @diet_desc2.
  ///
  /// In en, this message translates to:
  /// **'Based on lean meats, legumes and eggs. Ideal for muscle growth.'**
  String get diet_desc2;

  /// No description provided for @diet_name3.
  ///
  /// In en, this message translates to:
  /// **'Healthy Vegan'**
  String get diet_name3;

  /// No description provided for @diet_desc3.
  ///
  /// In en, this message translates to:
  /// **'Focused on plant foods rich in fiber and antioxidants.'**
  String get diet_desc3;

  /// No description provided for @diet_name4.
  ///
  /// In en, this message translates to:
  /// **'Low Calorie Definition'**
  String get diet_name4;

  /// No description provided for @diet_desc4.
  ///
  /// In en, this message translates to:
  /// **'Designed to reduce fat while preserving muscle masa.'**
  String get diet_desc4;

  /// No description provided for @nutrition_improved.
  ///
  /// In en, this message translates to:
  /// **'🥗 Great! Your nutrition progress has improved.'**
  String get nutrition_improved;

  /// No description provided for @nutrition_congrats.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations! You earned 100 points for your nutrition progress.'**
  String get nutrition_congrats;

  /// No description provided for @nutrition_add_title.
  ///
  /// In en, this message translates to:
  /// **'Add New Diet'**
  String get nutrition_add_title;

  /// No description provided for @nutrition_add_name.
  ///
  /// In en, this message translates to:
  /// **'Diet Name'**
  String get nutrition_add_name;

  /// No description provided for @cat_chest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get cat_chest;

  /// No description provided for @cat_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get cat_back;

  /// No description provided for @cat_biceps.
  ///
  /// In en, this message translates to:
  /// **'Biceps'**
  String get cat_biceps;

  /// No description provided for @cat_triceps.
  ///
  /// In en, this message translates to:
  /// **'Triceps'**
  String get cat_triceps;

  /// No description provided for @cat_forearm.
  ///
  /// In en, this message translates to:
  /// **'Forearm'**
  String get cat_forearm;

  /// No description provided for @cat_abs.
  ///
  /// In en, this message translates to:
  /// **'Abdomen'**
  String get cat_abs;

  /// No description provided for @force_title.
  ///
  /// In en, this message translates to:
  /// **'Strength Training'**
  String get force_title;

  /// No description provided for @force_progress.
  ///
  /// In en, this message translates to:
  /// **'Strength Progress'**
  String get force_progress;

  /// No description provided for @force_add_title.
  ///
  /// In en, this message translates to:
  /// **'Add New Exercise'**
  String get force_add_title;

  /// No description provided for @force_add_name.
  ///
  /// In en, this message translates to:
  /// **'Exercise Name'**
  String get force_add_name;

  /// No description provided for @force_add_desc.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get force_add_desc;

  /// No description provided for @force_add_cat.
  ///
  /// In en, this message translates to:
  /// **'Muscle Category'**
  String get force_add_cat;

  /// No description provided for @force_add_inc.
  ///
  /// In en, this message translates to:
  /// **'Progress Increment (0.01 - 0.2)'**
  String get force_add_inc;

  /// No description provided for @force_congrats.
  ///
  /// In en, this message translates to:
  /// **'🏋️‍♂️ Incredible! You\'ve earned 100 points.'**
  String get force_congrats;

  /// No description provided for @force_improved.
  ///
  /// In en, this message translates to:
  /// **'💪 Excellent! Your strength has increased.'**
  String get force_improved;

  /// No description provided for @f_name1.
  ///
  /// In en, this message translates to:
  /// **'Bench Press'**
  String get f_name1;

  /// No description provided for @f_desc1.
  ///
  /// In en, this message translates to:
  /// **'Classic exercise for developing the chest.'**
  String get f_desc1;

  /// No description provided for @f_name2.
  ///
  /// In en, this message translates to:
  /// **'Push-ups'**
  String get f_name2;

  /// No description provided for @f_desc2.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight exercise for strength and endurance.'**
  String get f_desc2;

  /// No description provided for @f_name3.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell Flyes'**
  String get f_name3;

  /// No description provided for @f_desc3.
  ///
  /// In en, this message translates to:
  /// **'Works the pectoralis major muscles with a wide range of motion.'**
  String get f_desc3;

  /// No description provided for @f_name4.
  ///
  /// In en, this message translates to:
  /// **'Pull-ups'**
  String get f_name4;

  /// No description provided for @f_desc4.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the back and biceps.'**
  String get f_desc4;

  /// No description provided for @f_name5.
  ///
  /// In en, this message translates to:
  /// **'Barbell row'**
  String get f_name5;

  /// No description provided for @f_desc5.
  ///
  /// In en, this message translates to:
  /// **'Develops the mid-back.'**
  String get f_desc5;

  /// No description provided for @f_name6.
  ///
  /// In en, this message translates to:
  /// **'Deadlift'**
  String get f_name6;

  /// No description provided for @f_desc6.
  ///
  /// In en, this message translates to:
  /// **'Compound exercise that engages the entire back.'**
  String get f_desc6;

  /// No description provided for @f_name7.
  ///
  /// In en, this message translates to:
  /// **'Barbell curl'**
  String get f_name7;

  /// No description provided for @f_desc7.
  ///
  /// In en, this message translates to:
  /// **'Increases bicep size and strength.'**
  String get f_desc7;

  /// No description provided for @f_name8.
  ///
  /// In en, this message translates to:
  /// **'Dumbbell curl'**
  String get f_name8;

  /// No description provided for @f_desc8.
  ///
  /// In en, this message translates to:
  /// **'Allows for a more natural and controlled movement.'**
  String get f_desc8;

  /// No description provided for @f_name9.
  ///
  /// In en, this message translates to:
  /// **'Hammer curl'**
  String get f_name9;

  /// No description provided for @f_desc9.
  ///
  /// In en, this message translates to:
  /// **'Works the brachialis and forearm.'**
  String get f_desc9;

  /// No description provided for @f_name10.
  ///
  /// In en, this message translates to:
  /// **'Parallel Bar Dips'**
  String get f_name10;

  /// No description provided for @f_desc10.
  ///
  /// In en, this message translates to:
  /// **'A demanding exercise for triceps and chest.'**
  String get f_desc10;

  /// No description provided for @f_name11.
  ///
  /// In en, this message translates to:
  /// **'Rope Extensions'**
  String get f_name11;

  /// No description provided for @f_desc11.
  ///
  /// In en, this message translates to:
  /// **'Ideal for defining the triceps.'**
  String get f_desc11;

  /// No description provided for @f_name12.
  ///
  /// In en, this message translates to:
  /// **'French Press'**
  String get f_name12;

  /// No description provided for @f_desc12.
  ///
  /// In en, this message translates to:
  /// **'Focuses on the long head of the triceps.'**
  String get f_desc12;

  /// No description provided for @f_name13.
  ///
  /// In en, this message translates to:
  /// **'Wrist Curl'**
  String get f_name13;

  /// No description provided for @f_desc13.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the forearm flexor muscles.'**
  String get f_desc13;

  /// No description provided for @f_name14.
  ///
  /// In en, this message translates to:
  /// **'Reverse Curl'**
  String get f_name14;

  /// No description provided for @f_desc14.
  ///
  /// In en, this message translates to:
  /// **'Works extensors and the upper part of the forearm.'**
  String get f_desc14;

  /// No description provided for @f_name15.
  ///
  /// In en, this message translates to:
  /// **'Towel Hold'**
  String get f_name15;

  /// No description provided for @f_desc15.
  ///
  /// In en, this message translates to:
  /// **'Develops grip strength.'**
  String get f_desc15;

  /// No description provided for @f_name16.
  ///
  /// In en, this message translates to:
  /// **'Abdominal Crunches'**
  String get f_name16;

  /// No description provided for @f_desc16.
  ///
  /// In en, this message translates to:
  /// **'Basic exercise for the upper abs.'**
  String get f_desc16;

  /// No description provided for @f_name17.
  ///
  /// In en, this message translates to:
  /// **'Plank'**
  String get f_name17;

  /// No description provided for @f_desc17.
  ///
  /// In en, this message translates to:
  /// **'Strengthens the entire core.'**
  String get f_desc17;

  /// No description provided for @f_name18.
  ///
  /// In en, this message translates to:
  /// **'Leg raises'**
  String get f_name18;

  /// No description provided for @f_desc18.
  ///
  /// In en, this message translates to:
  /// **'Works the lower abs and stability.'**
  String get f_desc18;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @yourFriends.
  ///
  /// In en, this message translates to:
  /// **'Your Friends'**
  String get yourFriends;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'You have no friends yet'**
  String get noFriendsYet;

  /// No description provided for @removeFriend.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeFriend;

  /// No description provided for @uno.
  ///
  /// In en, this message translates to:
  /// **'There are no users to display'**
  String get uno;

  /// No description provided for @dos.
  ///
  /// In en, this message translates to:
  /// **'Application sent'**
  String get dos;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @noUsersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get noUsersAvailable;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent'**
  String get requestSent;

  /// No description provided for @tres.
  ///
  /// In en, this message translates to:
  /// **'Friend requests'**
  String get tres;

  /// No description provided for @cua.
  ///
  /// In en, this message translates to:
  /// **'You have no pending applications'**
  String get cua;

  /// No description provided for @six.
  ///
  /// In en, this message translates to:
  /// **'Application accepted'**
  String get six;

  /// No description provided for @sev.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get sev;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
