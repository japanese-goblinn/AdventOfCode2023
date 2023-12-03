#!/usr/bin/swift

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

	var minimumPosibleGamePowers = [UInt]()

	let regex = #/(?:\bGame (?<id>\d+)\b:)?((?<game>.+?)(?:;|$))/#
	for line in input.components(separatedBy: .newlines) { 
		let result = try! regex.wholeMatch(in: line)
		var maxReds: UInt = 1
		var maxGreens: UInt = 1
		var maxBlues: UInt = 1

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
							maxReds = cubeCount
						}
				case .green:
						if cubeCount > maxGreens { 
							maxGreens = cubeCount
						}
				case .blue:
						if cubeCount > maxBlues { 
							maxBlues = cubeCount
						}
				}
			}
		}
		minimumPosibleGamePowers.append(maxReds * maxGreens * maxBlues)
	}

	return minimumPosibleGamePowers.sum()
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