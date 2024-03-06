import Foundation

enum Metadata {

}

extension Metadata {

    /**
     A metadata key used to add metadata to samples.

     These keys only contain a subset of all possible keys, there may be many other unknown keys.
     */
    enum Key {

        /// Value type ``NSNumber``
        case wasUserEntered
        
        /// Value type ``NSNumber``
        case heartRateSensorLocation

        /// Value type: ``String``
        case sessionId

        /// Value type: ``String``
        case timeZone

        /// Value type ``NSNumber``
        case subIndex

        /// Value type ``NSNumber``
        case indoorWorkout

        /// Value type: ``String``
        case privateMediaSourceBundleIdentifier

        /// Value type ``NSNumber``
        case sexualActivityProtectionUsed

        /// Value type: ``Date``
        case privateSleepAlarmUserWakeTime

        /// Value type: ``Date``
        case privateSleepAlarmUserSetBedtime

        /// Value type ``NSNumber``
        case devicePlacementSide

        /// Value type ``NSNumber``
        case privateHeadphoneAudioDataIsTransient

        /// Value type: ``String``
        case privateCoreMotionSourceIdentifier

        /// Value type ``NSNumber``
        case privateHeartRateContext

        /// Value type ``NSNumber``
        case algorithmVersion

        /// Value type ``NSNumber``
        case privateAppleHeartbeatSeriesAlgorithmVersion

        /// Value type: ``Quantity``, unit kPa
        case barometricPressure

        /// Value type ``NSNumber``
        case privateBloodOxygenContext

        /// Value type ``NSNumber``
        case privateHeartbeatSequenceContext

        /// Value type ``NSNumber``
        case appleECGAlgorithmVersion

        /// Value type: ``String``
        case privateRegulatedUpdateVersion

        /// Value type ``NSNumber``
        case privateActivitySummaryIndex
        
        /// Value type ``NSNumber``
        case privateDeepBreathingEndReason

        /// Value type ``NSNumber``
        case privateDeepBreathingFinalHeartRate

        /// Value type ``NSNumber``
        case privateMindfulnessSessionType

        /// Value type: ``Quantity``, unit count/s
        case privateWorkoutAverageHeartRate

        /// Value type: ``Quantity``, unit count/s
        case privateWorkoutMaxHeartRate

        /// Value type ``NSNumber``
        case privateWeatherCondition

        /// Value type ``NSNumber``
        case privateWorkoutWeatherLocationCoordinatesLongitude

        /// Value type: ``Quantity``, unit count/s
        case privateWorkoutMinHeartRate

        /// Value type ``NSNumber``
        case privateWorkoutWasInDaytime

        /// Value type ``NSNumber``
        case privateWorkoutActivityMoveMode

        /// Value type: ``Quantity``, unit kcal/hr·kg
        case averageMETs

        /// Value type ``NSNumber``
        case privateWorkoutWeatherLocationCoordinatesLatitude

        /// Value type ``NSNumber``
        case privateLostGPSAtSomePoint

        /// Value type: ``Quantity``, unit degF
        case weatherTemperature

        /// Value type: ``Quantity``, unit m
        case privateWorkoutMinGroundElevation

        /// Value type: ``Quantity``, unit %
        case weatherHumidity

        /// Value type: ``Quantity``, unit m
        case privateWorkoutMaxGroundElevation

        /// Value type: ``Quantity``, unit cm
        case elevationAscended

        /// Value type: ``Quantity``, unit count/min
        case privateWorkoutAverageCadence

        /// Value type ``NSNumber``
        case vO2MaxTestType

        /// Value type ``NSNumber``
        case privateUserOnBetaBlocker

        /// Value type ``NSNumber``
        case swimmingLocationType
        
        case lapLength

        /// Value type ``NSNumber``
        case swimmingStrokeStyle

        /// Value type: ``Quantity``, unit dBASPL
        case audioExposureLevel
        
