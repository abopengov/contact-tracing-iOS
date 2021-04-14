protocol AppPermissionDelegate: AnyObject {
    func setPermisttionStatus(_ off: Bool)
    func setBlueToothEnabledStatus(_ off: Bool)
    func setPushNotificationStatus(_ off: Bool)
    func setLocationServicesStatus(_ off: Bool)
}
