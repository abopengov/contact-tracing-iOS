import Foundation

class CoreDataPersistence: BlueTraceDataPersisting {
    func saveEncounter(encounterRecord: EncounterRecord) {
        encounterRecord.saveToCoreData()
    }
}
