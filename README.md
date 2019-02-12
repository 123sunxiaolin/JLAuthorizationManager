JLAuthorizationManager

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg) ![Pod Version](https://img.shields.io/badge/Pod-v1.1.0-orange.svg) ![Pod Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg) ![System Version](https://img.shields.io/badge/iOS-8.0-blue.svg) [![Pod License](https://img.shields.io/badge/License-MIT-333333.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
---
🔑 **JLAuthorizationManager** is a project to show all develop process  authorization managers.

**JLAuthorizationManager** provides uniform method by using `JL_requestAuthorizationWithAuthorizationType:authorizedHandler:unAuthorizedHandler:` except when request access to `HealthKit` by using `JL_requestHealthAuthorizationWithShareTypes:readTypes:authorizedHandler:unAuthorizedHandler:`

**JLAuthorizationManager** also provides singleton method by using `+ (JLAuthorizationManager *)defaultManager;`,and other methods all are instance method.You can choose any authorization type from an enum type `JLAuthorizationType`.

## Features

- [x] Async fetch authorized status for **Photos**
- [x] Async fetch authorized status for **Camera**
- [x] Async fetch authorized status for **CellularNetwork**
- [x] Async fetch authorized status for **Microphone**
- [x] Async fetch authorized status for **Calendar**
- [x] Async fetch authorized status for **Reminder**
- [x] Async fetch authorized status for **Notification**
- [x] Async fetch authorized status for **Location**
- [x] Async fetch authorized status for **AppleMusic**
- [x] Async fetch authorized status for **SpeechRecognizer**
- [x] Async fetch authorized status for **Siri**
- [x] Async fetch authorized status for **Bluetooth**
- [x] Callback with main thread
- [x] Callback in two different block
- [x] Covering the full

Getting Started
------------
### Update Records
- 2019-1-17: add notification、appleMusic etc permission methods.

### 1、Most Authorization Access Method
First, import header file:`#import "JLAuthorizationManager.h"`<br>

then,using method:

```
- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
```
`JLAuthorizationType` contains 13 authorization types from 13 libraries, the correspondences as follows:

```
JLAuthorizationTypePhotoLibrary -> Photos/AssetsLibrary <br>
JLAuthorizationTypeNetWork -> CoreTelephony
JLAuthorizationTypeVideo - > AVFoundation
JLAuthorizationTypeAudio - > AVFoundation
JLAuthorizationTypeAddressBook - > AddressBook/Contacts
JLAuthorizationTypeCalendar - > EventKit
JLAuthorizationTypeReminder - > EventKit
JLAuthorizationTypeMapAlways -> CoreLocation
JLAuthorizationTypeMapWhenInUse -> CoreLocation
JLAuthorizationTypeAppleMusic -> MediaPlayer
JLAuthorizationTypeSpeechRecognizer -> Speech
JLAuthorizationTypeSiri -> Intents
JLAuthorizationTypeBluetooth -> CoreBluetooth
```
Implementation method for one example as follows:

```
[[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypePhotoLibrary authorizedHandler:^{
                NSLog(@"PhotoLibrary Has granted!");
            } unAuthorizedHandler:^{
                NSLog(@"PhotoLibrary Has Not granted!");
            }];
```
> **Notes**:Call before use `[JLAuthorizationManager defaultManager]`.

### 2、Special Authorization Access Method for HealthKit

When you want to use `HealthKit` authorization , please use other method as follows:

```
- (void)JL_requestHealthAuthorizationWithShareTypes:(NSSet*)typesToShare
                                          readTypes:(NSSet*)typesToRead
                                  authorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler;
```

Paramrter `typesToShare` need user to pass some healthKit type to share(that is `write` health data to App).

Paramrter `typesToRead` need user to pass some healthKit type to read.

if not clear,please refer to method as follows from [Apple](https://developer.apple.com/reference/healthkit/hkhealthstore/1614152-requestauthorization):

```
- (void)requestAuthorizationToShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                               readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                              completion:(void (^)(BOOL success, NSError * _Nullable error))completion;
```

Installation
----
- **For iOS 8+ projects** with [CocoaPods](https://cocoapods.org):

    ```ruby
     pod 'JLAuthorizationManager', '~> 1.1.0'
    ```
    
- **Use Manually**
 
 	```manually
 	git clone 'https://github.com/123sunxiaolin/JLAuthorizationManager.git'
 	
 	then, add JLAuthorizationManager folder into your app
 	
 	in the end, it's all right!
 	```
 	
Requirements
-----
JLAuthorizationManager requires Xcode and iOS version as follows:

- **iOS 8.0 or later**<br>

- **Xcode 8.0 or later**

>**Notes:** if you want to used in xcode 8.0 earlier,please remove methods as follows,if not ,the app can't run at all.

```
- (void)p_requestSpeechRecognizerAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                         unAuthorizedHandler:(void(^)())unAuthorizedHandler；<br>

- (void)p_requestSiriAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                             unAuthorizedHandler:(void(^)())unAuthorizedHandler;
                             
- (void)p_requestAppleMusicAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                   unAuthorizedHandler:(void(^)())unAuthorizedHandler;                                      
```

Tips and Tricks
---------------

- **Don't** forget add authorization Description in `info.plist`.
- if you want to use `HealthKit` or `Siri`,please open switch on `Capabilities`,then system create `xx..entitlements` file automatically.
- if not find more, please refer to `JLAuthorizationDemo`.


Update Note
---------------
- v**2.0.2**:Update podSpec file.
- v**2.0.0**:Divide all permissions into single permission file to avoid fail to commit **AppStore** and provide various ways to request.
- v**1.1.0**:Optimize request methods and add notification permission.
- v**1.0.0**:Provide simple usage of permission for developer and all request usages are in unique class-**JLAuthorizationManager**.

License
-------

JLAuthorizationManager is under MIT license. See the [LICENSE](https://github.com/123sunxiaolin/JLAuthorizationManager/blob/master/LICENSE) file for more info.