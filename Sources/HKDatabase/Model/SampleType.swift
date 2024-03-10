import Foundation

/**
 A sample type.

 The sample type identifies what type of data a sample contains.

 In the SQLite database, it is stored as an integer.
 */
public enum SampleType {


    /// Body Mass Index
    ///
    /// Raw value: 0
    case bodyMassIndex

    /// Body Fat Percentage
    ///
    /// Raw value: 1
    case bodyFatPercentage

    /// Height
    ///
    /// Raw value: 2
    case height

    /// Body Mass
    ///
    /// Raw value: 3
    case bodyMass

    /// Lean Body Mass
    ///
    /// Raw value: 4
    case leanBodyMass

    /// Heart Rate
    ///
    /// Raw value: 5
    case heartRate

    /// Step Count
    ///
    /// Raw value: 7
    case stepCount

    /// Distance
    ///
    /// Raw value: 8
    case distance

    /// Resting Energy
    ///
    /// Raw value: 9
    case restingEnergy

    /// Active Energy
    ///
    /// Raw value: 10
    case activeEnergyBurned

    /// Flights Climbed
    ///
    /// Raw value: 12
    case flightsClimbed

    /// Oxygen Saturation
    ///
    /// Raw value: 14
    case oxygenSaturation

    /// Blood Glucose
    ///
    /// Raw value: 15
    case bloodGlucose

    /// Blood Pressure Systolic
    ///
    /// Raw value: 16
    case bloodPressureSystolic

    /// Blood Pressure Diastolic
    ///
    /// Raw value: 17
    case bloodPressureDiastolic

    /// Peripheral Perfusion Index
    ///
    /// Raw value: 19
    case peripheralPerfusionIndex

    /// Dietary Fat Total
    ///
    /// Raw value: 20
    case dietaryFatTotal

    /// Dietary Fat Polyunsaturated
    ///
    /// Raw value: 21
    case dietaryFatPolyunsaturated

    /// Dietary Fat Monounsaturated
    ///
    /// Raw value: 22
    case dietaryFatMonounsaturated

    /// Dietary Fat Saturated
    ///
    /// Raw value: 23
    case dietaryFatSaturated

    /// Dietary Cholesterol
    ///
    /// Raw value: 24
    case dietaryCholesterol

    /// Dietary Sodium
    ///
    /// Raw value: 25
    case dietarySodium

    /// Dietary Carbohydrates
    ///
    /// Raw value: 26
    case dietaryCarbohydrates

    /// Dietary Fiber
    ///
    /// Raw value: 27
    case dietaryFiber

    /// Dietary Sugar
    ///
    /// Raw value: 28
    case dietarySugar

    /// Dietary Energy Consumed
    ///
    /// Raw value: 29
    case dietaryEnergyConsumed

    /// Dietary Protein
    ///
    /// Raw value: 30
    case dietaryProtein

    /// Dietary Vitamin A
    ///
    /// Raw value: 31
    case dietaryVitaminA

    /// Dietary Vitamin B6
    ///
    /// Raw value: 32
    case dietaryVitaminB6

    /// Dietary Vitamin B12
    ///
    /// Raw value: 33
    case dietaryVitaminB12

    /// Dietary Vitamin C
    ///
    /// Raw value: 34
    case dietaryVitaminC

    /// Dietary Vitamin D
    ///
    /// Raw value: 35
    case dietaryVitaminD

    /// Dietary Vitamin E
    ///
    /// Raw value: 36
    case dietaryVitaminE

    /// Dietary Vitamin K
    ///
    /// Raw value: 37
    case dietaryVitaminK

    /// Dietary Calcium
    ///
    /// Raw value: 38
    case dietaryCalcium

    /// Dietary Iron
    ///
    /// Raw value: 39
    case dietaryIron

    /// Dietary Thiamin
    ///
    /// Raw value: 40
    case dietaryThiamin

    /// Dietary Riboflavin
    ///
    /// Raw value: 41
    case dietaryRiboflavin

    /// Dietary Niacin
    ///
    /// Raw value: 42
    case dietaryNiacin

    /// Dietary Folate
    ///
    /// Raw value: 43
    case dietaryFolate

    /// Dietary Biotin
    ///
    /// Raw value: 44
    case dietaryBiotin

    /// Dietary Pantothenic Acid
    ///
    /// Raw value: 45
    case dietaryPantothenicAcid

    /// Dietary Phosphorus
    ///
    /// Raw value: 46
    case dietaryPhosphorus

    /// Dietary Iodine
    ///
    /// Raw value: 47
    case dietaryIodine

