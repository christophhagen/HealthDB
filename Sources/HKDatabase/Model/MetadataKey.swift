import Foundation
import HealthKit

/**
 A collection of private metadata keys used in the SQLite database
 */
public enum HKMetadataPrivateKey {

    /// Value type: ``String``
    public static let mediaSourceBundleIdentifier = "_HKPrivateMediaSourceBundleIdentifier"

    /// Value type: ``Date``
    public static let sleepAlarmUserWakeTime = "_HKPrivateSleepAlarmUserWakeTime"

    /// Value type: ``Date``
    public static let sleepAlarmUserSetBedtime = "_HKPrivateSleepAlarmUserSetBedtime"

    /// Value type: ``NSNumber``
    public static let headphoneAudioDataIsTransient = "_HKPrivateMetadataKeyHeadphoneAudioDataIsTransient"

    /// Value type: ``String``
    public static let coreMotionSourceIdentifier = "_HKPrivateCoreMotionSourceIdentifier"

    /// Value type: ``NSNumber``
    public static let heartRateContext = "_HKPrivateHeartRateContext"

    /// Value type: ``NSNumber``
    public static let appleHeartbeatSeriesAlgorithmVersion = "_HKPrivateMetadataKeyAppleHeartbeatSeriesAlgorithmVersion"

    /// Value type: ``NSNumber``
    public static let bloodOxygenContext = "_HKPrivateBloodOxygenContext"

    /// Value type: ``NSNumber``
    public static let heartbeatSequenceContext = "_HKPrivateHeartbeatSequenceContext"

    /// Value type: ``NSNumber``
    public static let regulatedUpdateVersion = "_HKPrivateMetadataKeyRegulatedUpdateVersion"

    /// Value type: ``NSNumber``
    public static let activitySummaryIndex = "_HKPrivateActivitySummaryIndex"

    /// Value type: ``NSNumber``
    public static let deepBreathingEndReason = "_HKPrivateDeepBreathingEndReason"

    /// Value type: ``NSNumber``
    public static let deepBreathingFinalHeartRate = "_HKPrivateDeepBreathingFinalHeartRate"

    /// Value type: ``NSNumber``
    public static let mindfulnessSessionType = "_HKPrivateMetadataMindfulnessSessionType"

    /// Value type: ``Quantity``, unit count/s
    public static let workoutAverageHeartRate = "_HKPrivateWorkoutAverageHeartRate"

    /// Value type: ``Quantity``, unit count/s
    public static let workoutMaxHeartRate = "_HKPrivateWorkoutMaxHeartRate"

    /// Value type: ``NSNumber``
    public static let weatherCondition = "_HKPrivateWeatherCondition"

    /// Value type: ``NSNumber``
    public static let workoutWeatherLocationCoordinatesLongitude = "_HKPrivateWorkoutWeatherLocationCoordinatesLongitude"

    /// Value type: ``Quantity``, unit count/s
    public static let workoutMinHeartRate = "_HKPrivateWorkoutMinHeartRate"

    /// Value type: ``NSNumber``
    public static let workoutWasInDaytime = "_HKPrivateWorkoutWasInDaytime"

    /// Value type: ``NSNumber``
    public static let workoutActivityMoveMode = "_HKPrivateWorkoutActivityMoveMode"

    /// Value type: ``NSNumber``
    public static let workoutWeatherLocationCoordinatesLatitude = "_HKPrivateWorkoutWeatherLocationCoordinatesLatitude"

    /// Value type: ``NSNumber``
    public static let lostGPSAtSomePoint = "_HKPrivateMetadataKeyLostGPSAtSomePoint"

    /// Value type: ``Quantity``, unit m
    public static let workoutMinGroundElevation = "_HKPrivateWorkoutMinGroundElevation"

    /// Value type: ``Quantity``, unit m
    public static let workoutMaxGroundElevation = "_HKPrivateWorkoutMaxGroundElevation"

    /// Value type: ``Quantity``, unit count/min
    public static let workoutAverageCadence = "_HKPrivateWorkoutAverageCadence"

