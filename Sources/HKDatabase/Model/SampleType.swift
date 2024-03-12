import Foundation

/**
 A sample type.

 The sample type identifies what type of data a sample contains.

 In the SQLite database, it is stored as an integer.
 */
public enum SampleType: Int {

    /**
     Body Mass Index

     Raw value: 0
     */
    case bodyMassIndex = 0

    /**
     Body Fat Percentage

     Raw value: 1
     */
    case bodyFatPercentage = 1

    /**
     Height

     Raw value: 2
     */
    case height = 2

    /**
     Body Mass

     Raw value: 3
     */
    case bodyMass = 3

    /**
     Lean Body Mass

     Raw value: 4
     */
    case leanBodyMass = 4

    /**
     Heart Rate

     Raw value: 5
     */
    case heartRate = 5

    /**
     Step Count

     Raw value: 7
     */
    case stepCount = 7

    /**
     Distance

     Raw value: 8
     */
    case distance = 8

    /**
     Resting Energy

     Raw value: 9
     */
    case restingEnergy = 9

    /**
     Active Energy

     Raw value: 10
     */
    case activeEnergyBurned = 10

    /**
     Flights Climbed

     Raw value: 12
     */
    case flightsClimbed = 11

    /**
     Oxygen Saturation

     Raw value: 14
     */
    case oxygenSaturation = 14

    /**
     Blood Glucose

     Raw value: 15
     */
    case bloodGlucose = 15

    /**
     Blood Pressure Systolic

     Raw value: 16
     */
    case bloodPressureSystolic = 16

    /**
     Blood Pressure Diastolic

     Raw value: 17
     */
    case bloodPressureDiastolic = 17

    /**
     Peripheral Perfusion Index

     Raw value: 19
     */
    case peripheralPerfusionIndex = 19

    /**
     Dietary Fat Total

     Raw value: 20
     */
    case dietaryFatTotal = 20

    /**
     Dietary Fat Polyunsaturated

     Raw value: 21
     */
    case dietaryFatPolyunsaturated = 21

    /**
     Dietary Fat Monounsaturated

     Raw value: 22
     */
    case dietaryFatMonounsaturated = 22

    /**
     Dietary Fat Saturated

     Raw value: 23
     */
    case dietaryFatSaturated = 23

    /**
     Dietary Cholesterol

     Raw value: 24
     */
    case dietaryCholesterol = 24

    /**
     Dietary Sodium

     Raw value: 25
     */
    case dietarySodium = 25

    /**
     Dietary Carbohydrates

     Raw value: 26
     */
    case dietaryCarbohydrates = 26

    /**
     Dietary Fiber

     Raw value: 27
     */
    case dietaryFiber = 27

    /**
     Dietary Sugar

     Raw value: 28
     */
    case dietarySugar = 28

    /**
     Dietary Energy Consumed

     Raw value: 29
     */
    case dietaryEnergyConsumed = 29

    /**
     Dietary Protein

     Raw value: 30
     */
    case dietaryProtein = 30

    /**
     Dietary Vitamin A

     Raw value: 31
     */
    case dietaryVitaminA = 31

    /**
     Dietary Vitamin B6

     Raw value: 32
     */
    case dietaryVitaminB6 = 32

    /**
     Dietary Vitamin B12

     Raw value: 33
     */
    case dietaryVitaminB12 = 33

    /**
     Dietary Vitamin C

     Raw value: 34
     */
    case dietaryVitaminC = 34

    /**
     Dietary Vitamin D

     Raw value: 35
     */
    case dietaryVitaminD = 35

    /**
     Dietary Vitamin E

     Raw value: 36
     */
    case dietaryVitaminE = 36

    /**
     Dietary Vitamin K

     Raw value: 37
     */
    case dietaryVitaminK = 37

    /**
     Dietary Calcium

     Raw value: 38
     */
    case dietaryCalcium = 38

    /**
     Dietary Iron

     Raw value: 39
     */
    case dietaryIron = 39

