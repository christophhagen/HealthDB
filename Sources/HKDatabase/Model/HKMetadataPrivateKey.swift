import Foundation
import HealthKit

/**
 A collection of private metadata keys used in the SQLite database
 */
public enum HKMetadataPrivateKey: String {

    /// Value type: ``NSNumber``
    case activitySummaryIndex = "_HKPrivateActivitySummaryIndex"

    /// Value type: ``NSNumber``
    case appleHeartbeatSeriesAlgorithmVersion = "_HKPrivateMetadataKeyAppleHeartbeatSeriesAlgorithmVersion"

    /// Value type: ``Quantity``, unit dBASPL
    case audioExposureLimit = "_HKPrivateMetadataKeyAudioExposureLimit"

    /// Value type: ``NSNumber``
    case bloodOxygenContext = "_HKPrivateBloodOxygenContext"

    /// Value type: ``String``
    case coreMotionSourceIdentifier = "_HKPrivateCoreMotionSourceIdentifier"

    /// Value type: ``NSNumber``
    case deepBreathingEndReason = "_HKPrivateDeepBreathingEndReason"

    /// Value type: ``NSNumber``
    case deepBreathingFinalHeartRate = "_HKPrivateDeepBreathingFinalHeartRate"

    /// Value type: ``NSNumber``
    case fallActionRequested = "_HKPrivateFallActionRequested"

    /// Value type: ``NSNumber``
    case fastestPace = "_HKPrivateMetadataKeyFastestPace"

    /// Value type: ``NSNumber``
    case headphoneAudioDataIsTransient = "_HKPrivateMetadataKeyHeadphoneAudioDataIsTransient"

    /// Value type: ``NSNumber``
    case heartbeatSequenceContext = "_HKPrivateHeartbeatSequenceContext"

    /// Value type: ``NSNumber``
    case heartRateContext = "_HKPrivateHeartRateContext"

    /// Value type: ``Quantity``, unit count/min
    case heartRateEventThreshold = "_HKPrivateMetadataKeyHeartRateEventThreshold"

    /// Value type: ``Int`` (``Bool``)
    case isPartialSplit = "_HKPrivateMetadataIsPartialSplit"

    /// Value type: ``NSNumber``
    case lostGPSAtSomePoint = "_HKPrivateMetadataKeyLostGPSAtSomePoint"

    /// Value type: ``String``
    case mediaSourceBundleIdentifier = "_HKPrivateMediaSourceBundleIdentifier"

    /// Value type: ``String``
    case metricPlatterStatistics = "_HKPrivateMetadataKeyMetricPlatterStatistics"

    /// Value type: ``NSNumber``
    case mindfulnessSessionType = "_HKPrivateMetadataMindfulnessSessionType"

    /// Value type: ``NSNumber``
    case mirroredWorkout = "_HKPrivateMetadataKeyMirroredWorkout"

    /// Value type: ``NSNumber``
    case regulatedUpdateVersion = "_HKPrivateMetadataKeyRegulatedUpdateVersion"

    /// Value type: ``String``
    case sessionID = "_HKPrivateMetadataKeySessionID"

    /// Value type: ``Date``
    case sleepAlarmUserSetBedtime = "_HKPrivateSleepAlarmUserSetBedtime"

    /// Value type: ``Date``
    case sleepAlarmUserWakeTime = "_HKPrivateSleepAlarmUserWakeTime"

    /// Value type ``HKQuantity``, unit `s`
    case splitActiveDurationQuantity = "_HKPrivateMetadataSplitActiveDurationQuantity"

    /// Value type ``HKQuantity``, unit `m`
    case splitDistanceQuantity = "_HKPrivateMetadataSplitDistanceQuantity"

    /// Value type ``Int``
    case splitMeasuringSystem = "_HKPrivateMetadataSplitMeasuringSystem"

    /// Value type ``HKQuantity``, unit `m`
    case totalDistanceQuantity = "_HKPrivateMetadataTotalDistanceQuantity"

    /// Value type: ``NSNumber``
    case userOnBetaBlocker = "_HKPrivateMetadataKeyUserOnBetaBlocker"

    /// Value type: ``NSNumber``
    case weatherCondition = "_HKPrivateWeatherCondition"

