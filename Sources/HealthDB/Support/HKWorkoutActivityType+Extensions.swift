import Foundation
import HealthKit

extension HKWorkoutActivityType: @retroactive CustomStringConvertible {

    public var description: String {
        switch self {
        case .climbing:
            return "Climbing"
        case .cycling:
            return "Cycling"
        case .hiking:
            return "Hiking"
        case .hockey:
            return "Hockey"
        case .other:
            return "Other"
        case .rowing:
            return "Rowing"
        case .running:
            return "Running"
        case .swimming:
            return "Swimming"
        case .yoga:
            return "Yoga"
        case .walking:
            return "Walking"
        case .americanFootball:
            return "American Football"
        case .archery:
            return "Archery"
        case .australianFootball:
            return "Australian Football"
        case .badminton:
            return "Badminton"
        case .baseball:
            return "Baseball"
        case .basketball:
            return "Basketball"
        case .bowling:
            return "Bowling"
        case .boxing:
            return "Boxing"
        case .cricket:
            return "Cricket"
        case .crossTraining:
            return "Cross Training"
        case .curling:
            return "Curling"
        case .dance:
            return "Dance"
        case .danceInspiredTraining:
            return "Dance Inspired Training"
        case .elliptical:
            return "Elliptical"
        case .equestrianSports:
            return "Equestrian Sports"
        case .fencing:
            return "Fencing"
        case .fishing:
            return "Fishing"
        case .functionalStrengthTraining:
            return "Functional Strength Training"
        case .golf:
            return "Golf"
        case .gymnastics:
            return "Gymnastics"
        case .handball:
            return "Handball"
        case .hunting:
            return "Hunting"
        case .lacrosse:
            return "Lacrosse"
        case .martialArts:
            return "Martial Arts"
        case .mindAndBody:
            return "Mind And Body"
        case .mixedMetabolicCardioTraining:
            return "Mixed Metabolic Cardio Training"
        case .paddleSports:
            return "Paddle Sports"
        case .play:
            return "Play"
        case .preparationAndRecovery:
            return "Preparation and Recovery"
        case .racquetball:
            return "Racquetball"
        case .rugby:
            return "Rugby"
        case .sailing:
            return "Sailing"
        case .skatingSports:
            return "Skating Sports"
        case .snowSports:
            return "Snow Sports"
        case .soccer:
            return "Soccer"
        case .softball:
            return "Softball"
        case .squash:
            return "Squash"
        case .stairClimbing:
            return "Stair Climbing"
        case .surfingSports:
            return "Surfing Sports"
        case .tableTennis:
            return "Table Tennis"
        case .tennis:
            return "Tennis"
        case .trackAndField:
            return "Track And Field"
        case .traditionalStrengthTraining:
            return "Traditional Strength Training"
        case .volleyball:
            return "Volleyball"
        case .waterFitness:
            return "Water Fitness"
        case .waterPolo:
            return "Water Polo"
        case .waterSports:
            return "Water Sports"
        case .wrestling:
            return "Wrestling"
        case .barre:
            return "Barre"
        case .coreTraining:
            return "Core Training"
        case .crossCountrySkiing:
            return "Cross Country Skiing"
        case .downhillSkiing:
            return "Downholl Skiing"
        case .flexibility:
            return "Flexibility"
        case .highIntensityIntervalTraining:
            return "High Intensity Interval Training"
        case .jumpRope:
            return "Jump Rope"
        case .kickboxing:
            return "Kickboxing"
        case .pilates:
            return "Pilates"
        case .snowboarding:
            return "Snowboarding"
        case .stairs:
            return "Stairs"
        case .stepTraining:
            return "Step Training"
        case .wheelchairWalkPace:
            return "Wheelchair Walk Pace"
        case .wheelchairRunPace:
            return "Wheelchair Run Pace"
        case .taiChi:
            return "Tai Chi"
        case .mixedCardio:
            return "Mixed Cardio"
        case .handCycling:
            return "Hand Cycling"
        case .discSports:
            return "Disc Sports"
        case .fitnessGaming:
            return "Fitness Gaming"
        case .cardioDance:
            return "Cardio Dance"
        case .socialDance:
            return "Social Dance"
        case .pickleball:
            return "Pickleball"
        case .cooldown:
            return "Cooldown"
        case .swimBikeRun:
            return "Triathlon"
        case .transition:
            return "Transition"
        case .underwaterDiving:
            return "Underwater Diving"
        @unknown default:
            return "\(rawValue)"
        }
    }
}

extension HKWorkoutActivityType: @retroactive Comparable {

    public static func < (lhs: HKWorkoutActivityType, rhs: HKWorkoutActivityType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
