import Foundation

extension Sequence where Element: AdditiveArithmetic {
  func sum() -> Element {
    reduce(into: .zero, +=)
  }
}

extension String { 
	var isNotEmpty: Bool { !isEmpty }
}

func solve(for input: String) -> UInt {
	enum CubeColor: String, Hashable { 
		case red, green, blue
	}

	var posibleGameIDs = [UInt]()
	let maxReds: UInt = 12
	let maxGreens: UInt = 13
	let maxBlues: UInt = 14

	let regex = #/(?:\bGame (?<id>\d+)\b:)?((?<game>.+?)(?:;|$))/#
	for line in input.components(separatedBy: .newlines) { 
		let result = try! regex.wholeMatch(in: line)
		
		let gameID = UInt(result!.id!)!
		var isGamePosible = true

		let rawSets = result!.game.components(separatedBy: ";")
		for rawSet in rawSets { 
			let rawCubes = rawSet.components(separatedBy: ",")
			
			for rawCube in rawCubes {
				let rawCubeComponents = rawCube.components(separatedBy: " ")
					.filter(\.isNotEmpty)
				let cubeCount = UInt(rawCubeComponents.first!)!
				let cubeColor = CubeColor(rawValue: rawCubeComponents.last!)!

				switch cubeColor { 
				case .red:
					if cubeCount > maxReds {
						isGamePosible = false
						break
					} 
				case .green:
					if cubeCount > maxGreens {
						isGamePosible = false
						break
					} 
				case .blue:
					if cubeCount > maxBlues {
						isGamePosible = false
						break
					} 
				}
			}
		}
		guard isGamePosible else { continue }
		posibleGameIDs.append(gameID)
	}

	return posibleGameIDs.sum()
}

do {
	let text = try String(
		contentsOf: URL(fileURLWithPath: "Inputs/day02.txt"), 
		encoding: .utf8
	)
	print(solve(for: text))
} catch {
	print("Error reading file: \(error)")
}