    /**
     Dietary Thiamin

     Raw value: 40
     */
    case dietaryThiamin = 40

    /**
     Dietary Riboflavin

     Raw value: 41
     */
    case dietaryRiboflavin = 41

    /**
     Dietary Niacin

     Raw value: 42
     */
    case dietaryNiacin = 42

    /**
     Dietary Folate

     Raw value: 43
     */
    case dietaryFolate = 43

    /**
     Dietary Biotin

     Raw value: 44
     */
    case dietaryBiotin = 44

    /**
     Dietary Pantothenic Acid

     Raw value: 45
     */
    case dietaryPantothenicAcid = 45

    /**
     Dietary Phosphorus

     Raw value: 46
     */
    case dietaryPhosphorus = 46

    /**
     Dietary Iodine

     Raw value: 47
     */
    case dietaryIodine = 47

    /**
     Dietary Magnesium

     Raw value: 48
     */
    case dietaryMagnesium = 48

    /**
     Dietary Zinc

     Raw value: 49
     */
    case dietaryZinc = 49

    /**
     Dietary Selenium

     Raw value: 50
     */
    case dietarySelenium = 50

    /**
     Dietary Copper

     Raw value: 51
     */
    case dietaryCopper = 51

    /**
     Dietary Manganese

     Raw value: 52
     */
    case dietaryManganese = 52

    /**
     Dietary Chromium

     Raw value: 53
     */
    case dietaryChromium = 53

    /**
     Dietary Molybdenum

     Raw value: 54
     */
    case dietaryMolybdenum = 54

    /**
     Dietary Chloride

     Raw value: 55
     */
    case dietaryChloride = 55

    /**
     Dietary Potassium

     Raw value: 56
     */
    case dietaryPotassium = 56

    /**
     Number Of Times Fallen

     Raw value: 57
     */
    case numberOfTimesFallen = 57

    /**
     Electrodermal Activity

     Raw value: 58
     */
    case electrodermalActivity = 58

    /**
     Inhaler Usage

     Raw value: 60
     */
    case inhalerUsage = 60

    /**
     Respiratory Rate

     Raw value: 61
     */
    case respiratoryRate = 61

    /**
     Body Temperature

     Raw value: 62
     */
    case bodyTemperature = 62

    /**
     Sleep Analysis

     Raw value: 63
     */
    case sleepAnalysis = 63

    /**
     Weekly Calorie Goal

     Raw value: 67
     */
    case weeklyCalorieGoal = 67

    /**
     Watch On

     Raw value: 70
     */
    case watchOn = 70

    /**
     Forced Vital Capacity

     Raw value: 71
     */
    case forcedVitalCapacity = 71

    /**
     Forced Expiratory Volume 1

     Raw value: 72
     */
    case forcedExpiratoryVolume1 = 72

    /**
     Peak Expiratory Flow Rate

     Raw value: 73
     */
    case peakExpiratoryFlowRate = 73

    /**
     Stand Minutes

     Raw value: 75
     */
    case standMinutes = 75

    /**
     Activity

     Raw value: 76
     */
    case activity = 76

    /**
     Dietary Caffeine

     Raw value: 78
     */
    case dietaryCaffeine = 78

    /**
     Workout

     Raw value: 79
     */
    case workout = 79

    /**
     Cycling Distance

     Raw value: 83
     */
    case distanceCycling = 83

    /**
     Dietary Water

     Raw value: 87
     */
    case dietaryWater = 87

    /**
     UV Exposure

     Raw value: 89
     */
    case uvExposure = 89

    /**
     Basal Body Temperature

     Raw value: 90
     */
    case basalBodyTemperature = 90

    /**
     Cervical Mucus Quality

     Raw value: 91
     */
    case cervicalMucusQuality = 91

    /**
     Ovulation Test Result

     Raw value: 92
     */
    case ovulationTestResult = 92

