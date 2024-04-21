import Foundation
import HealthKit

extension HKQuantityTypeIdentifier {

    var sampleType: SampleType {
        .quantity(self)
    }
}

extension HKQuantityTypeIdentifier: LosslessIntegerConvertible {

    @available(macOS 14.0, iOS 17.0, watchOS 10.0, *)
    private static var newTypes: BiDictionary<HKQuantityTypeIdentifier, Int> {
        [
            .cyclingCadence: 282,
            .cyclingFunctionalThresholdPower: 283,
            .cyclingPower: 280,
            .cyclingSpeed: 281,
            .physicalEffort: 286,
            .timeInDaylight: 279,
        ]
    }

    static let map: BiDictionary<HKQuantityTypeIdentifier, Int> = {
        guard #available(macOS 14.0, iOS 17.0, watchOS 10.0, *)else {
            return oldTypes
        }
        var all = oldTypes
        for newType in newTypes {
            all[key: newType.key] = newType.value
        }
        return all
    }()

    private static var oldTypes: BiDictionary<HKQuantityTypeIdentifier, Int> {
        [
            //.appleSleepingWristTemperature: <#T##Int#>,
            .bodyFatPercentage: 1,
            .bodyMass: 3,
            .bodyMassIndex: 0,
            .electrodermalActivity: 58,
            .height: 2,
            .leanBodyMass: 4,
            .waistCircumference: 114,

            // Fitness
            .activeEnergyBurned: 10,
            .appleExerciseTime: 75,
            //.appleMoveTime: <#T##Int#>,
            .appleStandTime: 186,
            .basalEnergyBurned: 9,
            .distanceCycling: 83,
            .distanceDownhillSnowSports: 138,
            .distanceSwimming: 110,
            .distanceWalkingRunning: 8,
            .distanceWheelchair: 113,
            .flightsClimbed: 12,
            //.nikeFuel: <#T##Int#>,
            .pushCount: 101,
            .runningPower: 270,
            .runningSpeed: 274,
            .stepCount: 7,
            .swimmingStrokeCount: 111,
            .underwaterDepth: 269,

            // Hearing Health
            .environmentalAudioExposure: 172,
            .environmentalSoundReduction: 272,
            .headphoneAudioExposure: 173,

            // Heart
            .atrialFibrillationBurden: 248,
            .heartRate: 5,
            .heartRateRecoveryOneMinute: 266,
            .heartRateVariabilitySDNN: 139,
            .peripheralPerfusionIndex: 19,
            .restingHeartRate: 118,
            .vo2Max: 124,
            .walkingHeartRateAverage: 137,

            // Mobility
            .appleWalkingSteadiness: 249,
            .runningGroundContactTime: 260,
            .runningStrideLength: 258,
            .runningVerticalOscillation: 259,
            .sixMinuteWalkTestDistance: 183,
            .stairAscentSpeed: 195,
            .stairDescentSpeed: 196,
            .walkingAsymmetryPercentage: 194,
            .walkingDoubleSupportPercentage: 182,
            .walkingSpeed: 187,
            .walkingStepLength: 188,

            // Nutrition
            .dietaryBiotin: 44,
            .dietaryCaffeine: 78,
            .dietaryCalcium: 38,
            .dietaryCarbohydrates: 26,
            .dietaryChloride: 55,
            .dietaryCholesterol: 24,
            .dietaryChromium: 53,
            .dietaryCopper: 51,
            .dietaryEnergyConsumed: 29,
            .dietaryFatMonounsaturated: 22,
            .dietaryFatPolyunsaturated: 21,
            .dietaryFatSaturated: 23,
            .dietaryFatTotal: 20,
            .dietaryFiber: 27,
            .dietaryFolate: 43,
            .dietaryIodine: 47,
            .dietaryIron: 39,
            .dietaryMagnesium: 48,
            .dietaryManganese: 52,
            .dietaryMolybdenum: 54,
            .dietaryNiacin: 42,
            .dietaryPantothenicAcid: 45,
            .dietaryPhosphorus: 46,
            .dietaryPotassium: 56,
            .dietaryProtein: 30,
            .dietaryRiboflavin: 41,
            .dietarySelenium: 50,
            .dietarySodium: 25,
            .dietarySugar: 28,
            .dietaryThiamin: 40,
            .dietaryVitaminA: 31,
            .dietaryVitaminB12: 33,
            .dietaryVitaminB6: 32,
            .dietaryVitaminC: 34,
            .dietaryVitaminD: 35,
            .dietaryVitaminE: 36,
            .dietaryVitaminK: 37,
            .dietaryWater: 87,
            .dietaryZinc: 49,

            // Other
            .bloodAlcoholContent: 18,
            .bloodPressureDiastolic: 17,
            .bloodPressureSystolic: 16,
            .insulinDelivery: 125,
            .numberOfAlcoholicBeverages: 251,
            .numberOfTimesFallen: 57,
            .uvExposure: 89,
            .waterTemperature: 277,

            // Reproductive Health
            .basalBodyTemperature: 90,

            // Respiratory
            .forcedExpiratoryVolume1: 72,
            .forcedVitalCapacity: 71,
            .inhalerUsage: 60,
            .oxygenSaturation: 14,
            .peakExpiratoryFlowRate: 73,
            .respiratoryRate: 61,

            // Vital Signs
            .bloodGlucose: 15,
            .bodyTemperature: 62,
        ]
    }
}