    /// Value type: ``NSNumber``
    public static let userOnBetaBlocker = "_HKPrivateMetadataKeyUserOnBetaBlocker"

    /// Value type: ``Quantity``, unit dBASPL
    public static let audioExposureLimit = "_HKPrivateMetadataKeyAudioExposureLimit"

    /// Value type: ``Quantity``, unit count/min
    public static let heartRateEventThreshold = "_HKPrivateMetadataKeyHeartRateEventThreshold"

    /// Value type: `` ``
    public static let workoutTargetZoneMax = "_HKPrivateWorkoutTargetZoneMax"

    /// Value type: `` ``
    public static let workoutTargetZoneType = "_HKPrivateWorkoutTargetZoneType"

    /// Value type: `` ``
    public static let workoutTargetZoneMin = "_HKPrivateWorkoutTargetZoneMin"

    /// Value type: ``NSNumber``
    public static let fallActionRequested = "_HKPrivateFallActionRequested"

    /// Value type: ``Date``
    public static let workoutElapsedTimeInHeartRateZones = "_HKPrivateWorkoutElapsedTimeInHeartRateZones"

    /// Value type: ``String``
    public static let workoutWeatherSourceName = "_HKPrivateWorkoutWeatherSourceName"

    /// Value type: ``Data``
    public static let workoutHeartRateZones = "_HKPrivateWorkoutHeartRateZones"

    /// Value type: ``Data``
    public static let workoutConfiguration = "_HKPrivateWorkoutConfiguration"

    /// Value type: ``NSNumber``
    public static let workoutHeartRateZonesConfigurationType = "_HKPrivateWorkoutHeartRateZonesConfigurationType"

    /// Value type: ``Data``
    public static let workoutHeartRateZonesCurrentZoneIndex = "_HKPrivateWorkoutHeartRateZonesCurrentZoneIndex"

    /// Value type: ``Data``
    public static let workoutHeartRateZonesLastProcessedEntryDate = "_HKPrivateWorkoutHeartRateZonesLastProcessedEntryDate"

    /// Value type: ``Data``
    public static let workoutHeartRateZonesLastProcessedEventDate = "_HKPrivateWorkoutHeartRateZonesLastProcessedEventDate"

    /// Value type: ``Data``
    public static let workoutCyclingPowerZonesAutomaticFTP = "_HKPrivateWorkoutCyclingPowerZonesAutomaticFTP"

    /// Value type: ``Data``
    public static let workoutCyclingPowerZonesConfiguration = "_HKPrivateWorkoutCyclingPowerZonesConfiguration"

    /// Value type: ``Data``
    public static let workoutElapsedTimeInCyclingPowerZones = "_HKPrivateWorkoutElapsedTimeInCyclingPowerZones"

    /// Value type: ``Quantity``, unit W
    public static let workoutAveragePower = "_HKPrivateWorkoutAveragePower"

    /// Value type: ``String``
    public static let metricPlatterStatistics = "_HKPrivateMetadataKeyMetricPlatterStatistics"

    /// Value type: ``NSNumber``
    public static let workoutExtendedMode = "_HKPrivateWorkoutExtendedMode"

    /// Value type: ``String``
    public static let sessionID = "_HKPrivateMetadataKeySessionID"

    /// Value type: ``NSNumber``
    public static let fastestPace = "_HKPrivateMetadataKeyFastestPace"

    /// Value type: ``NSNumber``
    public static let mirroredWorkout = "_HKPrivateMetadataKeyMirroredWorkout"

}

/**
 Some of the official metadata keys
 */
public enum HKMetadataKey {

    /**
     - Value type: ``String``
     - String value: `HKExternalUUID`
     - HealthKit Constant: ``HKMetadataKeyExternalUUID``
     */
    public static let externalUUID = HKMetadataKeyExternalUUID

    /**
     - Value type: ``NSNumber``
     - String value: `HKActivityType`
     - HealthKit Constant: ``HKMetadataKeyActivityType``
     */
    @available(watchOS 10.0, iOS 17.0, macOS 14.0, *)
    public static let activityType = HKMetadataKeyActivityType

