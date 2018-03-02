import Foundation

public enum iCal {
    /// Loads the content of a given string.
    ///
    /// - Parameter string: string to load
    /// - Returns: List of containted `Calendar`s
    public static func load(string: String) -> [Calendar] {
        var icsContent = string
        icsContent = icsContent.replacingOccurrences(of: "\n ", with: "", options: .literal, range: nil)
        let icsData = icsContent.components(separatedBy: "\n")
        return parse(icsData)
    }

    /// Loads the contents of a given URL. Be it from a local path or external resource.
    ///
    /// - Parameters:
    ///   - url: URL to load
    ///   - encoding: Encoding to use when reading data, defaults to UTF-8
    /// - Returns: List of contained `Calendar`s.
    /// - Throws: Error encountered during loading of URL or decoding of data.
    /// - Warning: This is a **synchronous** operation! Use `load(string:)` and fetch your data beforehand for async handling.
    public static func load(url: URL, encoding: String.Encoding = .utf8) throws -> [Calendar] {
        let data = try Data(contentsOf: url)
        guard var string = String(data: data, encoding: encoding) else { throw iCalError.encoding }
        string = string.replacingOccurrences(of: "\r\n", with: "\n")
        return load(string: string)
    }

    private static func parse(_ icsContent: [String]) -> [Calendar] {
        let parser = Parser(icsContent)
        do {
            return try parser.read()
        } catch let error {
            print(error)
            return []
        }
    }

    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }()
}