    /// Value type: ``NSNumber``
    case workoutActivityMoveMode = "_HKPrivateWorkoutActivityMoveMode"

    /// Value type: ``Quantity``, unit count/min
    case workoutAverageCadence = "_HKPrivateWorkoutAverageCadence"

    /// Value type: ``Quantity``, unit count/s
    case workoutAverageHeartRate = "_HKPrivateWorkoutAverageHeartRate"

    /// Value type: ``Quantity``, unit W
    case workoutAveragePower = "_HKPrivateWorkoutAveragePower"

    /// Value type: ``Data``
    case workoutConfiguration = "_HKPrivateWorkoutConfiguration"

    /// Value type: ``Data``
    case workoutCyclingPowerZonesAutomaticFTP = "_HKPrivateWorkoutCyclingPowerZonesAutomaticFTP"

    /// Value type: ``Data``
    case workoutCyclingPowerZonesConfiguration = "_HKPrivateWorkoutCyclingPowerZonesConfiguration"

    /// Value type: ``Data``
    case workoutElapsedTimeInCyclingPowerZones = "_HKPrivateWorkoutElapsedTimeInCyclingPowerZones"

    /// Value type: ``Date``
    case workoutElapsedTimeInHeartRateZones = "_HKPrivateWorkoutElapsedTimeInHeartRateZones"

    /// Value type: ``NSNumber``
    case workoutExtendedMode = "_HKPrivateWorkoutExtendedMode"

    /// Value type: ``Data``
    case workoutHeartRateZones = "_HKPrivateWorkoutHeartRateZones"

    /// Value type: ``NSNumber``
    case workoutHeartRateZonesConfigurationType = "_HKPrivateWorkoutHeartRateZonesConfigurationType"

    /// Value type: ``Data``
    case workoutHeartRateZonesCurrentZoneIndex = "_HKPrivateWorkoutHeartRateZonesCurrentZoneIndex"

    /// Value type: ``Data``
    case workoutHeartRateZonesLastProcessedEntryDate = "_HKPrivateWorkoutHeartRateZonesLastProcessedEntryDate"

    /// Value type: ``Data``
    case workoutHeartRateZonesLastProcessedEventDate = "_HKPrivateWorkoutHeartRateZonesLastProcessedEventDate"

    /// Value type: ``Quantity``, unit m
    case workoutMaxGroundElevation = "_HKPrivateWorkoutMaxGroundElevation"

    /// Value type: ``Quantity``, unit count/s
    case workoutMaxHeartRate = "_HKPrivateWorkoutMaxHeartRate"

    /// Value type: ``Quantity``, unit m
    case workoutMinGroundElevation = "_HKPrivateWorkoutMinGroundElevation"

    /// Value type: ``Quantity``, unit count/s
    case workoutMinHeartRate = "_HKPrivateWorkoutMinHeartRate"

    /// value type: ``Int``
    case workoutSegmentEventSubtype = "_HKPrivateWorkoutSegmentEventSubtype"

    /// Value type: `` ``
    case workoutTargetZoneMax = "_HKPrivateWorkoutTargetZoneMax"

    /// Value type: `` ``
    case workoutTargetZoneMin = "_HKPrivateWorkoutTargetZoneMin"

    /// Value type: `` ``
    case workoutTargetZoneType = "_HKPrivateWorkoutTargetZoneType"

    /// Value type: ``NSNumber``
    case workoutWasInDaytime = "_HKPrivateWorkoutWasInDaytime"

    /// Value type: ``NSNumber``
    case workoutWeatherLocationCoordinatesLatitude = "_HKPrivateWorkoutWeatherLocationCoordinatesLatitude"

    /// Value type: ``NSNumber``
    case workoutWeatherLocationCoordinatesLongitude = "_HKPrivateWorkoutWeatherLocationCoordinatesLongitude"

    /// Value type: ``String``
    case workoutWeatherSourceName = "_HKPrivateWorkoutWeatherSourceName"
}

extension HKMetadataPrivateKey: CustomStringConvertible {

