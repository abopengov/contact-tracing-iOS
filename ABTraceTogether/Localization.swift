import Foundation
import UIKit
// swiftlint:disable nslocalizedstring_require_bundle
let daysToQuarantine = 14
let userDefaultsPinKey = "HEALTH_AUTH_VERIFICATION_CODE"

// Tab Bar Titles
let homeTabTitle = "menu_home"
let uploadTabTitle = "menu_statistics"
let faqTabTitle = "menu_help"
let guidanceTabTitle = "menu_guidance"

// MARK: - Register UUID
let isRegisteredUrlString = "/adapters/smsOtpService/phone/isRegistered"
let uploadExposuresURLString = "/adapters/uploadDiagnosisKeys"
let phoneNumberRegistrationUrlString = "/adapters/smsOtpService/phone/register/"
let otpVerificationUrlString = "/adapters/smsOtpService/phone/verifySmsOTP"

let lastDownloadedDateKey = "LastDownloadedDate"
let userid = UserDefaults.standard.string(forKey: userDefaultsPinKey) ?? "None"
let regions = [region] // provice ids
let region = "CA_CA"

// MARK: - General
let nextButtonText = "next_button"
let doneButtonText = "doneButtonText"

// MARK: - Welcome Screen
let welcomeScreenHeader = "tv_onboarding_title_iOS"
let welcomeScreenSubHeader = "tv_onboarding_desc"
let welcomeScreenButton = "i_want_to_help"
let generalLogoMessageString = "tv_onboarding_desc_sub"

// How It Works
let howItWorksWillTitle = "howitworks_will_title"
let howItWorksWillSublabel1 = "howitworks_will_sublabel1"
let howItWorksWillSublabel2 = "howitworks_will_sublabel2"
let howItWorksWillSublabel3 = "howitworks_will_sublabel3"
let howItWorksWillSublabel4 = "howitworks_will_sublabel4"
let howItWorksThisAppWillNotTitle = "howitworks_not_title"
let howItWorksWillNotSublabel1 = "howitworks_not_sublabel1"
let howItWorksWillNotSublabel2 = "howitworks_not_sublabel2"
let continueButtonString = "continue_button"

// Explanation
let explanationHeader = "explanation_will_ask_title"
let explanationSublabel1 = "explanation_sublabel1"
let explanationInfoLabel1 = "explanation_info_label1"
let explanationSublabel2 = "explanation_sublabel2"
let explanationInfoLabel2 = "explanation_info_label2"
let explanationSublabel3 = "explanation_sublabel3"
let explanationInfoLabel3 = "explanation_info_label3"
let explanationSublabel4 = "explanation_sublabel4"
let explanationInfoLabel4 = "explanation_info_label4"

// MARK: - Privacy

let privacyHeader = "privacy_policy_title"
let privacyDescription = "privacy_description"
let privacy_policy_text1 = "privacy_policy_text1"
let privacy_policy_text2 = "privacy_policy_text2"
let privacy_policy_text3 = "privacy_policy_text3"
let privacy_policy_text4 = "privacy_policy_text4"
let privacy_policy_text5 = "privacy_policy_text5"
let privacy_policy_text6 = "privacy_policy_text6"
let privacy_policy_text6_key = "privacy_policy_text6_key"
let privacy_policy_text7 = "privacy_policy_text7"
let privacy_policy_text8 = "privacy_policy_text8"
let privacy_policy_text9 = "privacy_policy_text9"
let privacy_policy_text9_key = "privacy_policy_text9_key"
let privacy_policy_text10 = "privacy_policy_text10"
let privacy_policy_text11 = "privacy_policy_text11"
let privacy_policy_text12 = "privacy_policy_text12"

let privacyFaqButtonText = "view_faq"
let privacyPolicyButtonText = "view_privacy"
let privacyLink = UserDefaults.standard.string(forKey: privacyUrlKey) ?? "https://privacyUrl"
let privacyFaqLink = UserDefaults.standard.string(forKey: faqUrlKey) ?? "https://faqUrl"
let privacyIAgreeLabelText = "agreement"
let privacyButtonColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)