        /// Value type: ``Quantity``, unit dBASPL
        case privateAudioExposureLimit

        /**
         HKMetadataKeyDateOfEarliestDataUsedForEstimate

         This key takes a ``Date`` value, indicating the earliest date from the data used by HealthKit to calculate the sample’s value.
         */
        case dateOfEarliestDataUsedForEstimate

        /// Value type ``NSNumber``
        case appleDeviceCalibrated

        /// Value type: ``Quantity``, unit count/min
        case heartRateEventThreshold
        
        /// Value type: ``Quantity``, unit count/min
        case privateHeartRateEventThreshold
        
        case privateWorkoutTargetZoneMax
        
        case privateWorkoutTargetZoneType
        
        case privateWorkoutTargetZoneMin

        /// Value type ``NSNumber``
        case privateFallActionRequested
        
        case glassesPrescriptionDescription

        /// Value type: ``Date``
        case privateWorkoutElapsedTimeInHeartRateZones

        /// Value type: ``String``
        case privateWorkoutWeatherSourceName

        /// Value type: ``Data``
        case privateWorkoutHeartRateZones

        /// Value type: ``Data``
        case privateWorkoutConfiguration

        /// Value type ``NSNumber``
        case privateWorkoutHeartRateZonesConfigurationType

        /// Value type: ``Data``
        case privateWorkoutHeartRateZonesCurrentZoneIndex

        /// Value type: ``Data``
        case privateWorkoutHeartRateZonesLastProcessedEntryDate

        /// Value type: ``Data``
        case privateWorkoutHeartRateZonesLastProcessedEventDate

        /// Value type: ``Data``
        case privateWorkoutCyclingPowerZonesAutomaticFTP

        /// Value type: ``Data``
        case privateWorkoutCyclingPowerZonesConfiguration

        /// Value type: ``Data``
        case privateWorkoutElapsedTimeInCyclingPowerZones
        
        /// Value type: ``Quantity``, unit W
        case privateWorkoutAveragePower

        /// Value type: ``String``
        case privateMetricPlatterStatistics

        /// Value type ``NSNumber``
        case userMotionContext

        /// Value type: ``Quantity``, unit s
        case heartRateRecoveryActivityDuration

        /// Value type ``NSNumber``
        case heartRateRecoveryTestType

        /// Value type: ``Quantity``, unit count/min
        case heartRateRecoveryMaxObservedRecoveryHeartRate

        /// Value type ``NSNumber``
        case heartRateRecoveryActivityType

        /// Value type: ``Quantity``, unit count/min
        case sessionEstimate

        /// Value type ``NSNumber``
        case privateWorkoutExtendedMode

        /// Value type: ``String``
        case privateSessionID

        /// Value type: ``Quantity``, unit lx
        case maximumLightIntensity

        /// Value type ``NSNumber``
        case activityType

        /// Value type ``NSNumber``
        case physicalEffortEstimationType

        /// Value type ``NSNumber``
        case privateFastestPace

        /// Value type ``NSNumber``
        case privateMirroredWorkout

        /// Value type ``NSNumber``
        case quantityClampedToLowerBound

        case unknown(String)
    }
}

extension Metadata.Key: RawRepresentable {

