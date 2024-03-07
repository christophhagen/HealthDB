import Foundation
import HealthKit

extension HKQuantityTypeIdentifier {

    var sampleType: SampleType? {
        /*
        if #available(macOS 14.0, *) {
            switch self {
            case .cyclingCadence: return .cyclingCadence
            case .cyclingFunctionalThresholdPower: return .cyclingFunctionalThresholdPower
            case .cyclingPower: return .cyclingPower
            case .cyclingSpeed: return .cyclingSpeed
            case .physicalEffort: return .physicalEffort

            default:
            break
            }
        }
         */
        switch self {
        //case .appleSleepingWristTemperature: return .appleSleepingWristTemperature

        case .bodyFatPercentage: return .bodyFatPercentage
        case .bodyMass: return .bodyMass
        case .bodyMassIndex: return .bodyMassIndex
        case .electrodermalActivity: return .electrodermalActivity
        case .height: return .height
        case .leanBodyMass: return .leanBodyMass
        case .waistCircumference: return .waistCircumference

        // Fitness
        case .activeEnergyBurned: return .activeEnergyBurned
        //case .appleExerciseTime: return .appleExerciseTime
        //case .appleMoveTime: return .appleMoveTime
        //case .appleStandTime: return .appleStandTime
        //case .basalEnergyBurned: return .basalEnergyBurned
        case .distanceCycling: return .distanceCycling
        case .distanceDownhillSnowSports: return .distanceDownhillSnowSports
        case .distanceSwimming: return .distanceSwimming
        //case .distanceWalkingRunning: return .distanceWalkingRunning
        case .distanceWheelchair: return .distanceWheelchair
        case .flightsClimbed: return .flightsClimbed
        //case .nikeFuel: return .nikeFuel
        case .pushCount: return .pushCount
        case .runningPower: return .runningPower
        case .runningSpeed: return .runningSpeed
        case .stepCount: return .stepCount
        case .swimmingStrokeCount: return .swimmingStrokeCount
        case .underwaterDepth: return .underwaterDepth

        // Hearing Health
        case .environmentalAudioExposure: return .environmentalAudioExposure
        case .environmentalSoundReduction: return .environmentalSoundReduction
        case .headphoneAudioExposure: return .headphoneAudioExposure

        // Heart
        //case .atrialFibrillationBurden: return .atrialFibrillationBurden
        case .heartRate: return .heartRate
        case .heartRateRecoveryOneMinute: return .heartRateRecoveryOneMinute
        case .heartRateVariabilitySDNN: return .heartRateVariabilitySDNN
        case .peripheralPerfusionIndex: return .peripheralPerfusionIndex
        case .restingHeartRate: return .restingHeartRate
        //case .vo2Max: return .vo2Max
        //case .walkingHeartRateAverage: return .walkingHeartRateAverage

        // Mobility
        //case .appleWalkingSteadiness: return .appleWalkingSteadiness
        case .runningGroundContactTime: return .runningGroundContactTime
        case .runningStrideLength: return .runningStrideLength
        case .runningVerticalOscillation: return .runningVerticalOscillation
        case .sixMinuteWalkTestDistance: return .sixMinuteWalkTestDistance
        case .stairAscentSpeed: return .stairAscentSpeed
        case .stairDescentSpeed: return .stairDescentSpeed
        //case .walkingAsymmetryPercentage: return .walkingAsymmetryPercentage
        //case .walkingDoubleSupportPercentage: return .walkingDoubleSupportPercentage
        //case .walkingSpeed: return .walkingSpeed
        //case .walkingStepLength: return .walkingStepLength

        // Nutrition
        case .dietaryBiotin: return .dietaryBiotin
        case .dietaryCaffeine: return .dietaryCaffeine
        case .dietaryCalcium: return .dietaryCalcium
        case .dietaryCarbohydrates: return .dietaryCarbohydrates
        case .dietaryChloride: return .dietaryChloride
        case .dietaryCholesterol: return .dietaryCholesterol
        case .dietaryChromium: return .dietaryChromium
        case .dietaryCopper: return .dietaryCopper
        case .dietaryEnergyConsumed: return .dietaryEnergyConsumed
        case .dietaryFatMonounsaturated: return .dietaryFatMonounsaturated
        case .dietaryFatPolyunsaturated: return .dietaryFatPolyunsaturated
        case .dietaryFatSaturated: return .dietaryFatSaturated
        case .dietaryFatTotal: return .dietaryFatTotal
        case .dietaryFiber: return .dietaryFiber
        case .dietaryFolate: return .dietaryFolate
        case .dietaryIodine: return .dietaryIodine
        case .dietaryIron: return .dietaryIron
        case .dietaryMagnesium: return .dietaryMagnesium
        case .dietaryManganese: return .dietaryManganese
        case .dietaryMolybdenum: return .dietaryMolybdenum
        case .dietaryNiacin: return .dietaryNiacin
        case .dietaryPantothenicAcid: return .dietaryPantothenicAcid
        case .dietaryPhosphorus: return .dietaryPhosphorus
        case .dietaryPotassium: return .dietaryPotassium
        case .dietaryProtein: return .dietaryProtein
        case .dietaryRiboflavin: return .dietaryRiboflavin
        case .dietarySelenium: return .dietarySelenium
        case .dietarySodium: return .dietarySodium
        case .dietarySugar: return .dietarySugar
        case .dietaryThiamin: return .dietaryThiamin
        case .dietaryVitaminA: return .dietaryVitaminA
        case .dietaryVitaminB12: return .dietaryVitaminB12
        case .dietaryVitaminB6: return .dietaryVitaminB6
        case .dietaryVitaminC: return .dietaryVitaminC
        case .dietaryVitaminD: return .dietaryVitaminD
        case .dietaryVitaminE: return .dietaryVitaminE
        case .dietaryVitaminK: return .dietaryVitaminK
        case .dietaryWater: return .dietaryWater
        case .dietaryZinc: return .dietaryZinc

        // Other
        //case .bloodAlcoholContent: return .bloodAlcoholContent
        case .bloodPressureDiastolic: return .bloodPressureDiastolic
        case .bloodPressureSystolic: return .bloodPressureSystolic
        case .insulinDelivery: return .insulinDelivery
        case .numberOfAlcoholicBeverages: return .numberOfAlcoholicBeverages
        case .numberOfTimesFallen: return .numberOfTimesFallen
        //case .timeInDaylight: return .timeInDaylight
        case .uvExposure: return .uvExposure
        case .waterTemperature: return .waterTemperature

        // Reproductive Health
        case .basalBodyTemperature: return .basalBodyTemperature

        // Respiratory
        case .forcedExpiratoryVolume1: return .forcedExpiratoryVolume1
        case .forcedVitalCapacity: return .forcedVitalCapacity
        case .inhalerUsage: return .inhalerUsage
        case .oxygenSaturation: return .oxygenSaturation
        case .peakExpiratoryFlowRate: return .peakExpiratoryFlowRate
        case .respiratoryRate: return .respiratoryRate

        // Vital Signs
        case .bloodGlucose: return .bloodGlucose
        case .bodyTemperature: return .bodyTemperature

        default: return nil
        }
    }
}