// MARK: - Phone Registration
let phoneNumberRegistrationStepNumberText = "ios_enter_number_step"
let phoneNumberRegistrationHeaderText = "register_number"
let phoneNumberRegistrationPhoneNumberPlaceHolderText = "enter_number_placeholder"
let phoneNumberRegistrationSubHeaderText = "register_number_desc_iOS"
let phoneNumberRegistrationGetOTPButtonText = "next_button"
let phoneNumberConnectionError = "phone_error_connection"
let phoneNumberInvalidPinError = "invalid_otp"

// MARK: - OTP Verification
let otpScreenStepNumberText = "ios_enter_code_step"
let otpScreenHeaderText = "enter_otp"
let otpScreenSubHeaderTextP1 = "otp_sent_iOS1"
let otpScreenSubHeaderTextP2 = "otp_sent_iOS2"
let otpScreenCodeExpireText = "otp_countdown_ios"
let otpScreenCodeHasExpiredText = "otp_countdown_expired"
let otpScreenDidntReceiveCodeText = "resend_code_label"
let otpScreenRequestAnotherCodeButtonText = "resend_code"
let otpScreenGetOTPButtonText = "next_button"
let otpScreenInvalidOTP = "must_be_six_digit"
let otpScreenWrongOTP = "WrongOTP"

// MARK: - Permission Screen

let permissionHeader1 = "permission_header1"
let permissionDetail1 = "permission_detail1"
let permissionStep1 = "ios_permissions_step1"

// MARK: - Bluetooth Message Screen
let bluetoothMessageHeader = "bluetooth_message_header"
let bluetoothMessageDetail = "bluetooth_message_detail"
let bluetoothMessageStep = "ios_permission_step2"

// MARK: - Location Permission Screen
let locationPermissionMessageHeader = "locationPermission_message_header"
let locationPermissionMessageDetail = "locationPermission_message_detail"
let locationPermissionMessageStep = "ios_permissions_step3"

// MARK: - Registration Successful
let registrationSuccessfulHeader = "app_permission_fully_setup"
let registrationSuccessfulDetail = "app_permission_fully_setup_desc"
let registrationSuccessfulFinishButtonText = "finish_button"

// Url keys and app delagate
let statisticsKey = "StatisticsSummaryUrlKey"
let guidanceKey = "guidanceKey"
let gisKey = "gisKey"
let helpEmailKey = "helpEmail"
let caseSummaryKey = "caseSummaryUrlKey"
let faqUrlKey = "faqUrlKey"
let privacyUrlKey = "privacyUrlKey"
let mhrKey = "mhr_key"
let registeredApi = "/adapters/smsOtpService/phone/isRegistered"
let getUrlsApi = "/adapters/applicationDataAdapter/getUrls"
let getMethodString = "GET"
let noExistingAppString = "APPLICATION_DOES_NOT_EXIST"
let notificationNameUrl = "urlFetched"
let killSwitchMessageString = "wrong_version_msg"
let errorCodeString = "errorCode"

// Header View Strings
let homeHeader = "home_title_iOS"
let homeHeaderMessage = "home_subtitle"
let versionString = NSLocalizedString(
    "app_version_label_iOS",
    tableName: "",
    bundle: BKLocalizationManager.sharedInstance.currentBundle,
    value: BKLocalizationManager.sharedInstance.defaultStrings["app_version_label_iOS"] ?? "",
    comment: ""
)

let versionLabelString = UIApplication.appVersion != nil ? "\(versionString) \(UIApplication.appVersion ?? "") \(HomeScreenEnum.getVersionIdentifierForEnvironment())": nil
let lastUpdated = "last_updated_label"

// Upload Data Home View Strings
let uploadDataHomeHeader = "menu_upload"
let uploadDataHomeMessage = "home_upload_title"
let uploadDataHomeButton = "menu_upload"

