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
