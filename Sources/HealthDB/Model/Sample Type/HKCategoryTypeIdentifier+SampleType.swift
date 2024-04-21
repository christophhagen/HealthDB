import Foundation
import HealthKit

extension HKCategoryTypeIdentifier {

    var sampleType: SampleType {
        .category(self)
    }
}

extension HKCategoryTypeIdentifier: LosslessIntegerConvertible {

    static let map: BiDictionary<HKCategoryTypeIdentifier, Int> = [
        .appleStandHour: 70,

        // Hearing Health

        // - NOTE: Apple automatically converts this to `.environmentalAudioExposureEvent`
        //.audioExposureEvent: 178,
        .environmentalAudioExposureEvent: 178,
        //.headphoneAudioExposureEvent: <#T##Int#>,

        // Heart
        // .highHeartRateEvent: <#T##Int#>,
        // .irregularHeartRhythmEvent: <#T##Int#>,
        // .lowCardioFitnessEvent: <#T##Int#>,
        .lowHeartRateEvent: 147,

        // Mindfulness
        .mindfulSession: 99,

        // Mobility

        // .appleWalkingSteadinessEvent: <#T##Int#>,

        // Other
        .handwashingEvent: 237,
        .toothbrushingEvent: 189,

        // Reproductive Health

        .cervicalMucusQuality: 91,
        .contraceptive: 193,
        // .infrequentMenstrualCycles: <#T##Int#>,
        .intermenstrualBleeding: 96,
        .irregularMenstrualCycles: 262,
        .lactation: 192,
        .menstrualFlow: 95,
        .ovulationTestResult: 92,
        .persistentIntermenstrualBleeding: 264,
        .pregnancy: 191,
        .pregnancyTestResult: 243,
        .progesteroneTestResult: 244,
        .prolongedMenstrualPeriods: 263,
        .sexualActivity: 97,

        // Respiratory

        // Sleep

        .sleepAnalysis: 63,

        // Symptoms

        .abdominalCramps: 157,
        .acne: 161,
        .appetiteChanges: 170,
        .bladderIncontinence: 234,
        .bloating: 159,
        .breastPain: 158,
        .chestTightnessOrPain: 205,
        .chills: 231,
        .constipation: 165,
        .coughing: 222,
        .diarrhea: 166,
        .dizziness: 207,
        .drySkin: 233,
        .fainting: 206,
        .fatigue: 167,
        .fever: 203,
        .generalizedBodyAche: 240,
        .hairLoss: 232,
        .headache: 160,
        .heartburn: 221,
        .hotFlashes: 171,
        .lossOfSmell: 241,
        .lossOfTaste: 242,
        .lowerBackPain: 162,
        .memoryLapse: 235,
        .moodChanges: 164,
        .nausea: 168,
        .nightSweats: 230,
        .pelvicPain: 163,
        .rapidPoundingOrFlutteringHeartbeat: 201,
        .runnyNose: 226,
        .shortnessOfBreath: 204,
        .sinusCongestion: 225,
        .skippedHeartbeat: 202,
        .sleepChanges: 169,
        .soreThroat: 224,
        .vaginalDryness: 229,
        .vomiting: 220,
        .wheezing: 223,
    ]
}
