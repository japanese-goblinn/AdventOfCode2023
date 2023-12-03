#!/usr/bin/swift

import Foundation
import AppKit

extension Collection {
	public subscript(safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}

extension Sequence<UInt> {
  func sum() -> Element {
    reduce(into: 0, +=)
  }
}

extension Sequence<UInt> {
  func product() -> Element {
    reduce(into: 1, *=)
  }
}

extension Array {
	mutating func prepend(_ element: Element) {
    insert(element, at: 0)
  }
}

extension [String] {
	subscript(safeLeftSliceFrom index: Int) -> ArraySlice<String>? { 
		let newIndex = index - 1
		guard self[safe: newIndex] != nil else { return nil }
		return self[startIndex...newIndex]
	}

	subscript(safeRightSliceFrom index: Int) -> ArraySlice<String>? { 
		let newIndex = index + 1
		let realEndIndex = endIndex - 1
		guard self[safe: newIndex] != nil else { return nil }
		return self[newIndex...realEndIndex]
	}
}

extension [[String]] { 
	subscript(_ indexPath: IndexPath) -> String? {
		self[safe: indexPath.section]?[safe: indexPath.item]
	}
}

func solve(for input: String) -> UInt {
	func isGear(_ element: String) -> Bool {
		element == "*"
	}

	func isDigit(_ element: String) -> Bool { 
		UInt(element) != nil
	}

	func fillDigits(
		into buffer: inout [String], 
		line: some BidirectionalCollection<String>,
		fillOperation: (inout [String], String, _ indexCount: Int) -> Void
	) {
		for (index, element) in line.enumerated() { 
			if isDigit(element) { 
				fillOperation(&buffer, element, index)
			} else { 
				return
			}
		}
	}

	var parts = [[String]]()
	for line in input.components(separatedBy: .newlines) { 
		var _line = [String]()
		for char in line { 
			_line.append(String(char))
		}
		parts.append(_line)
	}

	var alreadyMarkedIndices = Set<IndexPath>()

	func findNumber(
		at indexPath: IndexPath,
		searchedItem: String,
		searchedSection: [String]
	) -> UInt {
		alreadyMarkedIndices.insert(indexPath)
		var rawDigits = [searchedItem]
		if let leftPart = searchedSection[safeLeftSliceFrom: indexPath.item] {
			fillDigits(into: &rawDigits, line: leftPart.reversed()) { buff, el, indexCount in  
				buff.prepend(el) 
				let i = IndexPath(item: indexPath.item - 1 - indexCount, section: indexPath.section)
				alreadyMarkedIndices.insert(i)
			}
		}
		if let rightPart = searchedSection[safeRightSliceFrom: indexPath.item] {
			fillDigits(into: &rawDigits, line: rightPart) { buff, el, indexCount in 
				buff.append(el)
				let i = IndexPath(item: indexPath.item + 1 + indexCount, section: indexPath.section)
				alreadyMarkedIndices.insert(i)
			}
			
		}
		return UInt(rawDigits.joined())!
	}

	var numbers = [UInt]()
	for (sectionIndex, section) in parts.enumerated() {
		for (itemIndex, item) in section.enumerated() where isGear(item) {
			var localNumbers = [UInt]()
			let lookupIndexPaths = [
				IndexPath(item: itemIndex-1, section: sectionIndex-1),
				IndexPath(item: itemIndex, section: sectionIndex-1),
				IndexPath(item: itemIndex+1, section: sectionIndex-1),
				IndexPath(item: itemIndex-1, section: sectionIndex),
				IndexPath(item: itemIndex+1, section: sectionIndex),
				IndexPath(item: itemIndex-1, section: sectionIndex+1),
				IndexPath(item: itemIndex, section: sectionIndex+1),
				IndexPath(item: itemIndex+1, section: sectionIndex+1),
			]
			for indexPath in lookupIndexPaths { 
				if 
				 !alreadyMarkedIndices.contains(indexPath),
				 let searchedSection = parts[safe: indexPath.section],
				 let searchedItem = searchedSection[safe: indexPath.item],
				 isDigit(searchedItem) 
				{
					let number = findNumber(
						at: indexPath,
						searchedItem: searchedItem,
						searchedSection: searchedSection
					)
					localNumbers.append(number)
				}
			}
			if localNumbers.count == 2 {
				numbers.append(localNumbers.product())
			}
		}
	}

	return numbers.sum()
}

do {
	let text = try String(
		contentsOf: URL(fileURLWithPath: "Inputs/day03.txt"), 
		encoding: .utf8
	)
	print(solve(for: text))
} catch {
	print("Error reading file: \(error)")
}