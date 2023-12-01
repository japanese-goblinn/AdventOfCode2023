#!/usr/bin/swift

import Foundation

func day1_1(input: String) -> Int {
	input.components(separatedBy: .newlines)
		.map { line -> Int in
			let digits = line.compactMap { char in
				let string = String(char)
				return Int(string) == nil ? nil : string
			}
			let first = digits.first!
			return if let last = digits.last {
				Int(first + last)!
			} else {
				Int(first + first)!
			}
		}
		.reduce(into: 0, +=)
}

do {
	let text = try String(
		contentsOf: URL(fileURLWithPath: "Inputs/day1_1.txt"), 
		encoding: .utf8
	)
	print(day1_1(input: text))
} catch {
	print("Error reading file: \(error)")
}