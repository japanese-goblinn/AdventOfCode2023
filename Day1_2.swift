#!/usr/bin/swift

import Foundation

extension String {
	mutating func prepend(_ another: Self) {
		self = "\(another)\(self)"
	}
}

func day1_2(input: String) -> Int {
	enum RawDigit: String, CaseIterable { 
		case one, two, three, four, five, six, seven, eight, nine

		var integerString: String { 
			switch self { 
			case .one: "1"
			case .two: "2"
			case .three: "3"
			case .four: "4"
			case .five: "5"
			case .six: "6"
			case .seven: "7"
			case .eight: "8"
			case .nine: "9"
			}
		}
	}

	func findRawDigit(
		in string: some Collection<String.Element>,
		saveResult: @escaping (inout String, String) -> Void
	) -> String { 
		var formedDigit = ""
		for element in string { 
			let char = String(element)
			if Int(char) != nil {
				return char
			}
			saveResult(&formedDigit, char)
			for rawDigit in RawDigit.allCases { 
				if formedDigit.contains(rawDigit.rawValue) {
					return rawDigit.integerString
				}
			}
		}
		fatalError("Imposible")
	}

	return input.components(separatedBy: .newlines)
		.map { line -> Int in
			let firstRawDigit = findRawDigit(in: line) { result, element in
				result.append(element)
			}
			let lastRawDigit = findRawDigit(in: line.reversed()) { result, element in
				result.prepend(element)
			}
			return Int(firstRawDigit + lastRawDigit)!
		}
		.reduce(into: 0, +=)
}

do {
	let text = try String(
		contentsOf: URL(fileURLWithPath: "Inputs/day1_1.txt"), // same input as 1 task
		encoding: .utf8
	)
	print(day1_2(input: text))
} catch {
	print("Error reading file: \(error)")
}