    /// Dietary Magnesium
    ///
    /// Raw value: 48
    case dietaryMagnesium

    /// Dietary Zinc
    ///
    /// Raw value: 49
    case dietaryZinc

    /// Dietary Selenium
    ///
    /// Raw value: 50
    case dietarySelenium

    /// Dietary Copper
    ///
    /// Raw value: 51
    case dietaryCopper

    /// Dietary Manganese
    ///
    /// Raw value: 52
    case dietaryManganese

    /// Dietary Chromium
    ///
    /// Raw value: 53
    case dietaryChromium

    /// Dietary Molybdenum
    ///
    /// Raw value: 54
    case dietaryMolybdenum

    /// Dietary Chloride
    ///
    /// Raw value: 55
    case dietaryChloride

    /// Dietary Potassium
    ///
    /// Raw value: 56
    case dietaryPotassium

    /// Number Of Times Fallen
    ///
    /// Raw value: 57
    case numberOfTimesFallen

    /// Electrodermal Activity
    ///
    /// Raw value: 58
    case electrodermalActivity

    /// Inhaler Usage
    ///
    /// Raw value: 60
    case inhalerUsage

    /// Respiratory Rate
    ///
    /// Raw value: 61
    case respiratoryRate

    /// Body Temperature
    ///
    /// Raw value: 62
    case bodyTemperature

    /// Sleep Analysis
    ///
    /// Raw value: 63
    case sleepAnalysis

    /// Weekly Calorie Goal
    ///
    /// Raw value: 67
    case weeklyCalorieGoal

    /// Watch On
    ///
    /// Raw value: 70
    case watchOn

    /// Forced Vital Capacity
    ///
    /// Raw value: 71
    case forcedVitalCapacity

    /// Forced Expiratory Volume 1
    ///
    /// Raw value: 72
    case forcedExpiratoryVolume1

    /// Peak Expiratory Flow Rate
    ///
    /// Raw value: 73
    case peakExpiratoryFlowRate

    /// Stand Minutes
    ///
    /// Raw value: 75
    case standMinutes

    /// Activity
    ///
    /// Raw value: 76
    case activity

    /// Dietary Caffeine
    ///
    /// Raw value: 78
    case dietaryCaffeine

    /// Workout
    ///
    /// Raw value: 79
    case workout

    /// Cycling Distance
    ///
    /// Raw value: 83
    case distanceCycling

    /// Dietary Water
    ///
    /// Raw value: 87
    case dietaryWater

    /// UV Exposure
    ///
    /// Raw value: 89
    case uvExposure

    /// Basal Body Temperature
    ///
    /// Raw value: 90
    case basalBodyTemperature

    /// Cervical Mucus Quality
    ///
    /// Raw value: 91
    case cervicalMucusQuality

    /// Ovulation Test Result
    ///
    /// Raw value: 92
    case ovulationTestResult

    /// Menstrual Flow
    ///
    /// Raw value: 95
    case menstrualFlow

    /// Intermenstrual Bleeding
    ///
    /// Raw value: 96
    case intermenstrualBleeding

    /// Sexual Activity
    ///
    /// Raw value: 97
    case sexualActivity

    /// Mindful Session
    ///
    /// Raw value: 99
    case mindfulSession

    /// Push Count
    ///
    /// Raw value: 101
    case pushCount

    /// Data Series
    ///
    /// Raw value: 102
    case dataSeries

    /// Swimming Distance
    ///
    /// Raw value: 110
    case distanceSwimming

    /// Swimming Stroke Count
    ///
    /// Raw value: 111
    case swimmingStrokeCount

    /// Wheelchair Distance
    ///
    /// Raw value: 113
    case distanceWheelchair

    /// Waist Circumference
    ///
    /// Raw value: 114
    case waistCircumference

    /// Resting Heart Rate
    ///
    /// Raw value: 118
    case restingHeartRate

    /// Binary Sample
    ///
    /// Raw value: 119
    case binarySample

    /// VO2 Max
    ///
    /// Raw value: 124
    case vO2Max

    /// Insulin Delivery
    ///
    /// Raw value: 125
    case insulinDelivery

    /// Snow Sports Downhill Distance
    ///
    /// Raw value: 138
    case distanceDownhillSnowSports

    /// Heart Rate Variability SDNN
    ///
    /// Raw value: 139
    case heartRateVariabilitySDNN

    /// EGC Sample
    ///
    /// Raw value: 144
    case ecgSample

    /// Low Heart Rate Event
    ///
    /// Raw value: 147
    case lowHeartRateEvent