    /**
     - Value type: ``NSNumber``
     - String value: `HKAlgorithmVersion`
     - HealthKit Constant: ``HKMetadataKeyAlgorithmVersion``
     */
    public static let algorithmVersion = HKMetadataKeyAlgorithmVersion

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyAppleDeviceCalibrated`
     - HealthKit Constant: ``HKMetadataKeyAppleDeviceCalibrated``
     */
    public static let appleDeviceCalibrated = HKMetadataKeyAppleDeviceCalibrated

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyAppleECGAlgorithmVersion`
     - HealthKit Constant: ``HKMetadataKeyAppleECGAlgorithmVersion``
     */
    public static let appleECGAlgorithmVersion = HKMetadataKeyAppleECGAlgorithmVersion

    /**
     - Value type: ``Quantity``, unit dBASPL
     - String value: `HKMetadataKeyAudioExposureLevel`
     - HealthKit Constant: ``HKMetadataKeyAudioExposureLevel``
     */
    public static let audioExposureLevel = HKMetadataKeyAudioExposureLevel

    /**
     - Value type: ``Quantity``, unit kcal/hr·kg
     - String value: `HKAverageMETs`
     - HealthKit Constant: ``HKMetadataKeyAverageMETs``
     */
    public static let averageMETs = HKMetadataKeyAverageMETs

    /**
     - Value type: ``Quantity``, unit kPa
     - String value: `HKMetadataKeyBarometricPressure`
     - HealthKit Constant: ``HKMetadataKeyBarometricPressure``
     */
    public static let barometricPressure = HKMetadataKeyBarometricPressure

    /**
     The earliest date of data used to calculate the sample’s estimated value.

     This key takes a ``Date`` value, indicating the earliest date from the data used by HealthKit to calculate the sample’s value.
     - Value type: ``Date``
     - String value: `HKDateOfEarliestDataUsedForEstimate`
     - HealthKit Constant: ``HKMetadataKeyDateOfEarliestDataUsedForEstimate``
     */
    public static let dateOfEarliestDataUsedForEstimate = HKMetadataKeyDateOfEarliestDataUsedForEstimate

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyDevicePlacementSide`
     - HealthKit Constant: ``HKMetadataKeyDevicePlacementSide``
     */
    public static let devicePlacementSide = HKMetadataKeyDevicePlacementSide

    /**
     - Value type: ``Quantity``, unit cm
     - String value: `HKElevationAscended`
     - HealthKit Constant: ``HKMetadataKeyElevationAscended``
     */
    public static let elevationAscended = HKMetadataKeyElevationAscended

    /**
     A description of the glasses prescription.

     If a glasses prescription was designed for a particular use, like reading or distance, use this metadata key to describe that use.

     - Value type: ``String``
     - String value: `HKMetadataKeyGlassesPrescriptionDescription`
     - HealthKit Constant: ``HKMetadataKeyGlassesPrescriptionDescription``
     */
    public static let glassesPrescriptionDescription = HKMetadataKeyGlassesPrescriptionDescription

    /**
     - Value type: ``Quantity``, unit count/min
     - String value: `HKHeartRateEventThreshold`
     - HealthKit Constant: ``HKMetadataKeyHeartRateEventThreshold``
     */
    public static let heartRateEventThreshold = HKMetadataKeyHeartRateEventThreshold

    /**
     - Value type: ``Quantity``, unit s
     - String value: `HKMetadataKeyHeartRateRecoveryActivityDuration`
     - HealthKit Constant: ``HKMetadataKeyHeartRateRecoveryActivityDuration``
     */
    public static let heartRateRecoveryActivityDuration = HKMetadataKeyHeartRateRecoveryActivityDuration

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyHeartRateRecoveryActivityType`
     - HealthKit Constant: ``HKMetadataKeyHeartRateRecoveryActivityType``
     */
    public static let heartRateRecoveryActivityType = HKMetadataKeyHeartRateRecoveryActivityType

    /**
     - Value type: ``Quantity``, unit count/min
     - String value: `HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate`
     - HealthKit Constant: ``HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate``
     */
    public static let heartRateRecoveryMaxObservedRecoveryHeartRate = HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate

