import CoreData
import UIKit

final class InfoViewController: UIViewController {
    @IBOutlet private var devicesEncounteredLabel: UILabel!
    @IBOutlet private var clearLogsButton: UIButton!
    @IBOutlet private var heraldSwitch: UISwitch!
    private var devicesEncounteredCount: Int?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDevicesEncounteredCount()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        heraldSwitch.addTarget(self, action: #selector(self.heraldSwitchChanged), for: UIControl.Event.valueChanged)
        clearLogsButton.addTarget(self, action: #selector(self.clearLogsButtonClicked), for: .touchUpInside)
    }

    @IBAction private func logoutBtn(_ sender: UIButton) {
        guard let navController = self.navigationController,
            let storyboard = navController.storyboard else {
            return
        }
        let introVC = storyboard.instantiateViewController(withIdentifier: "intro")
        navController.setViewControllers([introVC], animated: false)
    }

    @objc
    func fetchDevicesEncounteredCount() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Encounter")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["msg"]
        fetchRequest.returnsDistinctResults = true

        do {
            let devicesEncountered = try managedContext.fetch(fetchRequest)
            self.devicesEncounteredLabel.text = String(devicesEncountered.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    @objc
    func heraldSwitchChanged(mySwitch: UISwitch) {
        return mySwitch.isOn ? HeraldManager.shared.start() : HeraldManager.shared.stop()
    }

    @objc
    func clearLogsButtonClicked() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Encounter>(entityName: "Encounter")
        fetchRequest.includesPropertyValues = false
        do {
            let encounters = try managedContext.fetch(fetchRequest)
            for encounter in encounters {
                managedContext.delete(encounter)
            }
            try managedContext.save()
        } catch {
            print("Could not perform delete. \(error)")
        }
    }
}
