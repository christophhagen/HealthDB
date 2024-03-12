import Foundation
import HealthKit

extension HKQuantityTypeIdentifier {

    init?(sampleType: SampleType) {
        /*
        if #available(macOS 14.0, *) {
            switch self {
            case .cyclingCadence: self = .cyclingCadence
            case .cyclingFunctionalThresholdPower: self = .cyclingFunctionalThresholdPower
            case .cyclingPower: self = .cyclingPower
            case .cyclingSpeed: self = .cyclingSpeed
            case .physicalEffort: self = .physicalEffort

            default:
            break
            }
        }
         */
        switch sampleType {
            //case .appleSleepingWristTemperature: self = .appleSleepingWristTemperature

            case .bodyFatPercentage: self = .bodyFatPercentage
            case .bodyMass: self = .bodyMass
            case .bodyMassIndex: self = .bodyMassIndex
            case .electrodermalActivity: self = .electrodermalActivity
            case .height: self = .height
            case .leanBodyMass: self = .leanBodyMass
            case .waistCircumference: self = .waistCircumference

            // Fitness
            case .activeEnergyBurned: self = .activeEnergyBurned
            //case .appleExerciseTime: self = .appleExerciseTime
            //case .appleMoveTime: self = .appleMoveTime
            //case .appleStandTime: self = .appleStandTime
            //case .basalEnergyBurned: self = .basalEnergyBurned
            case .distanceCycling: self = .distanceCycling
            case .distanceDownhillSnowSports: self = .distanceDownhillSnowSports
            case .distanceSwimming: self = .distanceSwimming
            //case .distanceWalkingRunning: self = .distanceWalkingRunning
            case .distanceWheelchair: self = .distanceWheelchair
            case .flightsClimbed: self = .flightsClimbed
            //case .nikeFuel: self = .nikeFuel
            case .pushCount: self = .pushCount
            case .runningPower: self = .runningPower
            case .runningSpeed: self = .runningSpeed
            case .stepCount: self = .stepCount
            case .swimmingStrokeCount: self = .swimmingStrokeCount
            case .underwaterDepth: self = .underwaterDepth

            // Hearing Health
            case .environmentalAudioExposureEvent: self = .environmentalAudioExposure
            case .environmentalSoundReduction: self = .environmentalSoundReduction
            case .headphoneAudioExposureEvent: self = .headphoneAudioExposure

            // Heart
            //case .atrialFibrillationBurden: self = .atrialFibrillationBurden
            case .heartRate: self = .heartRate
            case .heartRateRecoveryOneMinute: self = .heartRateRecoveryOneMinute
            case .heartRateVariabilitySDNN: self = .heartRateVariabilitySDNN
            case .peripheralPerfusionIndex: self = .peripheralPerfusionIndex
            case .restingHeartRate: self = .restingHeartRate
            //case .vo2Max: self = .vo2Max
            //case .walkingHeartRateAverage: self = .walkingHeartRateAverage

            // Mobility
            //case .appleWalkingSteadiness: self = .appleWalkingSteadiness
            case .runningGroundContactTime: self = .runningGroundContactTime
            case .runningStrideLength: self = .runningStrideLength
            case .runningVerticalOscillation: self = .runningVerticalOscillation
            case .sixMinuteWalkTestDistance: self = .sixMinuteWalkTestDistance
            case .stairAscentSpeed: self = .stairAscentSpeed
            case .stairDescentSpeed: self = .stairDescentSpeed
            //case .walkingAsymmetryPercentage: self = .walkingAsymmetryPercentage
            //case .walkingDoubleSupportPercentage: self = .walkingDoubleSupportPercentage
            //case .walkingSpeed: self = .walkingSpeed
            //case .walkingStepLength: self = .walkingStepLength

            // Nutrition
            case .dietaryBiotin: self = .dietaryBiotin
            case .dietaryCaffeine: self = .dietaryCaffeine
            case .dietaryCalcium: self = .dietaryCalcium
            case .dietaryCarbohydrates: self = .dietaryCarbohydrates
            case .dietaryChloride: self = .dietaryChloride
            case .dietaryCholesterol: self = .dietaryCholesterol
            case .dietaryChromium: self = .dietaryChromium
            case .dietaryCopper: self = .dietaryCopper
            case .dietaryEnergyConsumed: self = .dietaryEnergyConsumed
            case .dietaryFatMonounsaturated: self = .dietaryFatMonounsaturated
            case .dietaryFatPolyunsaturated: self = .dietaryFatPolyunsaturated
            case .dietaryFatSaturated: self = .dietaryFatSaturated
            case .dietaryFatTotal: self = .dietaryFatTotal
            case .dietaryFiber: self = .dietaryFiber
            case .dietaryFolate: self = .dietaryFolate
            case .dietaryIodine: self = .dietaryIodine
            case .dietaryIron: self = .dietaryIron
            case .dietaryMagnesium: self = .dietaryMagnesium
            case .dietaryManganese: self = .dietaryManganese
            case .dietaryMolybdenum: self = .dietaryMolybdenum
            case .dietaryNiacin: self = .dietaryNiacin
            case .dietaryPantothenicAcid: self = .dietaryPantothenicAcid
            case .dietaryPhosphorus: self = .dietaryPhosphorus
            case .dietaryPotassium: self = .dietaryPotassium
            case .dietaryProtein: self = .dietaryProtein
            case .dietaryRiboflavin: self = .dietaryRiboflavin
            case .dietarySelenium: self = .dietarySelenium
            case .dietarySodium: self = .dietarySodium
            case .dietarySugar: self = .dietarySugar
            case .dietaryThiamin: self = .dietaryThiamin
            case .dietaryVitaminA: self = .dietaryVitaminA
            case .dietaryVitaminB12: self = .dietaryVitaminB12
            case .dietaryVitaminB6: self = .dietaryVitaminB6
            case .dietaryVitaminC: self = .dietaryVitaminC
            case .dietaryVitaminD: self = .dietaryVitaminD
            case .dietaryVitaminE: self = .dietaryVitaminE
            case .dietaryVitaminK: self = .dietaryVitaminK
            case .dietaryWater: self = .dietaryWater
            case .dietaryZinc: self = .dietaryZinc

            // Other
            //case .bloodAlcoholContent: self = .bloodAlcoholContent
            case .bloodPressureDiastolic: self = .bloodPressureDiastolic
            case .bloodPressureSystolic: self = .bloodPressureSystolic
            case .insulinDelivery: self = .insulinDelivery
            case .numberOfAlcoholicBeverages: self = .numberOfAlcoholicBeverages
            case .numberOfTimesFallen: self = .numberOfTimesFallen
            //case .timeInDaylight: self = .timeInDaylight
            case .uvExposure: self = .uvExposure
            case .waterTemperature: self = .waterTemperature

            // Reproductive Health
            case .basalBodyTemperature: self = .basalBodyTemperature

            // Respiratory
            case .forcedExpiratoryVolume1: self = .forcedExpiratoryVolume1
            case .forcedVitalCapacity: self = .forcedVitalCapacity
            case .inhalerUsage: self = .inhalerUsage
            case .oxygenSaturation: self = .oxygenSaturation
            case .peakExpiratoryFlowRate: self = .peakExpiratoryFlowRate
            case .respiratoryRate: self = .respiratoryRate

            // Vital Signs
            case .bloodGlucose: self = .bloodGlucose
            case .bodyTemperature: self = .bodyTemperature
        default:
            return nil
        }
    }

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
        case .environmentalAudioExposure: return .environmentalAudioExposureEvent
        case .environmentalSoundReduction: return .environmentalSoundReduction
        case .headphoneAudioExposure: return .headphoneAudioExposureEvent

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