    /**
     The type of test that the source used to calculate a person’s heart-rate recovery.

     Use this metadata key to identify the type of test that the ``HKSource`` used to calculate the value for a ``heartRateRecoveryOneMinute`` sample.

     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyHeartRateRecoveryTestType`
     - HealthKit Constant: ``HKMetadataKeyHeartRateRecoveryTestType``
     */
    public static let heartRateRecoveryTestType = HKMetadataKeyHeartRateRecoveryTestType

    /**
     The location where a specific heart rate reading was taken.

     This key takes an NSNumber containing an ``HKHeartRateSensorLocation`` as its value.
     - Value type: ``NSNumber``
     - String value: `HKHeartRateSensorLocation`
     - HealthKit Constant: ``HKMetadataKeyHeartRateSensorLocation``
     */
    static let heartRateSensorLocation = HKMetadataKeyHeartRateSensorLocation

    /**
     - Value type: ``NSNumber``
     - String value: `HKIndoorWorkout`
     - HealthKit Constant: ``HKMetadataKeyIndoorWorkout``
     */
    public static let indoorWorkout = HKMetadataKeyIndoorWorkout

    /**
     - Value type: ``HKQuantity``, unit meter
     - String value: `HKLapLength`
     - HealthKit Constant: ``HKMetadataKeyLapLength``
     */
    public static let lapLength = HKMetadataKeyLapLength

    /**
     - Value type: ``Quantity``, unit lx
     - String value: `HKMetadataKeyMaximumLightIntensity`
     - HealthKit Constant: ``HKMetadataKeyMaximumLightIntensity``
     */
    @available(watchOS 10.0, iOS 17.0, macOS 14.0, *)
    public static let maximumLightIntensity = HKMetadataKeyMaximumLightIntensity