    init(rawValue: String) {
        switch rawValue {
        case "HKWasUserEntered": self = .wasUserEntered
        case "HKHeartRateSensorLocation": self = .heartRateSensorLocation
        case "sessionId": self = .sessionId
        case "HKTimeZone": self = .timeZone
        case "subIndex": self = .subIndex
        case "HKIndoorWorkout": self = .indoorWorkout
        case "_HKPrivateMediaSourceBundleIdentifier": self = .privateMediaSourceBundleIdentifier
        case "HKSexualActivityProtectionUsed": self = .sexualActivityProtectionUsed
        case "_HKPrivateSleepAlarmUserWakeTime": self = .privateSleepAlarmUserWakeTime
        case "_HKPrivateSleepAlarmUserSetBedtime": self = .privateSleepAlarmUserSetBedtime
        case "HKMetadataKeyDevicePlacementSide": self = .devicePlacementSide
        case "_HKPrivateMetadataKeyHeadphoneAudioDataIsTransient": self = .privateHeadphoneAudioDataIsTransient
        case "_HKPrivateCoreMotionSourceIdentifier": self = .privateCoreMotionSourceIdentifier
        case "_HKPrivateHeartRateContext": self = .privateHeartRateContext
        case "HKAlgorithmVersion": self = .algorithmVersion
        case "_HKPrivateMetadataKeyAppleHeartbeatSeriesAlgorithmVersion": self = .privateAppleHeartbeatSeriesAlgorithmVersion
        case "HKMetadataKeyBarometricPressure": self = .barometricPressure
        case "_HKPrivateBloodOxygenContext": self = .privateBloodOxygenContext
        case "_HKPrivateHeartbeatSequenceContext": self = .privateHeartbeatSequenceContext
        case "HKMetadataKeyAppleECGAlgorithmVersion": self = .appleECGAlgorithmVersion
        case "_HKPrivateMetadataKeyRegulatedUpdateVersion": self = .privateRegulatedUpdateVersion
        case "_HKPrivateActivitySummaryIndex": self = .privateActivitySummaryIndex
        case "_HKPrivateDeepBreathingEndReason": self = .privateDeepBreathingEndReason
        case "_HKPrivateDeepBreathingFinalHeartRate": self = .privateDeepBreathingFinalHeartRate
        case "_HKPrivateMetadataMindfulnessSessionType": self = .privateMindfulnessSessionType
        case "_HKPrivateWorkoutAverageHeartRate": self = .privateWorkoutAverageHeartRate
        case "_HKPrivateWorkoutMaxHeartRate": self = .privateWorkoutMaxHeartRate
        case "_HKPrivateWeatherCondition": self = .privateWeatherCondition
        case "_HKPrivateWorkoutWeatherLocationCoordinatesLongitude": self = .privateWorkoutWeatherLocationCoordinatesLongitude
        case "_HKPrivateWorkoutMinHeartRate": self = .privateWorkoutMinHeartRate
        case "_HKPrivateWorkoutWasInDaytime": self = .privateWorkoutWasInDaytime
        case "_HKPrivateWorkoutActivityMoveMode": self = .privateWorkoutActivityMoveMode
        case "HKAverageMETs": self = .averageMETs
        case "_HKPrivateWorkoutWeatherLocationCoordinatesLatitude": self = .privateWorkoutWeatherLocationCoordinatesLatitude
        case "_HKPrivateMetadataKeyLostGPSAtSomePoint": self = .privateLostGPSAtSomePoint
        case "HKWeatherTemperature": self = .weatherTemperature
        case "_HKPrivateWorkoutMinGroundElevation": self = .privateWorkoutMinGroundElevation
        case "HKWeatherHumidity": self = .weatherHumidity
        case "_HKPrivateWorkoutMaxGroundElevation": self = .privateWorkoutMaxGroundElevation
        case "HKElevationAscended": self = .elevationAscended
        case "_HKPrivateWorkoutAverageCadence": self = .privateWorkoutAverageCadence
        case "HKVO2MaxTestType": self = .vO2MaxTestType
        case "_HKPrivateMetadataKeyUserOnBetaBlocker": self = .privateUserOnBetaBlocker
        case "HKSwimmingLocationType": self = .swimmingLocationType
        case "HKLapLength": self = .lapLength
        case "HKSwimmingStrokeStyle": self = .swimmingStrokeStyle
        case "HKMetadataKeyAudioExposureLevel": self = .audioExposureLevel
        case "_HKPrivateMetadataKeyAudioExposureLimit": self = .privateAudioExposureLimit
        case "HKDateOfEarliestDataUsedForEstimate": self = .dateOfEarliestDataUsedForEstimate
        case "HKMetadataKeyAppleDeviceCalibrated": self = .appleDeviceCalibrated
        case "HKHeartRateEventThreshold": self = .heartRateEventThreshold
        case "_HKPrivateMetadataKeyHeartRateEventThreshold": self = .privateHeartRateEventThreshold
        case "_HKPrivateWorkoutTargetZoneMax": self = .privateWorkoutTargetZoneMax
        case "_HKPrivateWorkoutTargetZoneType": self = .privateWorkoutTargetZoneType
        case "_HKPrivateWorkoutTargetZoneMin": self = .privateWorkoutTargetZoneMin
        case "_HKPrivateFallActionRequested": self = .privateFallActionRequested
        case "HKMetadataKeyGlassesPrescriptionDescription": self = .glassesPrescriptionDescription
        case "_HKPrivateWorkoutElapsedTimeInHeartRateZones": self = .privateWorkoutElapsedTimeInHeartRateZones
        case "_HKPrivateWorkoutWeatherSourceName": self = .privateWorkoutWeatherSourceName
        case "_HKPrivateWorkoutHeartRateZones": self = .privateWorkoutHeartRateZones
        case "_HKPrivateWorkoutConfiguration": self = .privateWorkoutConfiguration
        case "_HKPrivateWorkoutHeartRateZonesConfigurationType": self = .privateWorkoutHeartRateZonesConfigurationType
        case "_HKPrivateWorkoutHeartRateZonesCurrentZoneIndex": self = .privateWorkoutHeartRateZonesCurrentZoneIndex
        case "_HKPrivateWorkoutHeartRateZonesLastProcessedEntryDate": self = .privateWorkoutHeartRateZonesLastProcessedEntryDate
        case "_HKPrivateWorkoutHeartRateZonesLastProcessedEventDate": self = .privateWorkoutHeartRateZonesLastProcessedEventDate
        case "_HKPrivateWorkoutCyclingPowerZonesAutomaticFTP": self = .privateWorkoutCyclingPowerZonesAutomaticFTP
        case "_HKPrivateWorkoutCyclingPowerZonesConfiguration": self = .privateWorkoutCyclingPowerZonesConfiguration
        case "_HKPrivateWorkoutElapsedTimeInCyclingPowerZones": self = .privateWorkoutElapsedTimeInCyclingPowerZones
        case "_HKPrivateWorkoutAveragePower": self = .privateWorkoutAveragePower
        case "_HKPrivateMetadataKeyMetricPlatterStatistics": self = .privateMetricPlatterStatistics
        case "HKMetadataKeyUserMotionContext": self = .userMotionContext
        case "HKMetadataKeyHeartRateRecoveryActivityDuration": self = .heartRateRecoveryActivityDuration
        case "HKMetadataKeyHeartRateRecoveryTestType": self = .heartRateRecoveryTestType
        case "HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate": self = .heartRateRecoveryMaxObservedRecoveryHeartRate
        case "HKMetadataKeyHeartRateRecoveryActivityType": self = .heartRateRecoveryActivityType
        case "HKMetadataKeySessionEstimate": self = .sessionEstimate
        case "_HKPrivateWorkoutExtendedMode": self = .privateWorkoutExtendedMode
        case "_HKPrivateMetadataKeySessionID": self = .privateSessionID
        case "HKMetadataKeyMaximumLightIntensity": self = .maximumLightIntensity
        case "HKActivityType": self = .activityType
        case "HKPhysicalEffortEstimationType": self = .physicalEffortEstimationType
        case "_HKPrivateMetadataKeyFastestPace": self = .privateFastestPace
        case "_HKPrivateMetadataKeyMirroredWorkout": self = .privateMirroredWorkout
        case "HKMetadataKeyQuantityClampedToLowerBound": self = .quantityClampedToLowerBound
        default:
            self = .unknown(rawValue)
        }
    }

