import Foundation
import HealthKit

public protocol HKHealthStoreInterface {

    // MARK: - Accessing HealthKit

    /**
     Returns the app’s authorization status for sharing the specified data type.

     This method checks the authorization status for saving data.

     To help prevent possible leaks of sensitive health information, your app cannot determine whether or not a user has granted permission to read data.
     If you are not given permission, it simply appears as if there is no data of the requested type in the HealthKit store.
     If your app is given share permission but not read permission, you see only the data that your app has written to the store.
     Data from other sources remains hidden.

     - Parameter type: The type of data. This can be any concrete subclass of the ``HKObjectType`` class (any of the ``HKCharacteristicType`` , ``HKQuantityType``, ``HKCategoryType``, ``HKWorkoutType`` or ``HKCorrelationType`` classes).
     - Returns: A value indicating the app’s authorization status for this type. For a list of possible values, see `HKAuthorizationStatus`.
     */
    func authorizationStatus(for type: HKObjectType) -> HKAuthorizationStatus

    /**
     Indicates whether the system presents the user with a permission sheet if your app requests authorization for the provided types.

     Applications may call this method to determine whether the user would be prompted for authorization if the same collections of types are passed to ``requestAuthorizationToShareTypes:readTypes:completion:``. This determination is performed asynchronously and its completion will be executed on an arbitrary
     background queue.

     When working with clinical types, users may need to reauthorize access when new data is added.
     */
    func statusForAuthorizationRequest(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws -> HKAuthorizationRequestStatus

    /**
     Returns a Boolean value that indicates whether HealthKit is available on this device.

     By default, HealthKit data is available on iOS and watchOS. HealthKit data is also available on iPadOS 17 or later. However, devices running in an enterprise environment may restrict access to HealthKit data.

     Additionally, while the HealthKit framework is available on iPadOS 16 and earlier and on MacOS 13 and later, these devices don’t have a copy of the HealthKit store. This means you can include HealthKit code in apps running on these devices, simplifying the creation of multiplatform apps. However, they can’t read or write HealthKit data, and calls to ``isHealthDataAvailable()`` return ``false``.

     - Returns: `true` if HealthKit is available; otherwise, `false`.
     */
    static func isHealthDataAvailable() -> Bool

    /**
     Returns a Boolean value that indicates whether the current device supports clinical records.

     This method returns true if the device is set to a locale where clinical records are supported, or if the user already has clinical records downloaded to their HealthKit store. Otherwise, it returns false.

     This method lets users switch their locale without losing their health records.
     */
    @available(watchOS 10.0, *)
    func supportsHealthRecords() -> Bool

    /**
     Asynchronously requests permission to save and read the specified data types.

     HealthKit performs these requests asynchronously. If you call this method with a new data type (a type of data that the user hasn’t previously granted or denied permission for in this app), the system automatically displays the permission form, listing all the requested permissions. After the user has finished responding, this method calls its completion block on a background queue. If the user has already chosen to grant or prohibit access to all of the types specified, HealthKit calls the completion without prompting the user.

     - Important: In watchOS 6 and later, this method displays the permission form on Apple Watch, enabling independent HealthKit apps. In watchOS 5 and earlier, this method prompts the user to authorize the app on their paired iPhone. For more information, see Creating Independent watchOS Apps.

     Each data type has two separate permissions, one to read it and one to share it. You can make a single request, and include all the data types your app needs.

     Customize the messages displayed on the permissions sheet by setting the following keys:
     * ``NSHealthShareUsageDescription`` customizes the message for reading data.
     * ``NSHealthUpdateUsageDescription`` customizes the message for writing data.

     - Warning: You must set the usage keys, or your app will crash when you request authorization.

     For projects created using Xcode 13 or later, set these keys in the Target Properties list on the app’s Info tab. For projects created with Xcode 12 or earlier, set these keys in the apps Info.plist file. For more information, see [Information Property List](doc://com.apple.documentation/documentation/bundleresources/information_property_list).

     After users have set the permissions for your app, they can always change them using either the Settings or the Health app. Your app appears in the Health app’s Sources tab, even if the user didn’t allow permission to read or share data.

     - Parameter typesToShare: A set containing the data types you want to share. This set can contain any concrete subclass of the ``HKSampleType`` class (any of the ``HKQuantityType``, ``HKCategoryType``, ``HKWorkoutType``, or ``HKCorrelationType`` classes ). If the user grants permission, your app can create and save these data types to the HealthKit store.
     - Parameter typesToRead: A set containing the data types you want to read. This set can contain any concrete subclass of the ``HKObjectType`` class (any of the ``HKCharacteristicType``, ``HKQuantityType``, ``HKCategoryType``, ``HKWorkoutType``, or ``HKCorrelationType`` classes). If the user grants permission, your app can read these data types from the HealthKit store.
     - Parameter completion: A block called after the user finishes responding to the request. The system calls this block with the following parameters:
     - Parameter success: A Boolean value that indicates whether the request succeeded. This value doesn’t indicate whether the user actually granted permission. The parameter is false if an error occurred while processing the request; otherwise, it’s true.
     - Parameter error: An error object. If an error occurred, this object contains information about the error; otherwise, it’s set to nil.
     */
    func requestAuthorization(toShare typesToShare: Set<HKSampleType>, read typesToRead: Set<HKObjectType>) async throws

    /**
     Asynchronously requests permission to read a data type that requires per-object authorization (such as vision prescriptions).

     Some samples require per-object authorization. For these samples, people can select which ones your app can read on a sample-by-sample basis. By default, your app can read any of the per-object authorization samples that it has saved to the HealthKit store; however, you may not always have access to those samples. People can update the authorization status for any of these samples at any time.

     Your app can begin by querying for any samples that it already has permission to read.

     ```
     // Read the newest prescription from the HealthKit store.
     let queryDescriptor = HKSampleQueryDescriptor(
     predicates: [.visionPrescription()],
     sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
     limit: 1)

     let prescription: HKVisionPrescription

     do {
     guard let result = try await queryDescriptor.result(for: store).first else {
     print("*** No prescription found. ***")
     return
     }
     prescription = result
     } catch {
     // Handle the error here.
     fatalError("*** An error occurred while reading the most recent vision prescriptions: \(error.localizedDescription) ***")
     }
     ```

     Based on the results, you can then decide whether you need to request authorization for additional samples. Call `requestPerObjectReadAuthorization(for:predicate:completion:)` to prompt someone to modify the samples your app has access to read.

     ```
     // Request authorization to read vision prescriptions.
     do {
     try await store.requestPerObjectReadAuthorization(for: .visionPrescriptionType(), predicate: nil)
     } catch HKError.errorUserCanceled {
     // Handle the user canceling the authorization request.
     print("*** The user canceled the authorization request. ***")
     return
     } catch {
     // Handle the error here.
     fatalError("*** An error occurred while requesting permission to read vision prescriptions: \(error.localizedDescription) ***")
     }
     ```

     - Important: Using the ``requestAuthorization(toShare:read:)`` method to request read access to any data types that require per-object authorization fails with an ``HKError.Code.errorInvalidArgument`` error.

     When your app calls this method, HealthKit displays an authorization sheet that asks for permission to read the samples that match the predicate and object type. The person using your app can then select individual samples to share with your app. The system always asks for permission, regardless of whether they previously granted it.

     After the person responds, the method returns.

     - Parameter objectType: The data type you want to read.
     - Parameter predicate: A predicate that further restricts the data type.
     */
    func requestPerObjectReadAuthorization(for objectType: HKObjectType, predicate: NSPredicate?) async throws

    /**
     Requests permission to save and read the data types specified by an extension.

     The host app must implement the application delegate’s ``applicationShouldRequestHealthAuthorization(_:)`` method.
     This delegate method is called after an app extension calls ``requestAuthorization(toShare:read:completion:)``.
     The host app is then responsible for calling `handleAuthorizationForExtension()`.
     This method prompts the user to authorize both the app and its extensions for the types that the extension requested.

     The system performs this request asynchronously.
     After the user has finished responding, this method returns.
     If the user has already chosen to grant or prohibit access to all of the types specified, the method returns without prompting the user.
     */
    func handleAuthorizationForExtension() async throws

    /**
     The view controller that presents HealthKit authorization sheets.

     By default, the system infers the correct view controller to show HealthKit’s authorization sheet.
     In some cases, you can improve the user experience by explicitly defining how the system presents the authentication sheets.
     In particular, consider setting this property when using HealthKit in an iPadOS app.
     */
    //@available(iOS 17.0, macCatalyst 17.0, visionOS 1.0, *)
    //var authorizationViewControllerPresenter: UIViewController? { get set }

    // MARK: - Querying HealthKit data

    /**
     Starts executing the provided query.

     HealthKit executes queries asynchronously on a background queue.
     Most queries automatically stop after they have finished executing.
     However, long-running queries—such as observer queries and some statistics collection queries—continue to execute in the background.
     To stop long-running queries, call the ``stop(_:)`` method.

     - Parameter query: A concrete subclass of the ``HKQuery`` class (any of the classes ``HKSampleQuery``, ``HKAnchoredObjectQuery``, ``HKCorrelationQuery``, ``HKObserverQuery``, ``HKSourceQuery``, ``HKStatisticsQuery``, or ``HKStatisticsCollectionQuery``).
     */
    //func execute(HKQuery)

    /**
     Augments a `HKSampleQuery`.

     This function performs the same action as when creating a `HKSampleQuery` and executing it on a `HKHealthStore`.

     It's necessary to extract this function since not all properties of a `HKSampleType` can be accessed.
     */
    func executeSampleQuery(sampleType: HKSampleType, predicate: NSPredicate?, limit: Int, sortDescriptors: [NSSortDescriptor]?, resultsHandler: @escaping (HKSampleQuery, [HKSample]?, Error?) -> Void) -> HKQuery

    /**
     Stops a long-running query.

     Use this method on long-running queries only.
     Most queries automatically stop after they have gathered the requested data.
     Long-running queries continue to operate on a background thread, watching the HealthKit store for updates.
     You can cancel these queries by using this method.

     - Parameter query: Either an ``HKObserverQuery`` instance or an ``HKStatisticsCollectionQuery`` instance.
     */
    func stop(_ query: HKQuery)

    // MARK: - Reading characteristic data

    /**
     Reads the user’s biological sex from the HealthKit store.

     If the user has not yet set his or her biological sex or if they have denied your app permission to read the biological sex, this method returns an ``HKBiologicalSex.notSet`` value.

     - Returns: The user’s biological sex.
     */
    func biologicalSex() throws -> HKBiologicalSex

    /**
     Reads the user’s blood type from the HealthKit store.

     If the user has not specified a blood type or if the user has denied your app permission to read the blood type, this method returns an ``HKBloodType.notSet`` value.

     - Returns: The user’s blood type.
     */
    func bloodType() throws -> HKBloodType

    /**
     Reads the user’s date of birth from the HealthKit store as date components.

     If the user has not yet specified a birth date, or if the user has denied your app permission to read the birth date, this method returns `nil`.
     - Returns: An ``NSDateComponents`` object representing the user’s birthdate in the Gregorian calendar, or `nil`.
     */
    func dateOfBirthComponents() throws -> DateComponents

    /**
     Reads the user’s Fitzpatrick Skin Type from the HealthKit store.

     If the user has not yet specified a skin type, or if the user has denied your app permission to read the skin type, this method returns ``HKFitzpatrickSkinType.notSet``.

     - Returns: The skin type selected by the user.
     */
    func fitzpatrickSkinType() throws -> HKFitzpatrickSkinType

    /**
     Reads the user’s wheelchair use from the HealthKit store.

     If the user has not yet specified their wheelchair use, or if the user has denied your app permission to read the wheelchair use, this method returns ``HKWheelchairUse.notSet``.

     - Returns: Whether the user uses a wheelchair.
     */
    func wheelchairUse() throws -> HKWheelchairUse

    // MARK: - Working with HealthKit objects

    /**
     Deletes the specified object from the HealthKit store.

     Your app can delete only those objects that it has previously saved to the HealthKit store.
     If the user revokes sharing permission, you can no longer delete the object.
     This method operates asynchronously.
     As soon as the delete operation is finished, it calls the completion block on a background queue.

     If your app has not requested permission to share the object’s data type, the method fails with an ``HKError.Code.errorAuthorizationNotDetermined`` error.
     If your app has been denied permission to share the object’s data type, it fails with an ``HKError.Code.errorAuthorizationDenied`` error.

     HealthKit stores a temporary ``HKDeletedObject`` entry, letting you query for recently deleted objects.
     However, the deleted objects are periodically removed to save storage space.
     If you want your app to receive notifications about all the deleted objects, set up an observer query, and enable it for background delivery.
     In the background query’s update handler, create an ``HKAnchoredObjectQuery`` object to gather the list of recently deleted objects.

     - Parameter object: An object that this app has previously saved to the HealthKit store.
     */
    func delete(_ object: HKObject) async throws

    /**
     Deletes objects saved by this application that match the provided type and predicate.

     Your app can delete only those objects that it has previously saved to the HealthKit store.
     If the user revokes sharing permission for an object type, you can no longer delete those objects.
     This method operates asynchronously.
     As soon as the delete operation is finished, it calls the completion block on a background queue.

     If your app has not requested permission to share an object’s data type, the method fails with an ``HKError.Code.errorAuthorizationNotDetermined`` error.
     If your app has been denied permission to share an object’s data type, it fails with an ``HKError.Code.errorAuthorizationDenied`` error.
     Deleting objects that are not stored in the HealthKit store fails with an ``HKError.Code.errorInvalidArgument`` error.
     When deleting multiple objects, if any object cannot be deleted, none of them are deleted.

     HealthKit stores temporary ``HKDeletedObject`` entries, letting you query for recently deleted objects.
     However, the deleted objects are periodically removed to save storage space.
     If you want your app to receive notifications about all the deleted objects, set up an observer query, and enable it for background delivery.
     In the background query’s update handler, create an anchored object query to gather the list of recently deleted objects.

     - Note: Although your app can manage only the objects it created and saved, the users can always delete any data they want using the Health app.

     - Parameter objects: An array of objects that this app has previously saved to HealthKit. Deleting an empty array fails with an ``HKError.Code.errorInvalidArgument`` error.
     */
    func delete(_ objects: [HKObject]) async throws

    /**
     Deletes objects saved by this application that match the provided type and predicate.

     Your app can delete only those objects that it has previously saved to the HealthKit store.
     If the user revokes sharing permission for an object type, you can no longer delete those objects.
     This method operates asynchronously.
     As soon as the delete operation is finished, it calls the completion block on a background queue.

     If your app has not requested permission to share an object’s data type, the method fails with an ``HKError.Code.errorAuthorizationNotDetermined`` error.
     If your app has been denied permission to share an object’s data type, it fails with an ``HKError.Code.errorAuthorizationDenied`` error.
     Deleting objects that are not stored in the HealthKit store fails with an ``HKError.Code.errorInvalidArgument`` error.
     When deleting multiple objects, if any object cannot be deleted, none of them are deleted.

     HealthKit stores temporary ``HKDeletedObject`` entries, letting you query for recently deleted objects.
     However, the deleted objects are periodically removed to save storage space.
     If you want your app to receive notifications about all the deleted objects, set up an observer query, and enable it for background delivery.
     In the background query’s update handler, create an anchored object query to gather the list of recently deleted objects.

     - Note: Although your app can manage only the objects it created and saved, the users can always delete any data they want using the Health app.

     - Parameter objectType: The type of object to be deleted.
     - Parameter predicate: A predicate used to filter the objects to be deleted. This method only deletes objects that match the predicate.
     - Returns: The number of objects deleted.
     */
    func deleteObjects(of objectType: HKObjectType, predicate: NSPredicate) async throws -> Int

    /**
     Returns the earliest date permitted for samples.

     Attempts to save samples earlier than this date fail with an ``HKError.Code.errorInvalidArgument`` error.
     Attempts to query samples before this date return samples after this date.

     - Returns: The earliest date that samples can use. You cannot save or query samples prior to this date.
     */
    func earliestPermittedSampleDate() -> Date

    /**
     Saves the provided object to the HealthKit store.

     If your app has not requested permission to share the object’s data type, the method fails with an ``HKError.Code.errorAuthorizationNotDetermined`` error.
     If your app has been denied permission to save the object’s data type, it fails with an ``HKError.Code.errorAuthorizationDenied`` error.
     Saving an object with the same unique identifier as an object already in the HealthKit store fails with an ``HKError.Code.errorInvalidArgument`` error.

     In iOS 9.0 and later, saving an object to the HealthKit store sets the object’s ``sourceRevision`` property to a ``HKSourceRevision`` instance representing the saving app.
     On earlier versions of iOS, saving an object sets the ``source`` property to a ``HKSource`` instance instead.
     In both cases, these values are available only after the object is retrieved from the HealthKit store.
     The original object is not changed.

     All samples retrieved by iOS 9.0 and later are given a valid ``sourceRevision`` property.
     If the sample was saved using an earlier version of iOS, the source revision’s version is set to `nil`.

     */
    func save(_ object: HKObject) async throws

    /**
     Saves an array of objects to the HealthKit store.

     If your app has not requested permission to share the object’s data type, the method fails with an ``HKError.Code.errorAuthorizationNotDetermined`` error.
     If your app has been denied permission to save the object’s data type, it fails with an ``HKError.Code.errorAuthorizationDenied`` error.
     Saving an object with the same unique identifier as an object already in the HealthKit store fails with an ``HKError.Code.errorInvalidArgument`` error.
     When saving multiple objects, if any object cannot be saved, none of them are saved.

     In iOS 9.0 and later, saving an object to the HealthKit store sets the object’s ``sourceRevision`` property to a ``HKSourceRevision`` instance representing the saving app.
     On earlier versions of iOS, saving an object sets the ``source`` property to a ``HKSource`` instance instead.
     In both cases, these values are available only after the object is retrieved from the HealthKit store.
     The original object is not changed.

     All samples retrieved by iOS 9.0 and later are given a valid ``sourceRevision`` property.
     If the sample was saved using an earlier version of iOS, the source revision’s version is set to `nil`.
     */
    func save(_ objects: [HKObject]) async throws

    // MARK: - Accessing the preferred units


    // MARK: - Managing background delivery


    // MARK: - Managing workouts


    // MARK: - Managing workout sessions


    // MARK: - Managing estimates


    // MARK: - Accessing the move mode


}
