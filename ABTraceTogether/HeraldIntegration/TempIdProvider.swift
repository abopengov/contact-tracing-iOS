import Foundation

class ConcreteTempIdProvider: TempIdProvidable {
    func getTempId() -> String? {
        EncounterMessageManager.shared.tempId
    }

    func fetchNewTempId(onComplete: @escaping (String?) -> Void) {
        EncounterMessageManager.shared.getTempId(onComplete: onComplete)
    }
}