    /**
     Menstrual Flow

     Raw value: 95
     */
    case menstrualFlow = 95

    /**
     Intermenstrual Bleeding

     Raw value: 96
     */
    case intermenstrualBleeding = 96

    /**
     Sexual Activity

     Raw value: 97
     */
    case sexualActivity = 97

    /**
     Mindful Session

     Raw value: 99
     */
    case mindfulSession = 99

    /**
     Push Count

     Raw value: 101
     */
    case pushCount = 101

    /**
     Data Series

     Raw value: 102
     */
    case dataSeries = 102

    /**
     Swimming Distance

     Raw value: 110
     */
    case distanceSwimming = 110

    /**
     Swimming Stroke Count

     Raw value: 111
     */
    case swimmingStrokeCount = 111

    /**
     Wheelchair Distance

     Raw value: 113
     */
    case distanceWheelchair = 113

    /**
     Waist Circumference

     Raw value: 114
     */
    case waistCircumference = 114

    /**
     Resting Heart Rate

     Raw value: 118
     */
    case restingHeartRate = 118

    /**
     Binary Sample

     Raw value: 119
     */
    case binarySample = 119

    /**
     VO2 Max

     Raw value: 124
     */
    case vO2Max = 124

    /**
     Insulin Delivery

     Raw value: 125
     */
    case insulinDelivery = 125

    /**
     Snow Sports Downhill Distance

     Raw value: 138
     */
    case distanceDownhillSnowSports = 138

    /**
     Heart Rate Variability SDNN

     Raw value: 139
     */
    case heartRateVariabilitySDNN = 139

    /**
     EGC Sample

     Raw value: 144
     */
    case ecgSample = 144

    /**
     Low Heart Rate Event

     Raw value: 147
     */
    case lowHeartRateEvent = 147

    /**
     Abdominal Cramps

     Raw value: 157
     */
    case abdominalCramps = 157

    /**
     Breast Pain

     Raw value: 158
     */
    case breastPain = 158

    /**
     Bloating

     Raw value: 159
     */
    case bloating = 159

    /**
     Headache

     Raw value: 160
     */
    case headache = 160

    /**
     Acne

     Raw value: 161
     */
    case acne = 161

    /**
     Lower Back Pain

     Raw value: 162
     */
    case lowerBackPain = 162

    /**
     Pelvic Pain

     Raw value: 163
     */
    case pelvicPain = 163

    /**
     Mood Changes

     Raw value: 164
     */
    case moodChanges = 164

    /**
     Constipation

     Raw value: 165
     */
    case constipation = 165

    /**
     Diarrhea

     Raw value: 166
     */
    case diarrhea = 166

    /**
     Fatigue

     Raw value: 167
     */
    case fatigue = 167

    /**
     Nausea

     Raw value: 168
     */
    case nausea = 168

    /**
     Sleep Changes

     Raw value: 169
     */
    case sleepChanges = 169

    /**
     Appetite Changes

     Raw value: 170
     */
    case appetiteChanges = 170

    /**
     Hot Flashes

     Raw value: 171
     */
    case hotFlashes = 171

    /**
     Environmental Audio Exposure

     Raw value: 172
     */
    case environmentalAudioExposureEvent = 172

    /**
     Headphone Audio Exposure

     Raw value: 173
     */
    case headphoneAudioExposureEvent = 173

    /**
     Six Minute Walk Test Distance

     Raw value: 183
     */
    case sixMinuteWalkTestDistance = 183

    /**
     Toothbrushing Event

     Raw value: 189
     */
    case toothbrushingEvent = 189

    /**
     Pregnancy

     Raw value: 191
     */
    case pregnancy = 191

    /**
     Lactation

     Raw value: 192
     */
    case lactation = 192

    /**
     Contraceptive

     Raw value: 193
     */
    case contraceptive = 193

    /**
     Stair Ascent Speed

     Raw value: 195
     */
    case stairAscentSpeed = 195