    /// Abdominal Cramps
    ///
    /// Raw value: 157
    case abdominalCramps

    /// Breast Pain
    ///
    /// Raw value: 158
    case breastPain

    /// Bloating
    ///
    /// Raw value: 159
    case bloating

    /// Headache
    ///
    /// Raw value: 160
    case headache

    /// Acne
    ///
    /// Raw value: 161
    case acne

    /// Lower Back Pain
    ///
    /// Raw value: 162
    case lowerBackPain

    /// Pelvic Pain
    ///
    /// Raw value: 163
    case pelvicPain

    /// Mood Changes
    ///
    /// Raw value: 164
    case moodChanges

    /// Constipation
    ///
    /// Raw value: 165
    case constipation

    /// Diarrhea
    ///
    /// Raw value: 166
    case diarrhea

    /// Fatigue
    ///
    /// Raw value: 167
    case fatigue

    /// Nausea
    ///
    /// Raw value: 168
    case nausea

    /// Sleep Changes
    ///
    /// Raw value: 169
    case sleepChanges

    /// Appetite Changes
    ///
    /// Raw value: 170
    case appetiteChanges

    /// Hot Flashes
    ///
    /// Raw value: 171
    case hotFlashes

    /// Environmental Audio Exposure
    ///
    /// Raw value: 172
    case environmentalAudioExposure

    /// Headphone Audio Exposure
    ///
    /// Raw value: 173
    case headphoneAudioExposure

    /// Six Minute Walk Test Distance
    ///
    /// Raw value: 183
    case sixMinuteWalkTestDistance

    /// Toothbrushing Event
    ///
    /// Raw value: 189
    case toothbrushingEvent

    /// Pregnancy
    ///
    /// Raw value: 191
    case pregnancy

    /// Lactation
    ///
    /// Raw value: 192
    case lactation

    /// Contraceptive
    ///
    /// Raw value: 193
    case contraceptive

    /// Stair Ascent Speed
    ///
    /// Raw value: 195
    case stairAscentSpeed

    /// Stair Descent Speed
    ///
    /// Raw value: 196
    case stairDescentSpeed

    /// Sleep Schedule Sample
    ///
    /// Samples reference the `sleep_schedule_samples` table.
    ///
    /// Raw value: 198
    case sleepScheduleSample

    /// Rapid Pounding Or Fluttering Heartbeat
    ///
    /// Raw value: 201
    case rapidPoundingOrFlutteringHeartbeat

    /// Skipped Heartbeat
    ///
    /// Raw value: 202
    case skippedHeartbeat

    /// Fever
    ///
    /// Raw value: 203
    case fever

    /// Shortness Of Breath
    ///
    /// Raw value: 204
    case shortnessOfBreath

    /// Chest Tightness Or Pain
    ///
    /// Raw value: 205
    case chestTightnessOrPain

    /// Fainting
    ///
    /// Raw value: 206
    case fainting

    /// Dizziness
    ///
    /// Raw value: 207
    case dizziness

    /// Vomiting
    ///
    /// Raw value: 220
    case vomiting

    /// Heartburn
    ///
    /// Raw value: 221
    case heartburn

    /// Coughing
    ///
    /// Raw value: 222
    case coughing

    /// Wheezing
    ///
    /// Raw value: 223
    case wheezing

    /// SoreThroat
    ///
    /// Raw value: 224
    case soreThroat

    /// Sinus Congestion
    ///
    /// Raw value: 225
    case sinusCongestion

    /// Runny Nose
    ///
    /// Raw value: 226
    case runnyNose

    /// Vaginal Dryness
    ///
    /// Raw value: 229
    case vaginalDryness

    /// Night Sweats
    ///
    /// Raw value: 230
    case nightSweats

    /// Chills
    ///
    /// Raw value: 231
    case chills

    /// Hair Loss
    ///
    /// Raw value: 232
    case hairLoss

    /// Dry Skin
    ///
    /// Raw value: 233
    case drySkin

    /// Bladder Incontinence
    ///
    /// Raw value: 234
    case bladderIncontinence

    /// Memory Lapse
    ///
    /// Raw value: 235
    case memoryLapse

    /// Handwashing Event
    ///
    /// Raw value: 237
    case handwashingEvent

    /// Generalized Body Ache
    ///
    /// Raw value: 240
    case generalizedBodyAche

    /// Loss Of Smell
    ///
    /// Raw value: 241
    case lossOfSmell

    /// Loss Of Taste
    ///
    /// Raw value: 242
    case lossOfTaste

