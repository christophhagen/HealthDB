import Foundation
import HealthKit

extension HKCategoryTypeIdentifier {

    init?(sampleType: SampleType) {
        switch sampleType {
            case .appleStandHour: self = .appleStandHour
            // Hearing Health
            case .environmentalAudioExposureEvent: self = .environmentalAudioExposureEvent // HKCategoryValueEnvironmentalAudioExposureEvent
            case .headphoneAudioExposureEvent: self = .headphoneAudioExposureEvent // HKCategoryValueHeadphoneAudioExposureEvent
            // Heart
            // case .highHeartRateEvent: self = .highHeartRateEvent // HKCategoryValue
            // case .irregularHeartRhythmEvent: self = .irregularHeartRhythmEvent // HKCategoryValue
            // case .lowCardioFitnessEvent: self = .lowCardioFitnessEvent // HKCategoryValueLowCardioFitnessEvent
            case .lowHeartRateEvent: self = .lowHeartRateEvent // HKCategoryValue
            // Mindfulness
            case .mindfulSession: self = .mindfulSession // HKCategoryValue
            // Mobility
            // case .appleWalkingSteadinessEvent: self = .appleWalkingSteadinessEvent // HKCategoryValueAppleWalkingSteadinessEvent
            // Other
            case .handwashingEvent: self = .handwashingEvent // HKCategoryValue
            case .toothbrushingEvent: self = .toothbrushingEvent // HKCategoryValue
            // Reproductive Health
            case .cervicalMucusQuality: self = .cervicalMucusQuality // HKCategoryValueCervicalMucusQuality
            case .contraceptive: self = .contraceptive // HKCategoryValueContraceptive
            // case .infrequentMenstrualCycles: self = .infrequentMenstrualCycles // HKCategoryValue
            case .intermenstrualBleeding: self = .intermenstrualBleeding // HKCategoryValue
            case .irregularMenstrualCycles: self = .irregularMenstrualCycles // HKCategoryValue
            case .lactation: self = .lactation // HKCategoryValue
            case .menstrualFlow: self = .menstrualFlow // HKCategoryValueMenstrualFlow
            case .ovulationTestResult: self = .ovulationTestResult // HKCategoryValueOvulationTestResult
            case .persistentIntermenstrualBleeding: self = .persistentIntermenstrualBleeding // HKCategoryValue
            case .pregnancy: self = .pregnancy // HKCategoryValue
            case .pregnancyTestResult: self = .pregnancyTestResult // HKCategoryValuePregnancyTestResult
            case .progesteroneTestResult: self = .progesteroneTestResult // HKCategoryValueProgesteroneTestResult
            case .prolongedMenstrualPeriods: self = .prolongedMenstrualPeriods // HKCategoryValue
            case .sexualActivity: self = .sexualActivity // HKCategoryValue
            // Respiratory
            // Sleep
            case .sleepAnalysis: self = .sleepAnalysis // HKCategoryValueSleepAnalysis
            // Symptoms
            case .abdominalCramps: self = .abdominalCramps // HKCategoryValueSeverity
            case .acne: self = .acne // HKCategoryValueSeverity
            case .appetiteChanges: self = .appetiteChanges // HKCategoryValueAppetiteChanges
            case .bladderIncontinence: self = .bladderIncontinence // HKCategoryValueSeverity
            case .bloating: self = .bloating // HKCategoryValueSeverity
            case .breastPain: self = .breastPain // HKCategoryValueSeverity
            case .chestTightnessOrPain: self = .chestTightnessOrPain // HKCategoryValueSeverity
            case .chills: self = .chills // HKCategoryValueSeverity
            case .constipation: self = .constipation // HKCategoryValueSeverity
            case .coughing: self = .coughing // HKCategoryValueSeverity
            case .diarrhea: self = .diarrhea // HKCategoryValueSeverity
            case .dizziness: self = .dizziness // HKCategoryValueSeverity
            case .drySkin: self = .drySkin // HKCategoryValueSeverity
            case .fainting: self = .fainting // HKCategoryValueSeverity
            case .fatigue: self = .fatigue // HKCategoryValueSeverity
            case .fever: self = .fever // HKCategoryValueSeverity
            case .generalizedBodyAche: self = .generalizedBodyAche // HKCategoryValueSeverity
            case .hairLoss: self = .hairLoss // HKCategoryValueSeverity
            case .headache: self = .headache // HKCategoryValueSeverity
            case .heartburn: self = .heartburn // HKCategoryValueSeverity
            case .hotFlashes: self = .hotFlashes // HKCategoryValueSeverity
            case .lossOfSmell: self = .lossOfSmell // HKCategoryValueSeverity
            case .lossOfTaste: self = .lossOfTaste // HKCategoryValueSeverity
            case .lowerBackPain: self = .lowerBackPain // HKCategoryValueSeverity
            case .memoryLapse: self = .memoryLapse // HKCategoryValueSeverity
            case .moodChanges: self = .moodChanges // HKCategoryValuePresence
            case .nausea: self = .nausea // HKCategoryValueSeverity
            case .nightSweats: self = .nightSweats // HKCategoryValueSeverity
            case .pelvicPain: self = .pelvicPain // HKCategoryValueSeverity
            case .rapidPoundingOrFlutteringHeartbeat: self = .rapidPoundingOrFlutteringHeartbeat // HKCategoryValueSeverity
            case .runnyNose: self = .runnyNose // HKCategoryValueSeverity
            case .shortnessOfBreath: self = .shortnessOfBreath // HKCategoryValueSeverity
            case .sinusCongestion: self = .sinusCongestion // HKCategoryValueSeverity
            case .skippedHeartbeat: self = .skippedHeartbeat // HKCategoryValueSeverity
            case .sleepChanges: self = .sleepChanges // HKCategoryValuePresence
            case .soreThroat: self = .soreThroat // HKCategoryValueSeverity
            case .vaginalDryness: self = .vaginalDryness // HKCategoryValueSeverity
            case .vomiting: self = .vomiting // HKCategoryValueSeverity
            case .wheezing: self = .wheezing // HKCategoryValueSeverity
            /// - NOTE: Apple automatically converts this to `.environmentalAudioExposureEvent`
            case .audioExposureEvent: self = .audioExposureEvent
            default:
                return nil
        }
    }

    var sampleType: SampleType? {
        switch self {
        case .appleStandHour: return .appleStandHour
        // Hearing Health
        case .environmentalAudioExposureEvent: return .environmentalAudioExposureEvent // HKCategoryValueEnvironmentalAudioExposureEvent
        case .headphoneAudioExposureEvent: return .headphoneAudioExposureEvent // HKCategoryValueHeadphoneAudioExposureEvent
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
        case .irregularMenstrualCycles: return .irregularMenstrualCycles // HKCategoryValue
        case .lactation: return .lactation // HKCategoryValue
        case .menstrualFlow: return .menstrualFlow // HKCategoryValueMenstrualFlow
        case .ovulationTestResult: return .ovulationTestResult // HKCategoryValueOvulationTestResult
        case .persistentIntermenstrualBleeding: return .persistentIntermenstrualBleeding // HKCategoryValue
        case .pregnancy: return .pregnancy // HKCategoryValue
        case .pregnancyTestResult: return .pregnancyTestResult // HKCategoryValuePregnancyTestResult
        case .progesteroneTestResult: return .progesteroneTestResult // HKCategoryValueProgesteroneTestResult
        case .prolongedMenstrualPeriods: return .prolongedMenstrualPeriods // HKCategoryValue
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
        case .audioExposureEvent: return .audioExposureEvent
        default:
            return nil
        }
    }
}