// Case Summary View Strings
let homeCaseSummaryHeader = "highlights"
let homeCaseSummaryButton = "home_case_summary_button"

// App Permissions View Strings
let homeAppPermissionsHeader = "app_permission_status"
let homeStatusIconOn = "StatusIconOn"
let homeStatusIconOff = "StatusIconOff"
let homePermissionsEnabledNo = "home_permissions_enabled_no"
let homePermissionsEnabledYes = "home_permissions_enabled_yes"
let homeBluetoothEnabledNo = "home_bluetooth_enabled_no"
let homeBluetoothEnabledYes = "home_bluetooth_enabled_yes"
let homePushNotificationsEnabledNo = "home_push_notifications_enabled_no"
let homePushNotificationsEnabledYes = "home_push_notifications_enabled_yes"
let homeLocationPermissionsEnabledNo = "home_location_permissions_enabled_no"
let homeLocationPermissionsEnabledYes = "home_location_permissions_enabled_yes"
let homeLocationPermissionRequired = "home_location_permission_required"
let homeLocationPermissionRequiredMessage = "home_location_permission_required_message"
let homePermissionsTitle = "home_permissions_title"
let homePermissionsMessage = "app_permission_hint"
let homePermissionsDone = "alert_done"

// Message View Strings
let homeMessageHeader = "info_title"
let homeMessageDetailedMessage = "info_desc_iOS"

// Share App View Strings
let homeShareAppHeader = "share_this_app"
let homeShareAppMessage = "ask_friend"
let shareText = "share_message_iOS"

// Map View Controller Strings
let mapHeaderLabelString = "map_header"
let mapMessageLabelString = "menu_subheader"
let mapToggleMapOption = "map_map"
let mapToggleListOption = "map_list"

// Help View Controller Error String
let generalErrorTitleString = "alert_title"
let generalWebViewErrorMessage = "alert_message"
let generalDoneString = "alert_done"

// Upload Data Colours
let mhrButtonColour = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
let mhrBorderButtonColour = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)

// Upload Data Page
let backButtonString = "backButtonString"
let uploadDataHeaderString = "ahs_only_iOS"
let uploadDataSubheaderString = "tap_next"
let ctButton = "proceed_with_a_ct"
let mhrButton = "proceed_through_mhr"

// Upload Data Page 1
let uploadStep1Header = "verify"
let uploadStep1Subheader = "code_match_iOS"
let uploadStep1Button = "next_button"

// Upload Data Page 2
let uploadStep2Header = "enter_pin_title"
let uploadStep2SubHeader = "upload_step2_subheader"
let systemErrorMessage = "system_error"
let uploadvc2Done = "doneButtonText"
let uploadInvalidPin = "upload_invalid_pin"
let uploadFailMessage = "upload_fail_error"
let uploadDataButtonString = "upload_button"

// Upload Data Success
let uploadSuccessButton = "finish_button"
let uploadSuccessHeader = "upload_complete_title"
let uploadSuccessSubHeader = "upload_complete_desc"

// MARK: - Common Constraints Constants for Permissions Screens
let imageOffsetTop = CGFloat(100)
let subHeaderOffsetTop = CGFloat(50)
let headerOffsetTop = CGFloat(5)
let bigButtonFont = UIFont(name: "HelveticaNeue-Bold", size: 18)

let onboardingPhoneAlertTitle = "optional_alert_title"
let onboardingphoneAlertMessage = "optional_alert_message"
let onboardingPhoneoptionYes = "option_yes"
let onboardingPhoneoptionNo = "option_no"

let linkButtonAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont(
        name: "HelveticaNeue",
        size: 14
    ) ?? UIFont.systemFont(ofSize: 14),
    .foregroundColor: UIColor.blue,
]

let homeScreenBackgroundColor = UIColor.white
let LanguageChangeNotification = "LanguageChanged"