    var rawValue: String {
        switch self {
        case .wasUserEntered: return "HKWasUserEntered"
        case .heartRateSensorLocation: return "HKHeartRateSensorLocation"
        case .sessionId: return "sessionId"
        case .timeZone: return "HKTimeZone"
        case .subIndex: return "subIndex"
        case .indoorWorkout: return "HKIndoorWorkout"
        case .privateMediaSourceBundleIdentifier: return "_HKPrivateMediaSourceBundleIdentifier"
        case .sexualActivityProtectionUsed: return "HKSexualActivityProtectionUsed"
        case .privateSleepAlarmUserWakeTime: return "_HKPrivateSleepAlarmUserWakeTime"
        case .privateSleepAlarmUserSetBedtime: return "_HKPrivateSleepAlarmUserSetBedtime"
        case .devicePlacementSide: return "HKMetadataKeyDevicePlacementSide"
        case .privateHeadphoneAudioDataIsTransient: return "_HKPrivateMetadataKeyHeadphoneAudioDataIsTransient"
        case .privateCoreMotionSourceIdentifier: return "_HKPrivateCoreMotionSourceIdentifier"
        case .privateHeartRateContext: return "_HKPrivateHeartRateContext"
        case .algorithmVersion: return "HKAlgorithmVersion"
        case .privateAppleHeartbeatSeriesAlgorithmVersion: return "_HKPrivateMetadataKeyAppleHeartbeatSeriesAlgorithmVersion"
        case .barometricPressure: return "HKMetadataKeyBarometricPressure"
        case .privateBloodOxygenContext: return "_HKPrivateBloodOxygenContext"
        case .privateHeartbeatSequenceContext: return "_HKPrivateHeartbeatSequenceContext"
        case .appleECGAlgorithmVersion: return "HKMetadataKeyAppleECGAlgorithmVersion"
        case .privateRegulatedUpdateVersion: return "_HKPrivateMetadataKeyRegulatedUpdateVersion"
        case .privateActivitySummaryIndex: return "_HKPrivateActivitySummaryIndex"
        case .privateDeepBreathingEndReason: return "_HKPrivateDeepBreathingEndReason"
        case .privateDeepBreathingFinalHeartRate: return "_HKPrivateDeepBreathingFinalHeartRate"
        case .privateMindfulnessSessionType: return "_HKPrivateMetadataMindfulnessSessionType"
        case .privateWorkoutAverageHeartRate: return "_HKPrivateWorkoutAverageHeartRate"
        case .privateWorkoutMaxHeartRate: return "_HKPrivateWorkoutMaxHeartRate"
        case .privateWeatherCondition: return "_HKPrivateWeatherCondition"
        case .privateWorkoutWeatherLocationCoordinatesLongitude: return "_HKPrivateWorkoutWeatherLocationCoordinatesLongitude"
        case .privateWorkoutMinHeartRate: return "_HKPrivateWorkoutMinHeartRate"
        case .privateWorkoutWasInDaytime: return "_HKPrivateWorkoutWasInDaytime"
        case .privateWorkoutActivityMoveMode: return "_HKPrivateWorkoutActivityMoveMode"
        case .averageMETs: return "HKAverageMETs"
        case .privateWorkoutWeatherLocationCoordinatesLatitude: return "_HKPrivateWorkoutWeatherLocationCoordinatesLatitude"
        case .privateLostGPSAtSomePoint: return "_HKPrivateMetadataKeyLostGPSAtSomePoint"
        case .weatherTemperature: return "HKWeatherTemperature"
        case .privateWorkoutMinGroundElevation: return "_HKPrivateWorkoutMinGroundElevation"
        case .weatherHumidity: return "HKWeatherHumidity"
        case .privateWorkoutMaxGroundElevation: return "_HKPrivateWorkoutMaxGroundElevation"
        case .elevationAscended: return "HKElevationAscended"
        case .privateWorkoutAverageCadence: return "_HKPrivateWorkoutAverageCadence"
        case .vO2MaxTestType: return "HKVO2MaxTestType"
        case .privateUserOnBetaBlocker: return "_HKPrivateMetadataKeyUserOnBetaBlocker"
        case .swimmingLocationType: return "HKSwimmingLocationType"
        case .lapLength: return "HKLapLength"
        case .swimmingStrokeStyle: return "HKSwimmingStrokeStyle"
        case .audioExposureLevel: return "HKMetadataKeyAudioExposureLevel"
        case .privateAudioExposureLimit: return "_HKPrivateMetadataKeyAudioExposureLimit"
        case .dateOfEarliestDataUsedForEstimate: return "HKDateOfEarliestDataUsedForEstimate"
        case .appleDeviceCalibrated: return "HKMetadataKeyAppleDeviceCalibrated"
        case .heartRateEventThreshold: return "HKHeartRateEventThreshold"
        case .privateHeartRateEventThreshold: return "_HKPrivateMetadataKeyHeartRateEventThreshold"
        case .privateWorkoutTargetZoneMax: return "_HKPrivateWorkoutTargetZoneMax"
        case .privateWorkoutTargetZoneType: return "_HKPrivateWorkoutTargetZoneType"
        case .privateWorkoutTargetZoneMin: return "_HKPrivateWorkoutTargetZoneMin"
        case .privateFallActionRequested: return "_HKPrivateFallActionRequested"
        case .glassesPrescriptionDescription: return "HKMetadataKeyGlassesPrescriptionDescription"
        case .privateWorkoutElapsedTimeInHeartRateZones: return "_HKPrivateWorkoutElapsedTimeInHeartRateZones"
        case .privateWorkoutWeatherSourceName: return "_HKPrivateWorkoutWeatherSourceName"
        case .privateWorkoutHeartRateZones: return "_HKPrivateWorkoutHeartRateZones"
        case .privateWorkoutConfiguration: return "_HKPrivateWorkoutConfiguration"
        case .privateWorkoutHeartRateZonesConfigurationType: return "_HKPrivateWorkoutHeartRateZonesConfigurationType"
        case .privateWorkoutHeartRateZonesCurrentZoneIndex: return "_HKPrivateWorkoutHeartRateZonesCurrentZoneIndex"
        case .privateWorkoutHeartRateZonesLastProcessedEntryDate: return "_HKPrivateWorkoutHeartRateZonesLastProcessedEntryDate"
        case .privateWorkoutHeartRateZonesLastProcessedEventDate: return "_HKPrivateWorkoutHeartRateZonesLastProcessedEventDate"
        case .privateWorkoutCyclingPowerZonesAutomaticFTP: return "_HKPrivateWorkoutCyclingPowerZonesAutomaticFTP"
        case .privateWorkoutCyclingPowerZonesConfiguration: return "_HKPrivateWorkoutCyclingPowerZonesConfiguration"
        case .privateWorkoutElapsedTimeInCyclingPowerZones: return "_HKPrivateWorkoutElapsedTimeInCyclingPowerZones"
        case .privateWorkoutAveragePower: return "_HKPrivateWorkoutAveragePower"
        case .privateMetricPlatterStatistics: return "_HKPrivateMetadataKeyMetricPlatterStatistics"
        case .userMotionContext: return "HKMetadataKeyUserMotionContext"
        case .heartRateRecoveryActivityDuration: return "HKMetadataKeyHeartRateRecoveryActivityDuration"
        case .heartRateRecoveryTestType: return "HKMetadataKeyHeartRateRecoveryTestType"
        case .heartRateRecoveryMaxObservedRecoveryHeartRate: return "HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate"
        case .heartRateRecoveryActivityType: return "HKMetadataKeyHeartRateRecoveryActivityType"
        case .sessionEstimate: return "HKMetadataKeySessionEstimate"
        case .privateWorkoutExtendedMode: return "_HKPrivateWorkoutExtendedMode"
        case .privateSessionID: return "_HKPrivateMetadataKeySessionID"
        case .maximumLightIntensity: return "HKMetadataKeyMaximumLightIntensity"
        case .activityType: return "HKActivityType"
        case .physicalEffortEstimationType: return "HKPhysicalEffortEstimationType"
        case .privateFastestPace: return "_HKPrivateMetadataKeyFastestPace"
        case .privateMirroredWorkout: return "_HKPrivateMetadataKeyMirroredWorkout"
        case .quantityClampedToLowerBound: return "HKMetadataKeyQuantityClampedToLowerBound"
        case .unknown(let rawValue):
            return rawValue
        }
    }
}

