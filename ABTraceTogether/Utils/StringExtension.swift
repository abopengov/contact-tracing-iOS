import Foundation

extension String {
    func localize() -> String {
        NSLocalizedString(
            self,
            tableName: "",
            bundle: BKLocalizationManager.sharedInstance.currentBundle,
            value: BKLocalizationManager.sharedInstance.defaultStrings[self] ?? "",
            comment: ""
        )
    }
}