    /**
     - Value type: ``NSNumber``
     - String value: `HKPhysicalEffortEstimationType`
     - HealthKit Constant: ``HKMetadataKeyPhysicalEffortEstimationType``
     */
    @available(watchOS 10.0, iOS 17.0, macOS 14.0, *)
    public static let physicalEffortEstimationType = HKMetadataKeyPhysicalEffortEstimationType

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyQuantityClampedToLowerBound`
     - HealthKit Constant: ``HKMetadataKeyQuantityClampedToLowerBound``
     */
    public static let quantityClampedToLowerBound = HKMetadataKeyQuantityClampedToLowerBound

    /**
     - Value type: ``Quantity``, unit count/min
     - String value: `HKMetadataKeySessionEstimate`
     - HealthKit Constant: ``HKMetadataKeySessionEstimate``
     */
    public static let sessionEstimate = HKMetadataKeySessionEstimate

    /**
     - Value type: ``String``
     - String value: `sessionId`
     - HealthKit Constant: -
     */
    public static let sessionId = "sessionId"

    /**
     - Value type: ``NSNumber``
     - String value: `HKSexualActivityProtectionUsed`
     - HealthKit Constant: ``HKMetadataKeySexualActivityProtectionUsed``
     */
    public static let sexualActivityProtectionUsed = HKMetadataKeySexualActivityProtectionUsed

    /**
     - Value type: ``NSNumber``
     - String value: `subIndex`
     - HealthKit Constant: -
     */
    public static let subIndex = "subIndex"

    /**
     - Value type: ``NSNumber``
     - String value: `HKSwimmingLocationType`
     - HealthKit Constant: ``HKMetadataKeySwimmingLocationType``
     */
    public static let swimmingLocationType = HKMetadataKeySwimmingLocationType

    /**
     - Value type: ``NSNumber`` (``HKSwimmingStrokeStyle``)
     - String value: `HKSwimmingStrokeStyle`
     - HealthKit Constant: ``HKMetadataKeySwimmingStrokeStyle``
     */
    public static let swimmingStrokeStyle = HKMetadataKeySwimmingStrokeStyle

    /**
     - Value type: ``String``
     - String value: `HKTimeZone`
     - HealthKit Constant: ``HKMetadataKeyTimeZone``
     */
    public static let timeZone = HKMetadataKeyTimeZone

    /**
     - Value type: ``NSNumber``
     - String value: `HKMetadataKeyUserMotionContext`
     - HealthKit Constant: ``HKMetadataKeyUserMotionContext``
     */
    public static let userMotionContext = HKMetadataKeyUserMotionContext

    /**
     - Value type: ``NSNumber``
     - String value: `HKVO2MaxTestType`
     - HealthKit Constant: ``HKMetadataKeyVO2MaxTestType``
     */
    public static let vO2MaxTestType = HKMetadataKeyVO2MaxTestType

    /**
     A key that indicates whether the sample was entered by the user.

     Set this key’s value to true if the sample was entered by the user; otherwise, set it to false.

     - Value type: ``Bool`` (NSNumber?)
     - String value: `HKWasUserEntered`
     - HealthKit Constant: ``HKMetadataKeyWasUserEntered``
     */
    static let wasUserEntered = HKMetadataKeyWasUserEntered

    /**
     - Value type: ``Quantity``, unit %
     - String value: `HKWeatherHumidity`
     - HealthKit Constant: ``HKMetadataKeyWeatherHumidity``
     */
    public static let weatherHumidity = HKMetadataKeyWeatherHumidity

    /**
     - Value type: ``Quantity``, unit degF
     - String value: `HKWeatherTemperature`
     - HealthKit Constant: ``HKMetadataKeyWeatherTemperature``
     */
    public static let weatherTemperature = HKMetadataKeyWeatherTemperature
}

extension HKMetadataKey {

    /**
     Provide a nicer description of a metadata key.
     */
    public static func describe(key: String) -> String? {
        if #available(watchOS 10.0, iOS 17.0, macOS 14.0, *) {
            switch key {
            case maximumLightIntensity: return "Maximum Light Intensity"
            case activityType: return "Activity Type"
            case physicalEffortEstimationType: return "Physical Effort Estimation Type"
            default:
                break
            }
        }
        switch key {
        case externalUUID: return "External UUID"
        case wasUserEntered: return "Entered by user"
        case heartRateSensorLocation: return "Location of Heart Rate Sensor"
        case sessionId: return "Session ID"
        case timeZone: return "Timezone"
        case subIndex: return "Sub-Index"
        case indoorWorkout: return "Indoor Workout"
        case sexualActivityProtectionUsed: return "Protection Used for Sexual Activity"
        case devicePlacementSide: return "Device Placement Side"
        case algorithmVersion: return "Algorithm Version"
        case barometricPressure: return "Barometric Pressure"
        case appleECGAlgorithmVersion: return "Apple ECG Algorithm Version"
        case averageMETs: return "Average METs"
        case weatherTemperature: return "Weather Temperature"
        case weatherHumidity: return "Weather Humidity"
        case elevationAscended: return "Ascended Elevation"
        case vO2MaxTestType: return "VO2Max Test Type"
        case swimmingLocationType: return "Swimming Location Type"
        case lapLength: return "Lap Length"
        case swimmingStrokeStyle: return "Swimming Stroke Style"
        case audioExposureLevel: return "Audio Exposure Level"
        case dateOfEarliestDataUsedForEstimate: return "Date of Earliest Data Used for Estimate"
        case appleDeviceCalibrated: return "Apple Device Calibrated"
        case heartRateEventThreshold: return "Heart Rate Event Threshold"
        case glassesPrescriptionDescription: return "Glasses Prescription Description"
        case userMotionContext: return "User Motion Context"
        case heartRateRecoveryActivityDuration: return "Heart Rate Recovery Activity Duration"
        case heartRateRecoveryActivityType: return "Heart Rate Recovery Activity Type"
        case heartRateRecoveryTestType: return "Heart Rate Recovery Test Type"
        case heartRateRecoveryMaxObservedRecoveryHeartRate: return "Max Observed Recovery Heart Rate"
        case sessionEstimate: return "Session Estimate"
        case quantityClampedToLowerBound: return "Quantity Clamped To Lower Bound"
        default: return nil
        }
    }
}

extension HKMetadataPrivateKey {

    /**
     Provide a nicer description of a private metadata key.
     */
    public static func describe(key: String) -> String? {
        switch key {
        case mediaSourceBundleIdentifier: return "Media Source Bundle Identifier"
        case sleepAlarmUserWakeTime: return "Sleep Alarm User Wake Time"
        case sleepAlarmUserSetBedtime: return "Sleep Alarm User Set Bedtime"
        case headphoneAudioDataIsTransient: return "Headphone Audio Data is Transient"
        case coreMotionSourceIdentifier: return "Core Motion Source Identifier"
        case heartRateContext: return "Heart Rate Context"
        case appleHeartbeatSeriesAlgorithmVersion: return "Apple Heartbeat Series Algorithm Version"
        case bloodOxygenContext: return "Blood Oxygen Context"
        case heartbeatSequenceContext: return "Heartbeat Sequence Context"
        case regulatedUpdateVersion: return "Regulated Update Version"
        case activitySummaryIndex: return "Activity Summary Index"
        case deepBreathingEndReason: return "Reason for End of Deep Breathing"
        case deepBreathingFinalHeartRate: return "Deep Breathing Final Heart Rate"
        case mindfulnessSessionType: return "Mindfulness Session Type"
        case workoutAverageHeartRate: return "Average Workout Heart Rate"
        case workoutMaxHeartRate: return "Maximum Workout Heart Rate"
        case workoutMinHeartRate: return "Minimum Workout Heart Rate"
        case workoutWasInDaytime: return "Workout Was in Daytime"
        case workoutActivityMoveMode: return "Workout Activity Move Mode"
        case workoutWeatherLocationCoordinatesLatitude: return "Workout Weather Location Latitude"
        case workoutWeatherLocationCoordinatesLongitude: return "Workout Weather Location Longitude"
        case lostGPSAtSomePoint: return "Lost GPS At Some Point"
        case weatherCondition: return "Weather Condition"
        case workoutMinGroundElevation: return "Minimum Ground Elevation for Workout"
        case workoutMaxGroundElevation: return "Maximum Ground Elevation for Workout"
        case workoutAverageCadence: return "Average Workout Cadence"
        case userOnBetaBlocker: return "User is on Beta Blocker"
        case audioExposureLimit: return "Audio Exposure Limit"
        case heartRateEventThreshold: return "Heart Rate Event Threshold"
        case workoutTargetZoneMax: return "Workout Target Zone Maximum"
        case workoutTargetZoneType: return "Workout Target Zone Type"
        case workoutTargetZoneMin: return "Workout Target Zone Minimum"
        case fallActionRequested: return "Requested Fall Action"
        case workoutElapsedTimeInHeartRateZones: return "Workout Elapsed Time in Heart Rate Zones"
        case workoutWeatherSourceName: return "Workout Weather Source Name"
        case workoutHeartRateZones: return "Workout Heart Rate Zones"
        case workoutConfiguration: return "Workout Configuration"
        case workoutHeartRateZonesConfigurationType: return "Workout Heart Rate Zones Configuration Type"
        case workoutHeartRateZonesCurrentZoneIndex: return "Workout Heart Rate Zones Current Zone Index"
        case workoutHeartRateZonesLastProcessedEntryDate: return "Workout Heart Rate Zones Last Processed Entry Date"
        case workoutHeartRateZonesLastProcessedEventDate: return "Workout Heart Rate Zones Last Processed Event Date"
        case workoutCyclingPowerZonesAutomaticFTP: return "Workout Cycling Power Zones Automatic FTP"
        case workoutCyclingPowerZonesConfiguration: return "Workout Cycling Power Zones Configuration"
        case workoutElapsedTimeInCyclingPowerZones: return "Workout Elapsed Time In Cycling Power Zones"
        case workoutAveragePower: return "Average Workout Power"
        case metricPlatterStatistics: return "Metric Platter Statistics"
        case workoutExtendedMode: return "Extended Workout Mode"
        case sessionID: return "Session ID"
        case fastestPace: return "Fastest Pace"
        case mirroredWorkout: return "Mirrored Workout"
        default: return nil
        }
    }
}