extension Metadata.Key: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Metadata.Key: CustomStringConvertible {

    var description: String {
        switch self {
        case .wasUserEntered: return "Entered by user"
        case .heartRateSensorLocation: return "Location of Heart Rate Sensor"
        case .sessionId: return "Session ID"
        case .timeZone: return "Timezone"
        case .subIndex: return "Sub-Index"
        case .indoorWorkout: return "Indoor Workout"
        case .sexualActivityProtectionUsed: return "Protection Used for Sexual Activity"
        case .privateMediaSourceBundleIdentifier: return "Media Source Bundle Identifier (private)"
        case .privateSleepAlarmUserWakeTime: return "Sleep Alarm User Wake Time (private)"
        case .privateSleepAlarmUserSetBedtime: return "Sleep Alarm User Set Bedtime (private)"
        case .devicePlacementSide: return "Device Placement Side"
        case .privateHeadphoneAudioDataIsTransient: return "Headphone Audio Data is Transient (private)"
        case .privateCoreMotionSourceIdentifier: return "Core Motion Source Identifier (private)"
        case .privateHeartRateContext: return "Heart Rate Context (private)"
        case .algorithmVersion: return "Algorithm Version"
        case .privateAppleHeartbeatSeriesAlgorithmVersion: return "Apple Heartbeat Series Algorithm Version (private)"
        case .barometricPressure: return "Barometric Pressure"
        case .privateBloodOxygenContext: return "Blood Oxygen Context (private)"
        case .privateHeartbeatSequenceContext: return "Heartbeat Sequence Context (private)"
        case .appleECGAlgorithmVersion: return "Apple ECG Algorithm Version"
        case .privateRegulatedUpdateVersion: return "Regulated Update Version (private)"
        case .privateActivitySummaryIndex: return "Activity Summary Index (private)"
        case .privateDeepBreathingEndReason: return "Reason for End of Deep Breathing (private)"
        case .privateDeepBreathingFinalHeartRate: return "Deep Breathing Final Heart Rate (private)"
        case .privateMindfulnessSessionType: return "Mindfulness Session Type (private)"
        case .privateWorkoutAverageHeartRate: return "Average Workout Heart Rate (private)"
        case .privateWorkoutMaxHeartRate: return "Maximum Workout Heart Rate (private)"
        case .privateWorkoutMinHeartRate: return "Minimum Workout Heart Rate (private)"
        case .privateWorkoutWasInDaytime: return "Workout Was in Daytime (private)"
        case .privateWorkoutActivityMoveMode: return "Workout Activity Move Mode (private)"
        case .averageMETs: return "Average METs"
        case .privateWorkoutWeatherLocationCoordinatesLatitude: return "Workout Weather Location Latitude (private)"
        case .privateWorkoutWeatherLocationCoordinatesLongitude: return "Workout Weather Location Longitude (private)"
        case .privateLostGPSAtSomePoint: return "Lost GPS At Some Point (private)"
        case .privateWeatherCondition: return "Weather Condition (private)"
        case .weatherTemperature: return "Weather Temperature"
        case .weatherHumidity: return "Weather Humidity"
        case .privateWorkoutMinGroundElevation: return "Minimum Ground Elevation for Workout (private)"
        case .privateWorkoutMaxGroundElevation: return "Maximum Ground Elevation for Workout (private)"
        case .elevationAscended: return "Ascended Elevation"
        case .privateWorkoutAverageCadence: return "Average Workout Cadence (private)"
        case .vO2MaxTestType: return "VO2Max Test Type"
        case .privateUserOnBetaBlocker: return "User is on Beta Blocker (private)"
        case .swimmingLocationType: return "Swimming Location Type"
        case .lapLength: return "Lap Length"
        case .swimmingStrokeStyle: return "Swimming Stroke Style"
        case .audioExposureLevel: return "Audio Exposure Level"
        case .privateAudioExposureLimit: return "Audio Exposure Limit (private)"
        case .dateOfEarliestDataUsedForEstimate: return "Date of Earliest Data Used for Estimate"
        case .appleDeviceCalibrated: return "Apple Device Calibrated"
        case .heartRateEventThreshold: return "Heart Rate Event Threshold"
        case .privateHeartRateEventThreshold: return "Heart Rate Event Threshold (private)"
        case .privateWorkoutTargetZoneMax: return "Workout Target Zone Maximum (private)"
        case .privateWorkoutTargetZoneType: return "Workout Target Zone Type (private)"
        case .privateWorkoutTargetZoneMin: return "Workout Target Zone Minimum (private)"
        case .privateFallActionRequested: return "Requested Fall Action (private)"
        case .glassesPrescriptionDescription: return "Glasses Prescription Description"
        case .privateWorkoutElapsedTimeInHeartRateZones: return "Workout Elapsed Time in Heart Rate Zones (private)"
        case .privateWorkoutWeatherSourceName: return "Workout Weather Source Name (private)"
        case .privateWorkoutHeartRateZones: return "Workout Heart Rate Zones (private)"
        case .privateWorkoutConfiguration: return "Workout Configuration (private)"
        case .privateWorkoutHeartRateZonesConfigurationType: return "Workout Heart Rate Zones Configuration Type (private)"
        case .privateWorkoutHeartRateZonesCurrentZoneIndex: return "Workout Heart Rate Zones Current Zone Index (private)"
        case .privateWorkoutHeartRateZonesLastProcessedEntryDate: return "Workout Heart Rate Zones Last Processed Entry Date (private)"
        case .privateWorkoutHeartRateZonesLastProcessedEventDate: return "Workout Heart Rate Zones Last Processed Event Date (private)"
        case .privateWorkoutCyclingPowerZonesAutomaticFTP: return "Workout Cycling Power Zones Automatic FTP (private)"
        case .privateWorkoutCyclingPowerZonesConfiguration: return "Workout Cycling Power Zones Configuration (private)"
        case .privateWorkoutElapsedTimeInCyclingPowerZones: return "Workout Elapsed Time In Cycling Power Zones (private)"
        case .privateWorkoutAveragePower: return "Average Workout Power (private)"
        case .privateMetricPlatterStatistics: return "Metric Platter Statistics (private)"
        case .userMotionContext: return "User Motion Context"
        case .heartRateRecoveryActivityDuration: return "Heart Rate Recovery Activity Duration"
        case .heartRateRecoveryActivityType: return "Heart Rate Recovery Activity Type"
        case .heartRateRecoveryTestType: return "Heart Rate Recovery Test Type"
        case .heartRateRecoveryMaxObservedRecoveryHeartRate: return "Max. Observed Recovery Heart Rate"
        case .sessionEstimate: return "Session Estimate"
        case .privateWorkoutExtendedMode: return "Extended Workout Mode (private)"
        case .privateSessionID: return "Session ID (private)"
        case .maximumLightIntensity: return "Maximum Light Intensity"
        case .activityType: return "Activity Type"
        case .physicalEffortEstimationType: return "Physical Effort Estimation Type"
        case .privateFastestPace: return "Fastest Pace (private)"
        case .privateMirroredWorkout: return "Mirrored Workout (private)"
        case .quantityClampedToLowerBound: return "Quantity Clamped To Lower Bound"
        case .unknown(let string): return string
        }
    }
}
