// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Remove
  internal static let alertRemoveAction = L10n.tr("Localizable", "alert_remove_action")
  /// note(s) will be removerd. Are you sure?
  internal static let alertRemoveText = L10n.tr("Localizable", "alert_remove_text")
  /// Removing
  internal static let alertRemoveTitle = L10n.tr("Localizable", "alert_remove_title")
  /// Unschedule
  internal static let alertScheduleAction = L10n.tr("Localizable", "alert_schedule_action")
  /// Note will be unscheduled. Are you sure?
  internal static let alertScheduleText = L10n.tr("Localizable", "alert_schedule_text")
  /// Unscheduling
  internal static let alertScheduleTitle = L10n.tr("Localizable", "alert_schedule_title")
  /// Default
  internal static let colorNameBase = L10n.tr("Localizable", "color_name_base")
  /// Blue
  internal static let colorNameBlue = L10n.tr("Localizable", "color_name_blue")
  /// Cream
  internal static let colorNameCream = L10n.tr("Localizable", "color_name_cream")
  /// Green
  internal static let colorNameGreen = L10n.tr("Localizable", "color_name_green")
  /// Pink
  internal static let colorNamePink = L10n.tr("Localizable", "color_name_pink")
  /// Purple
  internal static let colorNamePurple = L10n.tr("Localizable", "color_name_purple")
  /// today
  internal static let dateStringToday = L10n.tr("Localizable", "date_string_today")
  /// tomorrow
  internal static let dateStringTomorrow = L10n.tr("Localizable", "date_string_tomorrow")
  /// Cancel
  internal static let mainCancelAction = L10n.tr("Localizable", "main_cancel_action")
  /// Error
  internal static let mainError = L10n.tr("Localizable", "main_error")
  /// Unable to delete from database
  internal static let mainErrorDeleteDb = L10n.tr("Localizable", "main_error_delete_db")
  /// Notes
  internal static let mainNavigationbarTitle = L10n.tr("Localizable", "main_navigationbar_title")
  /// Pin
  internal static let mainPinAction = L10n.tr("Localizable", "main_pin_action")
  /// Categories
  internal static let menuCategoriesTitle = L10n.tr("Localizable", "menu_categories_title")
  /// Colors
  internal static let menuColorsTitle = L10n.tr("Localizable", "menu_colors_title")
  /// No content is matching your request
  internal static let noContentText = L10n.tr("Localizable", "no_content_text")
  /// No content
  internal static let noContentTitle = L10n.tr("Localizable", "no_content_title")
  /// Other
  internal static let noteCategoryOther = L10n.tr("Localizable", "note_category_other")
  /// Personal
  internal static let noteCategoryPersonal = L10n.tr("Localizable", "note_category_personal")
  /// Pinned
  internal static let noteCategoryPinned = L10n.tr("Localizable", "note_category_pinned")
  /// Work
  internal static let noteCategoryWork = L10n.tr("Localizable", "note_category_work")
  /// Schedule
  internal static let scheduleButtonTitle = L10n.tr("Localizable", "schedule_button_title")
  /// Enter text...
  internal static let textviewPlaceholderText = L10n.tr("Localizable", "textview_placeholder_text")
  /// Enter title...
  internal static let textviewPlaceholderTitle = L10n.tr("Localizable", "textview_placeholder_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
