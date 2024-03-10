import Foundation
import HealthKit

extension HKCategoryTypeIdentifier {

    var sampleType: SampleType? {
        switch self {
        // case .appleStandHour: return .appleStandHour
        // Hearing Health
        case .environmentalAudioExposureEvent: return .environmentalAudioExposure // HKCategoryValueEnvironmentalAudioExposureEvent
        case .headphoneAudioExposureEvent: return .headphoneAudioExposure // HKCategoryValueHeadphoneAudioExposureEvent
        // Heart
        // case .highHeartRateEvent: return .highHeartRateEvent // HKCategoryValue
        // case .irregularHeartRhythmEvent: return .irregularHeartRhythmEvent // HKCategoryValue
        // case .lowCardioFitnessEvent: return .lowCardioFitnessEvent // HKCategoryValueLowCardioFitnessEvent
        case .lowHeartRateEvent: return .lowHeartRateEvent // HKCategoryValue
        // Mindfulness
        case .mindfulSession: return .mindfulSession // HKCategoryValue
        // Mobility
        // case .appleWalkingSteadinessEvent: return .appleWalkingSteadinessEvent // HKCategoryValueAppleWalkingSteadinessEvent
        // Other
        case .handwashingEvent: return .handwashingEvent // HKCategoryValue
        case .toothbrushingEvent: return .toothbrushingEvent // HKCategoryValue
        // Reproductive Health
        case .cervicalMucusQuality: return .cervicalMucusQuality // HKCategoryValueCervicalMucusQuality
        case .contraceptive: return .contraceptive // HKCategoryValueContraceptive
        // case .infrequentMenstrualCycles: return .infrequentMenstrualCycles // HKCategoryValue
        case .intermenstrualBleeding: return .intermenstrualBleeding // HKCategoryValue
        // case .irregularMenstrualCycles: return .irregularMenstrualCycles // HKCategoryValue
        case .lactation: return .lactation // HKCategoryValue
        case .menstrualFlow: return .menstrualFlow // HKCategoryValueMenstrualFlow
        case .ovulationTestResult: return .ovulationTestResult // HKCategoryValueOvulationTestResult
        case .persistentIntermenstrualBleeding: return .intermenstrualBleeding // HKCategoryValue
        case .pregnancy: return .pregnancy // HKCategoryValue
        case .pregnancyTestResult: return .pregnancyTestResult // HKCategoryValuePregnancyTestResult
        // case .progesteroneTestResult: return .progesteroneTestResult // HKCategoryValueProgesteroneTestResult
        // case .prolongedMenstrualPeriods: return .prolongedMenstrualPeriods // HKCategoryValue
        case .sexualActivity: return .sexualActivity // HKCategoryValue
        // Respiratory
        // Sleep
        case .sleepAnalysis: return .sleepAnalysis // HKCategoryValueSleepAnalysis
        // Symptoms
        case .abdominalCramps: return .abdominalCramps // HKCategoryValueSeverity
        case .acne: return .acne // HKCategoryValueSeverity
        case .appetiteChanges: return .appetiteChanges // HKCategoryValueAppetiteChanges
        case .bladderIncontinence: return .bladderIncontinence // HKCategoryValueSeverity
        case .bloating: return .bloating // HKCategoryValueSeverity
        case .breastPain: return .breastPain // HKCategoryValueSeverity
        case .chestTightnessOrPain: return .chestTightnessOrPain // HKCategoryValueSeverity
        case .chills: return .chills // HKCategoryValueSeverity
        case .constipation: return .constipation // HKCategoryValueSeverity
        case .coughing: return .coughing // HKCategoryValueSeverity
        case .diarrhea: return .diarrhea // HKCategoryValueSeverity
        case .dizziness: return .dizziness // HKCategoryValueSeverity
        case .drySkin: return .drySkin // HKCategoryValueSeverity
        case .fainting: return .fainting // HKCategoryValueSeverity
        case .fatigue: return .fatigue // HKCategoryValueSeverity
        case .fever: return .fever // HKCategoryValueSeverity
        case .generalizedBodyAche: return .generalizedBodyAche // HKCategoryValueSeverity
        case .hairLoss: return .hairLoss // HKCategoryValueSeverity
        case .headache: return .headache // HKCategoryValueSeverity
        case .heartburn: return .heartburn // HKCategoryValueSeverity
        case .hotFlashes: return .hotFlashes // HKCategoryValueSeverity
        case .lossOfSmell: return .lossOfSmell // HKCategoryValueSeverity
        case .lossOfTaste: return .lossOfTaste // HKCategoryValueSeverity
        case .lowerBackPain: return .lowerBackPain // HKCategoryValueSeverity
        case .memoryLapse: return .memoryLapse // HKCategoryValueSeverity
        case .moodChanges: return .moodChanges // HKCategoryValuePresence
        case .nausea: return .nausea // HKCategoryValueSeverity
        case .nightSweats: return .nightSweats // HKCategoryValueSeverity
        case .pelvicPain: return .pelvicPain // HKCategoryValueSeverity
        case .rapidPoundingOrFlutteringHeartbeat: return .rapidPoundingOrFlutteringHeartbeat // HKCategoryValueSeverity
        case .runnyNose: return .runnyNose // HKCategoryValueSeverity
        case .shortnessOfBreath: return .shortnessOfBreath // HKCategoryValueSeverity
        case .sinusCongestion: return .sinusCongestion // HKCategoryValueSeverity
        case .skippedHeartbeat: return .skippedHeartbeat // HKCategoryValueSeverity
        case .sleepChanges: return .sleepChanges // HKCategoryValuePresence
        case .soreThroat: return .soreThroat // HKCategoryValueSeverity
        case .vaginalDryness: return .vaginalDryness // HKCategoryValueSeverity
        case .vomiting: return .vomiting // HKCategoryValueSeverity
        case .wheezing: return .wheezing // HKCategoryValueSeverity
        //case .audioExposureEvent: return .audioExposureEvent
        default:
            return nil
        }
    }
}
