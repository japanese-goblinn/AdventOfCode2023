import Foundation

extension Sequence<UInt> {
  func sum() -> Element {
    reduce(into: 0, +=)
  }
}

func solve(for input: String) -> UInt {
	let numberRegex = #/(\d+)/#
	var points = [UInt]()
	for line in input.components(separatedBy: .newlines) {
		var cardWorth: UInt = 0
		let numbers = line.components(separatedBy: "|")

		let rawWinningNumbers = numbers.first!
		var winingNumbers = Set<UInt>()
		for winingNumber in rawWinningNumbers.matches(of: numberRegex).dropFirst() {
			winingNumbers.insert(UInt(winingNumber.output.0)!)
		}

		let rawMyNumbers = numbers.last!
		for rawMyNumber in rawMyNumbers.matches(of: numberRegex) { 
			let myNumber = UInt(rawMyNumber.output.0)!
			if winingNumbers.contains(myNumber) {
				if cardWorth == 0 {
					cardWorth = 1
				} else {
					cardWorth *= 2
				}
			}
		}
		if cardWorth != 0 {
			points.append(cardWorth)
		}
	}
	return points.sum()
}


// print(solve(for: """
// Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
// Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
// Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
// Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
// Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
// Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
// """))

do {
	let text = try String(
		contentsOf: URL(fileURLWithPath: "Inputs/day04.txt"), 
		encoding: .utf8
	)
	print(solve(for: text))
} catch {
	print("Error reading file: \(error)")
}