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
