import Foundation

extension ClosedRange<UInt> {
	init(start: Bound, count: UInt) {
		self = start...start+count-1
	}
}

struct RangeMapping { 
	let destination: ClosedRange<UInt>
	let source: ClosedRange<UInt>

	init(destination: ClosedRange<UInt>, source: ClosedRange<UInt>) { 
		self.source = source
		self.destination = destination
	}

	func destinationElementForSourceElement(_ sourceElement: UInt) -> UInt? {
		guard source.contains(sourceElement) else { return nil }
		return destination.lowerBound + (sourceElement - source.lowerBound)
	}
}

extension Array<RangeMapping> {
	func destinationElementForSourceElement(_ sourceElement: UInt) -> UInt {
		let result = compactMap { $0.destinationElementForSourceElement(sourceElement) }.first
		return if let result {
			result
		} else {
			sourceElement
		}
	}
}

func solve(for input: String) -> UInt {
	let numberRegex = #/(\d+)/#	

	func parsedInputIndexToRangeMappings(
		index: Int,
		parsedInput: [[String].SubSequence]
	) -> [RangeMapping] {
		parsedInput[index].dropFirst()
		.map { $0.matches(of: numberRegex).compactMap { UInt($0.output.0) } }
		.map { mapping in 
			let destination = mapping[0]
			let source = mapping[1]
			let times = mapping[2]
			return RangeMapping(
				destination: .init(start: destination, count: times), 
				source: .init(start: source, count: times)
			)
		}
	}

	let parsedInput = input.components(separatedBy: .newlines).split(separator: "")
	
	let seeds = parsedInput[0][0]
		.matches(of: numberRegex)
		.compactMap { UInt($0.output.0) }
	
	let seedToSoil = parsedInputIndexToRangeMappings(index: 1, parsedInput: parsedInput)
	let soilToFertilizer = parsedInputIndexToRangeMappings(index: 2, parsedInput: parsedInput)
	let fertilizerToWater = parsedInputIndexToRangeMappings(index: 3, parsedInput: parsedInput)
	let waterToLight = parsedInputIndexToRangeMappings(index: 4, parsedInput: parsedInput)
	let lightToTemperature = parsedInputIndexToRangeMappings(index: 5, parsedInput: parsedInput)
	let temperatureToHumidity = parsedInputIndexToRangeMappings(index: 6, parsedInput: parsedInput)
	let humidityToLocation = parsedInputIndexToRangeMappings(index: 7, parsedInput: parsedInput)
	
	return seeds.map { seed in 
		humidityToLocation.destinationElementForSourceElement(
			temperatureToHumidity.destinationElementForSourceElement(
				lightToTemperature.destinationElementForSourceElement(
					waterToLight.destinationElementForSourceElement(
						fertilizerToWater.destinationElementForSourceElement(
							soilToFertilizer.destinationElementForSourceElement(
								seedToSoil.destinationElementForSourceElement(seed)
							)
						)
					)
				)
			)
		)
	}
	.min() ?? 0
}

do {
	let text = try String(contentsOf: URL(fileURLWithPath: "Inputs/day05.txt"), encoding: .utf8)
	print(solve(for: text))
} catch {
	print("Error reading file: \(error)")
}