    /**
     Provide a nicer description of a private metadata key.
     */
    public var description: String {
        switch self {
        case .activitySummaryIndex: return "Activity Summary Index"
        case .appleHeartbeatSeriesAlgorithmVersion: return "Apple Heartbeat Series Algorithm Version"
        case .audioExposureLimit: return "Audio Exposure Limit"
        case .bloodOxygenContext: return "Blood Oxygen Context"
        case .coreMotionSourceIdentifier: return "Core Motion Source Identifier"
        case .deepBreathingEndReason: return "Reason for End of Deep Breathing"
        case .deepBreathingFinalHeartRate: return "Deep Breathing Final Heart Rate"
        case .fallActionRequested: return "Requested Fall Action"
        case .fastestPace: return "Fastest Pace"
        case .headphoneAudioDataIsTransient: return "Headphone Audio Data is Transient"
        case .heartbeatSequenceContext: return "Heartbeat Sequence Context"
        case .heartRateContext: return "Heart Rate Context"
        case .heartRateEventThreshold: return "Heart Rate Event Threshold"
        case .isPartialSplit: return "Is Partial Split"
        case .lostGPSAtSomePoint: return "Lost GPS At Some Point"
        case .mediaSourceBundleIdentifier: return "Media Source Bundle Identifier"
        case .metricPlatterStatistics: return "Metric Platter Statistics"
        case .mindfulnessSessionType: return "Mindfulness Session Type"
        case .mirroredWorkout: return "Mirrored Workout"
        case .regulatedUpdateVersion: return "Regulated Update Version"
        case .sessionID: return "Session ID"
        case .sleepAlarmUserSetBedtime: return "Sleep Alarm User Set Bedtime"
        case .sleepAlarmUserWakeTime: return "Sleep Alarm User Wake Time"
        case .splitActiveDurationQuantity: return "Split Active Duration Quantity"
        case .splitDistanceQuantity: return "Split Distance Quantity"
        case .splitMeasuringSystem: return "Split Measuring System"
        case .totalDistanceQuantity: return "Total Distance"
        case .userOnBetaBlocker: return "User is on Beta Blocker"
        case .weatherCondition: return "Weather Condition"
        case .workoutActivityMoveMode: return "Workout Activity Move Mode"
        case .workoutAverageCadence: return "Average Workout Cadence"
        case .workoutAverageHeartRate: return "Average Workout Heart Rate"
        case .workoutAveragePower: return "Average Workout Power"
        case .workoutConfiguration: return "Workout Configuration"
        case .workoutCyclingPowerZonesAutomaticFTP: return "Workout Cycling Power Zones Automatic FTP"
        case .workoutCyclingPowerZonesConfiguration: return "Workout Cycling Power Zones Configuration"
        case .workoutElapsedTimeInCyclingPowerZones: return "Workout Elapsed Time In Cycling Power Zones"
        case .workoutElapsedTimeInHeartRateZones: return "Workout Elapsed Time in Heart Rate Zones"
        case .workoutExtendedMode: return "Extended Workout Mode"
        case .workoutHeartRateZones: return "Workout Heart Rate Zones"
        case .workoutHeartRateZonesConfigurationType: return "Workout Heart Rate Zones Configuration Type"
        case .workoutHeartRateZonesCurrentZoneIndex: return "Workout Heart Rate Zones Current Zone Index"
        case .workoutHeartRateZonesLastProcessedEntryDate: return "Workout Heart Rate Zones Last Processed Entry Date"
        case .workoutHeartRateZonesLastProcessedEventDate: return "Workout Heart Rate Zones Last Processed Event Date"
        case .workoutMaxGroundElevation: return "Maximum Ground Elevation for Workout"
        case .workoutMaxHeartRate: return "Maximum Workout Heart Rate"
        case .workoutMinGroundElevation: return "Minimum Ground Elevation for Workout"
        case .workoutMinHeartRate: return "Minimum Workout Heart Rate"
        case .workoutSegmentEventSubtype: return "Workout Segment Event Subtype"
        case .workoutTargetZoneMax: return "Workout Target Zone Maximum"
        case .workoutTargetZoneMin: return "Workout Target Zone Minimum"
        case .workoutTargetZoneType: return "Workout Target Zone Type"
        case .workoutWasInDaytime: return "Workout Was in Daytime"
        case .workoutWeatherLocationCoordinatesLatitude: return "Workout Weather Location Latitude"
        case .workoutWeatherLocationCoordinatesLongitude: return "Workout Weather Location Longitude"
        case .workoutWeatherSourceName: return "Workout Weather Source Name"
        }
    }
}
