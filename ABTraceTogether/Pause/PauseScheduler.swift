import BackgroundTasks
import Foundation
import UIKit

class PauseScheduler {
    private let backgroundIdentifier = "com.example.tracetogether.pause"
    private var timer: PauseTimer?

    weak var delegate: PauseSchedulerDelegate?

    static let shared = PauseScheduler()

    var pauseTimeSet: Bool {
        get {
            UserDefaults.standard.object(forKey: "pauseTimeSet") as? Bool ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "pauseTimeSet")
        }
    }

    var startTime: Date? {
        get {
            UserDefaults.standard.object(forKey: "pauseStartTime") as? Date
                ?? Date().setTime(hour: 0, minute: 0)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "pauseStartTime")
        }
    }

    var endTime: Date? {
        get {
            UserDefaults.standard.object(forKey: "pauseEndTime") as? Date
                ?? Date().setTime(hour: 8, minute: 0)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "pauseEndTime")
        }
    }

    func setup() {
        if #available(iOS 13, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundIdentifier, using: nil) { task in
                Logger.DLog("Background pause task started")

                self.handlePauseEvent()
                self.scheduleBackground()

                task.setTaskCompleted(success: true)
            }
        }
        schedule()
    }

    var withinPauseSchedule: Bool {
        guard pauseTimeSet else {
            return false
        }

        guard let startTime = startTime, let endTime = endTime else {
            return false
        }

        return Date().withinTimePeriod(startTime: startTime, endTime: endTime)
    }

    func togglePause() {
        if withinPauseSchedule {
            HeraldManager.shared.stop()
        } else {
            HeraldManager.shared.start()
        }
    }

    func schedule() {
        if hasPauseSchedule() {
            scheduleForeground()
            scheduleBackground()
            Logger.DLog("Pause scheduled")
        }
    }

    func cancel() {
        Logger.DLog("Pause Canceled")
        timer = nil

        if #available(iOS 13, *) {
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: backgroundIdentifier)
        } else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)
        }
    }

    private func hasPauseSchedule() -> Bool {
        pauseTimeSet && startTime != nil && endTime != nil
    }

    private func scheduleForeground() {
        Logger.DLog("Scheduling foreground pause")

        guard let nextPauseTime = self.nextPauseTime() else {
            return
        }

        timer = {
            let t = PauseTimer(date: nextPauseTime)
            t.eventHandler = { [weak self] in
                Logger.DLog("Timer pause started")
                self?.handlePauseEvent()
                self?.schedule()
            }
            t.resume()
            return t
        }()

        Logger.DLog("Pause scheduled")
    }

    private func scheduleBackground() {
        Logger.DLog("Scheduling background pause")
        if #available(iOS 13, *) {
            self.scheduleBackgroundTask()
        } else {
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        }
    }

    private func handlePauseEvent() {
        togglePause()
        delegate?.pauseToggled()
    }

    @available(iOS 13.0, *)
    private func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundIdentifier)
        request.earliestBeginDate = nextPauseTime()

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Logger.DLog("Could not schedule task \(error.localizedDescription)")
        }
    }

    private func nextPauseTime() -> Date? {
        guard let startTime = startTime?.nextTime, let endTime = endTime?.nextTime else {
            return nil
        }

        return startTime < endTime ? startTime : endTime
    }
}
