protocol AppPermissionDelegate: AnyObject {
    func setBluetoothEnabledStatus(_ off: Bool)
    func setPushNotificationStatus(_ off: Bool)
    func setLocationServicesStatus(_ off: Bool)
}