    /// Pregnancy Test Result
    ///
    /// Raw value: 243
    case pregnancyTestResult

    /// Number Of Alcoholic Beverages
    ///
    /// Raw value: 251
    case numberOfAlcoholicBeverages

    /// Running Stride Length
    ///
    /// Raw value: 258
    case runningStrideLength

    /// Running Vertical Oscillation
    ///
    /// Raw value: 259
    case runningVerticalOscillation

    /// Running Ground Contact Time
    ///
    /// Raw value: 260
    case runningGroundContactTime

    /// Heart Rate Recovery One Minute
    ///
    /// Raw value: 266
    case heartRateRecoveryOneMinute

    /// Underwater Depth
    ///
    /// Raw value: 269
    case underwaterDepth

    /// Running Power
    ///
    /// Raw value: 270
    case runningPower

    /// Environmental Sound Reduction
    ///
    /// Raw value: 272
    case environmentalSoundReduction

    /// Running Speed
    ///
    /// Raw value: 274
    case runningSpeed

    /// Water Temperature
    ///
    /// Raw value: 277
    case waterTemperature

    case unknown(Int)
}

extension SampleType: RawRepresentable {

    public init(rawValue: Int) {
        switch rawValue {
        case 0: self = .bodyMassIndex
        case 1: self = .bodyFatPercentage
        case 2: self = .height
        case 3: self = .bodyMass
        case 4: self = .leanBodyMass
        case 5: self = .heartRate
        case 7: self = .stepCount
        case 8: self = .distance
        case 9: self = .restingEnergy
        case 10: self = .activeEnergyBurned
        case 12: self = .flightsClimbed
        case 14: self = .oxygenSaturation
        case 15: self = .bloodGlucose
        case 16: self = .bloodPressureSystolic
        case 17: self = .bloodPressureDiastolic
        case 19: self = .peripheralPerfusionIndex
        case 20: self = .dietaryFatTotal
        case 21: self = .dietaryFatPolyunsaturated
        case 22: self = .dietaryFatMonounsaturated
        case 23: self = .dietaryFatSaturated
        case 24: self = .dietaryCholesterol
        case 25: self = .dietarySodium
        case 26: self = .dietaryCarbohydrates
        case 27: self = .dietaryFiber
        case 28: self = .dietarySugar
        case 29: self = .dietaryEnergyConsumed
        case 30: self = .dietaryProtein
        case 31: self = .dietaryVitaminA
        case 32: self = .dietaryVitaminB6
        case 33: self = .dietaryVitaminB12
        case 34: self = .dietaryVitaminC
        case 35: self = .dietaryVitaminD
        case 36: self = .dietaryVitaminE
        case 37: self = .dietaryVitaminK
        case 38: self = .dietaryCalcium
        case 39: self = .dietaryIron
        case 40: self = .dietaryThiamin
        case 41: self = .dietaryRiboflavin
        case 42: self = .dietaryNiacin
        case 43: self = .dietaryFolate
        case 44: self = .dietaryBiotin
        case 45: self = .dietaryPantothenicAcid
        case 46: self = .dietaryPhosphorus
        case 47: self = .dietaryIodine
        case 48: self = .dietaryMagnesium
        case 49: self = .dietaryZinc
        case 50: self = .dietarySelenium
        case 51: self = .dietaryCopper
        case 52: self = .dietaryManganese
        case 53: self = .dietaryChromium
        case 54: self = .dietaryMolybdenum
        case 55: self = .dietaryChloride
        case 56: self = .dietaryPotassium
        case 57: self = .numberOfTimesFallen
        case 58: self = .electrodermalActivity
        case 60: self = .inhalerUsage
        case 61: self = .respiratoryRate
        case 62: self = .bodyTemperature
        case 63: self = .sleepAnalysis
        case 67: self = .weeklyCalorieGoal
        case 70: self = .watchOn
        case 71: self = .forcedVitalCapacity
        case 72: self = .forcedExpiratoryVolume1
        case 73: self = .peakExpiratoryFlowRate
        case 75: self = .standMinutes
        case 76: self = .activity
        case 78: self = .dietaryCaffeine
        case 79: self = .workout
        case 83: self = .distanceCycling
        case 87: self = .dietaryWater
        case 89: self = .uvExposure
        case 90: self = .basalBodyTemperature
        case 91: self = .cervicalMucusQuality
        case 92: self = .ovulationTestResult
        case 95: self = .menstrualFlow
        case 96: self = .intermenstrualBleeding
        case 97: self = .sexualActivity
        case 99: self = .mindfulSession
        case 101: self = .pushCount
        case 102: self = .dataSeries
        case 110: self = .distanceSwimming
        case 111: self = .swimmingStrokeCount
        case 113: self = .distanceWheelchair
        case 114: self = .waistCircumference
        case 118: self = .restingHeartRate
        case 119: self = .binarySample
        case 124: self = .vO2Max
        case 125: self = .insulinDelivery
        case 138: self = .distanceDownhillSnowSports
        case 144: self = .ecgSample
        case 147: self = .lowHeartRateEvent
        case 139: self = .heartRateVariabilitySDNN
        case 157: self = .abdominalCramps
        case 158: self = .breastPain
        case 159: self = .bloating
        case 160: self = .headache
        case 161: self = .acne
        case 162: self = .lowerBackPain
        case 163: self = .pelvicPain
        case 164: self = .moodChanges
        case 165: self = .constipation
        case 166: self = .diarrhea
        case 167: self = .fatigue
        case 168: self = .nausea
        case 169: self = .sleepChanges
        case 170: self = .appetiteChanges
        case 171: self = .hotFlashes
        case 172: self = .environmentalAudioExposure
        case 173: self = .headphoneAudioExposure
        case 183: self = .sixMinuteWalkTestDistance
        case 189: self = .toothbrushingEvent
        case 191: self = .pregnancy
        case 192: self = .lactation
        case 193: self = .contraceptive
        case 195: self = .stairAscentSpeed
        case 196: self = .stairDescentSpeed
        case 198: self = .sleepScheduleSample
        case 201: self = .rapidPoundingOrFlutteringHeartbeat
        case 202: self = .skippedHeartbeat
        case 203: self = .fever
        case 204: self = .shortnessOfBreath
        case 205: self = .chestTightnessOrPain
        case 206: self = .fainting
        case 207: self = .dizziness
        case 220: self = .vomiting
        case 221: self = .heartburn
        case 222: self = .coughing
        case 223: self = .wheezing
        case 224: self = .soreThroat
        case 225: self = .sinusCongestion
        case 226: self = .runnyNose
        case 229: self = .vaginalDryness
        case 230: self = .nightSweats
        case 231: self = .chills
        case 232: self = .hairLoss
        case 233: self = .drySkin
        case 234: self = .bladderIncontinence
        case 235: self = .memoryLapse
        case 237: self = .handwashingEvent
        case 240: self = .generalizedBodyAche
        case 241: self = .lossOfSmell
        case 242: self = .lossOfTaste
        case 243: self = .pregnancyTestResult
        case 251: self = .numberOfAlcoholicBeverages
        case 258: self = .runningStrideLength
        case 259: self = .runningVerticalOscillation
        case 260: self = .runningGroundContactTime
        case 266: self = .heartRateRecoveryOneMinute
        case 269: self = .underwaterDepth
        case 270: self = .runningPower
        case 272: self = .environmentalSoundReduction
        case 274: self = .runningSpeed
        case 277: self = .waterTemperature
        default:
            self = .unknown(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .stepCount: return 7
        case .weeklyCalorieGoal: return 67
        case .watchOn: return 70
        case .standMinutes: return 75
        case .activity: return 76
        case .workout: return 79
        case .bodyMassIndex: return 0
        case .bodyFatPercentage: return 1
        case .height: return 2
        case .bodyMass: return 3
        case .leanBodyMass: return 4
        case .heartRate: return 5
        case .distance: return 8
        case .restingEnergy: return 9
        case .activeEnergyBurned: return 10
        case .flightsClimbed: return 12
        case .oxygenSaturation: return 14
        case .bloodGlucose: return 15
        case .bloodPressureSystolic: return 16
        case .bloodPressureDiastolic: return 17
        case .peripheralPerfusionIndex: return 19
        case .dietaryFatTotal: return 20
        case .dietaryFatPolyunsaturated: return 21
        case .dietaryFatMonounsaturated: return 22
        case .dietaryFatSaturated: return 23
        case .dietaryCholesterol: return 24
        case .dietarySodium: return 25
        case .dietaryCarbohydrates: return 26
        case .dietaryFiber: return 27
        case .dietarySugar: return 28
        case .dietaryEnergyConsumed: return 29
        case .dietaryProtein: return 30
        case .dietaryVitaminA: return 31
        case .dietaryVitaminB6: return 32
        case .dietaryVitaminB12: return 33
        case .dietaryVitaminC: return 34
        case .dietaryVitaminD: return 35
        case .dietaryVitaminE: return 36
        case .dietaryVitaminK: return 37
        case .dietaryCalcium: return 38
        case .dietaryIron: return 39
        case .dietaryThiamin: return 40
        case .dietaryRiboflavin: return 41
        case .dietaryNiacin: return 42
        case .dietaryFolate: return 43
        case .dietaryBiotin: return 44
        case .dietaryPantothenicAcid: return 45
        case .dietaryPhosphorus: return 46
        case .dietaryIodine: return 47
        case .dietaryMagnesium: return 48
        case .dietaryZinc: return 49
        case .dietarySelenium: return 50
        case .dietaryCopper: return 51
        case .dietaryManganese: return 52
        case .dietaryChromium: return 53
        case .dietaryMolybdenum: return 54
        case .dietaryChloride: return 55
        case .dietaryPotassium: return 56
        case .numberOfTimesFallen: return 57
        case .electrodermalActivity: return 58
        case .inhalerUsage: return 60
        case .respiratoryRate: return 61
        case .bodyTemperature: return 62
        case .sleepAnalysis: return 63
        case .forcedVitalCapacity: return 71
        case .forcedExpiratoryVolume1: return 72
        case .peakExpiratoryFlowRate: return 73
        case .dietaryCaffeine: return 78
        case .distanceCycling: return 83
        case .dietaryWater: return 87
        case .uvExposure: return 89
        case .basalBodyTemperature: return 90
        case .cervicalMucusQuality: return 91
        case .ovulationTestResult: return 92
        case .menstrualFlow: return 95
        case .intermenstrualBleeding: return 96
        case .sexualActivity: return 97
        case .mindfulSession: return 99
        case .pushCount: return 101
        case .dataSeries: return 102
        case .distanceSwimming: return 110
        case .swimmingStrokeCount: return 111
        case .distanceWheelchair: return 113
        case .waistCircumference: return 114
        case .restingHeartRate: return 118
        case .binarySample: return 119
        case .vO2Max: return 124
        case .insulinDelivery: return 125
        case .distanceDownhillSnowSports: return 138
        case .heartRateVariabilitySDNN: return 139
        case .ecgSample: return 144
        case .lowHeartRateEvent: return 147
        case .abdominalCramps: return 157
        case .breastPain: return 158
        case .bloating: return 159
        case .headache: return 160
        case .acne: return 161
        case .lowerBackPain: return 162
        case .pelvicPain: return 163
        case .moodChanges: return 164
        case .constipation: return 165
        case .diarrhea: return 166
        case .fatigue: return 167
        case .nausea: return 168
        case .sleepChanges: return 169
        case .appetiteChanges: return 170
        case .hotFlashes: return 171
        case .environmentalAudioExposure: return 172
        case .headphoneAudioExposure: return 173
        case .sixMinuteWalkTestDistance: return 183
        case .toothbrushingEvent: return 189
        case .pregnancy: return 191
        case .lactation: return 192
        case .contraceptive: return 193
        case .stairAscentSpeed: return 195
        case .stairDescentSpeed: return 196
        case .sleepScheduleSample: return 198
        case .rapidPoundingOrFlutteringHeartbeat: return 201
        case .skippedHeartbeat: return 202
        case .fever: return 203
        case .shortnessOfBreath: return 204
        case .chestTightnessOrPain: return 205
        case .fainting: return 206
        case .dizziness: return 207
        case .vomiting: return 220
        case .heartburn: return 221
        case .coughing: return 222
        case .wheezing: return 223
        case .soreThroat: return 224
        case .sinusCongestion: return 225
        case .runnyNose: return 226
        case .vaginalDryness: return 229
        case .nightSweats: return 230
        case .chills: return 231
        case .hairLoss: return 232
        case .drySkin: return 233
        case .bladderIncontinence: return 234
        case .memoryLapse: return 235
        case .handwashingEvent: return 237
        case .generalizedBodyAche: return 240
        case .lossOfSmell: return 241
        case .lossOfTaste: return 242
        case .pregnancyTestResult: return 243
        case .numberOfAlcoholicBeverages: return 251
        case .runningStrideLength: return 258
        case .runningVerticalOscillation: return 259
        case .runningGroundContactTime: return 260
        case .heartRateRecoveryOneMinute: return 266
        case .underwaterDepth: return 269
        case .runningPower: return 270
        case .environmentalSoundReduction: return 272
        case .runningSpeed: return 274
        case .waterTemperature: return 277
        case .unknown(let value): return value
        }
    }
}

extension SampleType: Equatable {

}

extension SampleType: Hashable {

}

extension SampleType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .bodyMassIndex: return "BodyMassIndex"
        case .bodyFatPercentage: return "BodyFatPercentage"
        case .height: return "Height"
        case .bodyMass: return "Body Mass"
        case .leanBodyMass: return "Lean Body Mass"
        case .heartRate: return "Heart Rate"
        case .stepCount: return "Step Count"
        case .distance: return "Distance"
        case .restingEnergy: return "Resting Energy"
        case .activeEnergyBurned: return "Active Energy Burned"
        case .flightsClimbed: return "Flights Climbed"
        case .oxygenSaturation: return "Oxygen Saturation"
        case .bloodGlucose: return "Blood Glucose"
        case .bloodPressureSystolic: return "Systolic Blood Pressure"
        case .bloodPressureDiastolic: return "Diastolic Blood Pressure"
        case .peripheralPerfusionIndex: return "Peripheral Perfusion Index"
        case .dietaryFatTotal: return "Total Dietary Fat"
        case .dietaryFatPolyunsaturated: return "Dietary Fat Polyunsaturated"
        case .dietaryFatMonounsaturated: return "Dietary Fat Monounsaturated"
        case .dietaryFatSaturated: return "Dietary Fat Saturated"
        case .dietaryCholesterol: return "Dietary Cholesterol"
        case .dietarySodium: return "Dietary Sodium"
        case .dietaryCarbohydrates: return "Dietary Carbohydrates"
        case .dietaryFiber: return "Dietary Fiber"
        case .dietarySugar: return "Dietary Sugar"
        case .dietaryEnergyConsumed: return "Dietary Energy Consumed"
        case .dietaryProtein: return "Dietary Protein"
        case .dietaryVitaminA: return "Dietary Vitamin A"
        case .dietaryVitaminB6: return "Dietary Vitamin B6"
        case .dietaryVitaminB12: return "Dietary Vitamin B12"
        case .dietaryVitaminC: return "Dietary Vitamin C"
        case .dietaryVitaminD: return "Dietary Vitamin D"
        case .dietaryVitaminE: return "Dietary Vitamin E"
        case .dietaryVitaminK: return "Dietary Vitamin K"
        case .dietaryCalcium: return "Dietary Calcium"
        case .dietaryIron: return "Dietary Iron"
        case .dietaryThiamin: return "Dietary Thiamin"
        case .dietaryRiboflavin: return "Dietary Riboflavin"
        case .dietaryNiacin: return "Dietary Niacin"
        case .dietaryFolate: return "Dietary Folate"
        case .dietaryBiotin: return "Dietary Biotin"
        case .dietaryPantothenicAcid: return "Dietary Pantothenic Acid"
        case .dietaryPhosphorus: return "Dietary Phosphorus"
        case .dietaryIodine: return "Dietary Iodine"
        case .dietaryMagnesium: return "Dietary Magnesium"
        case .dietaryZinc: return "Dietary Zinc"
        case .dietarySelenium: return "Dietary Selenium"
        case .dietaryCopper: return "Dietary Copper"
        case .dietaryManganese: return "Dietary Manganese"
        case .dietaryChromium: return "Dietary Chromium"
        case .dietaryMolybdenum: return "Dietary Molybdenum"
        case .dietaryChloride: return "Dietary Chloride"
        case .dietaryPotassium: return "Dietary Potassium"
        case .numberOfTimesFallen: return "Number Of Times Fallen"
        case .electrodermalActivity: return "Electrodermal Activity"
        case .inhalerUsage: return "Inhaler Usage"
        case .respiratoryRate: return "Respiratory Rate"
        case .bodyTemperature: return "Body Temperature"
        case .sleepAnalysis: return "Sleep Analysis"
        case .weeklyCalorieGoal: return "Weekly Calorie Goal"
        case .watchOn: return "Watch On"
        case .forcedVitalCapacity: return "Forced Vital Capacity"
        case .forcedExpiratoryVolume1: return "Forced Expiratory Volume 1"
        case .peakExpiratoryFlowRate: return "Peak Expiratory Flow Rate"
        case .standMinutes: return "Stand Minutes"
        case .activity: return "Activity"
        case .dietaryCaffeine: return "Dietary Caffeine"
        case .workout: return "Workout"
        case .distanceCycling: return "Distance Cycling"
        case .dietaryWater: return "Dietary Water"
        case .uvExposure: return "UV Exposure"
        case .basalBodyTemperature: return "Basal Body Temperature"
        case .cervicalMucusQuality: return "Cervical Mucus Quality"
        case .ovulationTestResult: return "Ovulation Test Result"
        case .menstrualFlow: return "Menstrual Flow"
        case .intermenstrualBleeding: return "Intermenstrual Bleeding"
        case .sexualActivity: return "Sexual Activity"
        case .mindfulSession: return "Mindful Session"
        case .pushCount: return "Push Count"
        case .dataSeries: return "Data Series"
        case .distanceSwimming: return "Distance Swimming"
        case .swimmingStrokeCount: return "Swimming Stroke Count"
        case .distanceWheelchair: return "Distance Wheelchair"
        case .waistCircumference: return "Waist Circumference"
        case .restingHeartRate: return "Resting Heart Rate"
        case .binarySample: return "Binary Sample"
        case .vO2Max: return "VO2 Max"
        case .insulinDelivery: return "Insulin Delivery"
        case .distanceDownhillSnowSports: return "Distance Downhill Snow Sports"
        case .heartRateVariabilitySDNN: return "Heart Rate Variability SDNN"
        case .ecgSample: return "ECG Sample"
        case .lowHeartRateEvent: return "Low Heart Rate Event"
        case .abdominalCramps: return "Abdominal Cramps"
        case .breastPain: return "Breast Pain"
        case .bloating: return "Bloating"
        case .headache: return "Headache"
        case .acne: return "Acne"
        case .lowerBackPain: return "Lower Back Pain"
        case .pelvicPain: return "Pelvic Pain"
        case .moodChanges: return "Mood Changes"
        case .constipation: return "Constipation"
        case .diarrhea: return "Diarrhea"
        case .fatigue: return "Fatigue"
        case .nausea: return "Nausea"
        case .sleepChanges: return "Sleep Changes"
        case .appetiteChanges: return "Appetite Changes"
        case .hotFlashes: return "Hot Flashes"
        case .environmentalAudioExposure: return "Environmental Audio Exposure"
        case .headphoneAudioExposure: return "Headphone Audio Exposure"
        case .sixMinuteWalkTestDistance: return "Six Minute Walk Test Distance"
        case .toothbrushingEvent: return "Toothbrushing Event"
        case .pregnancy: return "Pregnancy"
        case .lactation: return "Lactation"
        case .contraceptive: return "Contraceptive"
        case .stairAscentSpeed: return "Stair Ascent Speed"
        case .stairDescentSpeed: return "Stair Descent Speed"
        case .sleepScheduleSample: return "Sleep Schedule Sample"
        case .rapidPoundingOrFlutteringHeartbeat: return "Rapid Pounding Or Fluttering Heartbeat"
        case .skippedHeartbeat: return "Skipped Heartbeat"
        case .fever: return "Fever"
        case .shortnessOfBreath: return "Shortness Of Breath"
        case .chestTightnessOrPain: return "Chest Tightness Or Pain"
        case .fainting: return "Fainting"
        case .dizziness: return "Dizziness"
        case .vomiting: return "Vomiting"
        case .heartburn: return "Heartburn"
        case .coughing: return "Coughing"
        case .wheezing: return "Wheezing"
        case .soreThroat: return "Sore Throat"
        case .sinusCongestion: return "Sinus Congestion"
        case .runnyNose: return "Runny Nose"
        case .vaginalDryness: return "Vaginal Dryness"
        case .nightSweats: return "Night Sweats"
        case .chills: return "Chills"
        case .hairLoss: return "Hair Loss"
        case .drySkin: return "Dry Skin"
        case .bladderIncontinence: return "Bladder Incontinence"
        case .memoryLapse: return "Memory Lapse"
        case .handwashingEvent: return "Handwashing Event"
        case .generalizedBodyAche: return "Generalized Body Ache"
        case .lossOfSmell: return "Loss Of Smell"
        case .lossOfTaste: return "Loss Of Taste"
        case .pregnancyTestResult: return "Pregnancy Test Result"
        case .numberOfAlcoholicBeverages: return "Number Of Alcoholic Beverages"
        case .runningStrideLength: return "Running Stride Length"
        case .runningVerticalOscillation: return "Running Vertical Oscillation"
        case .runningGroundContactTime: return "Running Ground Contact Time"
        case .heartRateRecoveryOneMinute: return "Heart Rate Recovery One Minute"
        case .underwaterDepth: return "Underwater Depth"
        case .runningPower: return "Running Power"
        case .environmentalSoundReduction: return "Environmental Sound Reduction"
        case .runningSpeed: return "Running Speed"
        case .waterTemperature: return "Water Temperature"
        case .unknown(let int): return "Unknown(\(int))"
        }
    }
}
