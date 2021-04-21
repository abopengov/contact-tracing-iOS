protocol TempIdProvidable {
    func getTempId() -> String?
    func fetchNewTempId(onComplete: @escaping (String?) -> Void)
}