    /**
     Stair Descent Speed

     Raw value: 196
     */
    case stairDescentSpeed = 196

    /**
     Sleep Schedule Sample

     Samples reference the `sleep_schedule_samples` table.

     Raw value: 198
     */
    case sleepScheduleSample = 198

    /**
     Rapid Pounding Or Fluttering Heartbeat

     Raw value: 201
     */
    case rapidPoundingOrFlutteringHeartbeat = 201

    /**
     Skipped Heartbeat

     Raw value: 202
     */
    case skippedHeartbeat = 202

    /**
     Fever

     Raw value: 203
     */
    case fever = 203

    /**
     Shortness Of Breath

     Raw value: 204
     */
    case shortnessOfBreath = 204

    /**
     Chest Tightness Or Pain

     Raw value: 205
     */
    case chestTightnessOrPain = 205

    /**
     Fainting

     Raw value: 206
     */
    case fainting = 206

    /**
     Dizziness

     Raw value: 207
     */
    case dizziness = 207

    /**
     Vomiting

     Raw value: 220
     */
    case vomiting = 220

    /**
     Heartburn

     Raw value: 221
     */
    case heartburn = 221

    /**
     Coughing

     Raw value: 222
     */
    case coughing = 222

    /**
     Wheezing

     Raw value: 223
     */
    case wheezing = 223

    /**
     SoreThroat

     Raw value: 224
     */
    case soreThroat = 224

    /**
     Sinus Congestion

     Raw value: 225
     */
    case sinusCongestion = 225

    /**
     Runny Nose

     Raw value: 226
     */
    case runnyNose = 226

    /**
     Vaginal Dryness

     Raw value: 229
     */
    case vaginalDryness = 229

    /**
     Night Sweats

     Raw value: 230
     */
    case nightSweats = 230

    /**
     Chills

     Raw value: 231
     */
    case chills = 231

    /**
     Hair Loss

     Raw value: 232
     */
    case hairLoss = 232

    /**
     Dry Skin

     Raw value: 233
     */
    case drySkin = 233

    /**
     Bladder Incontinence

     Raw value: 234
     */
    case bladderIncontinence = 234

    /**
     Memory Lapse

     Raw value: 235
     */
    case memoryLapse = 235

    /**
     Handwashing Event

     Raw value: 237
     */
    case handwashingEvent = 237

    /**
     Generalized Body Ache

     Raw value: 240
     */
    case generalizedBodyAche = 240

    /**
     Loss Of Smell

     Raw value: 241
     */
    case lossOfSmell = 241

    /**
     Loss Of Taste

     Raw value: 242
     */
    case lossOfTaste = 242

    /**
     Pregnancy Test Result

     Raw value: 243
     */
    case pregnancyTestResult = 243

    /**
     Number Of Alcoholic Beverages

     Raw value: 251
     */
    case numberOfAlcoholicBeverages = 251

    /**
     Running Stride Length

     Raw value: 258
     */
    case runningStrideLength = 258

    /**
     Running Vertical Oscillation

     Raw value: 259
     */
    case runningVerticalOscillation = 259

    /**
     Running Ground Contact Time

     Raw value: 260
     */
    case runningGroundContactTime = 260

    /**
     Heart Rate Recovery One Minute

     Raw value: 266
     */
    case heartRateRecoveryOneMinute = 266

    /**
     Underwater Depth

     Raw value: 269
     */
    case underwaterDepth = 269

    /**
     Running Power

     Raw value: 270
     */
    case runningPower = 270

    /**
     Environmental Sound Reduction

     Raw value: 272
     */
    case environmentalSoundReduction = 272

    /**
     Running Speed

     Raw value: 274
     */
    case runningSpeed = 274

    /**
     Water Temperature

     Raw value: 277
     */
    case waterTemperature = 277
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
        case .environmentalAudioExposureEvent: return "Environmental Audio Exposure"
        case .headphoneAudioExposureEvent: return "Headphone Audio Exposure"
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
        }
    }
}
