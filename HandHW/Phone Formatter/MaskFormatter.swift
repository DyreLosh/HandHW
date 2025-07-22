import Foundation

protocol MaskConvertible {
    var source: String { get set }
    func convert(using pattern: String) -> String
}

class PhonePatternConverter: MaskConvertible {
    var source: String

    init(source: String) {
        self.source = source
    }

    func convert(using pattern: String) -> String {
        
        let filtered = source.reduce(into: "") { res, char in
            if char.isNumber { res.append(char) }
        }

        var digits = filtered

        if digits.first == "8" {
            digits.removeFirst()
            digits = "7" + digits
        }

        if pattern.hasPrefix("+7") {
            if digits.first == "7" {
                digits.removeFirst()
            }
        } else if digits.first == "7" {
            digits.removeFirst()
        }


        var result = ""
        var digitIdx = digits.startIndex

        for symbol in pattern {
            if symbol == "#" {
                if digitIdx < digits.endIndex {
                    result.append(digits[digitIdx])
                    digitIdx = digits.index(after: digitIdx)
                } else {
                    break
                }
            } else {
                result.append(symbol)
            }
        }

        if result.last == " " {
            result = String(result.dropLast())
        }

        return result
    }
}
