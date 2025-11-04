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
  /// **'Pro Crown'**
  String get gripGloves;

  /// No description provided for @powerBelt.
  ///
  /// In en, this message translates to:
  /// **'Power Rug'**
  String get powerBelt;

  /// No description provided for @nonSlipBoots.
  ///
  /// In en, this message translates to:
  /// **'Non-slip Boots'**
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
  /// **'Show your shine'**
  String get accessoryDescription1;

  /// No description provided for @accessoryDescription2.
  ///
  /// In en, this message translates to:
  /// **'It flies through the air'**
  String get accessoryDescription2;

  /// No description provided for @accessoryDescription3.
  ///
  /// In en, this message translates to:
  /// **'Control your life'**
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
