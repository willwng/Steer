import Foundation

extension String {
    /// TODO add documentation
    func toKeyValuePair(splittingOn separator: Character) -> (first: String, second: String)? {
        let arr = self.split(separator: separator,
                                        maxSplits: 1,
                                        omittingEmptySubsequences: false)
        if arr.count < 2 {
            return nil
        } else {
            return (String(arr[0]), String(arr[1]))
        }
    }

    /// Convert String to Date
    func toDate() -> Date? {
        iCal.dateFormatter.dateFormat = "yyyyMMdd"
        if iCal.dateFormatter.date(from: self) != nil {
            return iCal.dateFormatter.date(from: self)
        } else {
            iCal.dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
            return iCal.dateFormatter.date(from: self)
        }
        
    }
}
