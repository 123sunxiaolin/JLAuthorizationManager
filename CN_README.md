JLAuthorizationManager

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg) ![Pod Version](https://img.shields.io/badge/Pod-v1.1.0-orange.svg) ![Pod Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg) ![System Version](https://img.shields.io/badge/iOS-8.0-blue.svg) [![Pod License](https://img.shields.io/badge/License-MIT-333333.svg)](https://www.apache.org/licenses/LICENSE-2.0.html)
---
🔑 **JLAuthorizationManager** 是一个易用、轻量化、完整以及线程安全的**iOS**权限管理开源库，目前支持**Objective-C**和**Swift**两种语言。

**JLAuthorizationManager** provides uniform method by using `JL_requestAuthorizationWithAuthorizationType:authorizedHandler:unAuthorizedHandler:` except when request access to `HealthKit` by using `JL_requestHealthAuthorizationWithShareTypes:readTypes:authorizedHandler:unAuthorizedHandler:`

**JLAuthorizationManager** also provides singleton method by using `+ (JLAuthorizationManager *)defaultManager;`,and other methods all are instance method.You can choose any authorization type from an enum type `JLAuthorizationType`.

## 基本特性

- [x] 覆盖面全，目前支持拍照、相册、蜂窝网络、麦克风、日历、提醒事项、通知、定位、音乐库、语音识别、Siri、蓝牙、健康数据、体能与训练记录等权限访问；
- [x] 使用方法简单，接口统一，单一权限文件分离，避免因添加无用权限导致提交**App Store**审核不过的问题；
- [x] 异步请求权限，在主线程下回调；
- [x] 提供单例模式下的所有权限访问和单一权限访问的两种方式，便于开发者更加灵活的使用；

入门
------------
### 基本要求
- **JLAuthorizationManager**支持iOS 8.0及以上；
- **JLAuthorizationManager**需使用Xcode 8.0以上版本进行编译；

### 安装
- 使用**Cocoapods**进行安装：
<br>1.先安装[Cocoapods](https://guides.cocoapods.org/using/getting-started.html);
<br>2.通过**pod repo update**更新**JLAuthorizationManager**的**Cocoapods**版本;
<br>3.在**Podfile**对应的target中，根据业务需要添加指定的pod, 如下所示，然后执行**pod install**,在项目中使用**CocoaPods**生成的.xcworkspace运行工程;

```
pod 'JLAuthorizationManager' // 与 pod 'JLAuthorizationManager/All' 等价
或
pod 'JLAuthorizationManager/AuthorizationManager'
或
pod 'JLAuthorizationManager/Camera'
或
pod 'JLAuthorizationManager/Microphone'
...

```
- 手动安装
<br>1.首先，在地址**https://github.com/123sunxiaolin/JLAuthorizationManager.git**将项目克隆下来；
<br>2.找到工程目录下的路径JLAuthorizationManager/Classes,必须导入**Base**文件夹，其他文件根据业务需求自定义导入到工程中即可。

使用
------------
#### **JLAuthorizationManager**使用：
- 1.使用`+ (JLAuthorizationManager *)defaultManager;`单例方法进行API的调用；
- 2.引入头文件`#import "JLAuthorizationManager.h"`
- 3.使用统一方法调用：

```
- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
                                 
 // 健康数据
 - (void)JL_requestHealthAuthorizationWithShareTypes:(NSSet*)typesToShare
                                          readTypes:(NSSet*)typesToRead
                                  authorizedHandler:(JLGeneralAuthorizationCompletion)authorizedHandler
                                unAuthorizedHandler:(JLGeneralAuthorizationCompletion)unAuthorizedHandler;
                                
// 社交账号（8.0及以后已废弃）
- (void)JL_requestAccountAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                                    options:(NSDictionary *)options
                                          authorizedHandler:(JLGeneralAuthorizationCompletion)authorizedHandler
                                        unAuthorizedHandler:(JLGeneralAuthorizationCompletion)unAuthorizedHandler
                                               errorHandler:(void(^)(NSError *error))errorHandler;
                                 
```

### 单一权限文件的使用**JLxxxPermission**:

- 1.每一个权限类继承自**JLBasePermisssion**基类，实现统一的接口协议**JLAuthorizationProtocol**:

```
@protocol JLAuthorizationProtocol <NSObject>

/**
 返回当前权限请求的类型.
 */
@property (nonatomic, assign, readonly) JLAuthorizationType type;

/**
 返回当前权限的状态
 */
- (JLAuthorizationStatus)authorizationStatus;

/**
 请求权限
 */
- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion;

@optional
/**
 是否在info.Plist中添加指定权限的Key
 */
- (BOOL)hasSpecificPermissionKeyFromInfoPlist;

@end

```

- 基本使用（以请求相册权限为例说明）:

```
JLPhotosPermission *permission = [JLPhotosPermission instance];
NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
[permission requestAuthorizationWithCompletion:^(BOOL granted) {         
	NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
}];
```

- 请求定位、蓝牙等权限时，需要使用其单例方法**sharedInstance**进行调用，以请求定位信息为例说明：

```
JLLocationAlwaysPermission *permission = [JLLocationAlwaysPermission sharedInstance];
NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
[permission requestAuthorizationWithCompletion:^(BOOL granted) {
	NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
}];
```

- 请求健康数据权限：

```
HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
HKObjectType *type1 = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
NSSet *shareSet = [NSSet setWithObjects:type, type1, nil];
JLHealthPermission *permission = [[JLHealthPermission alloc] initWithShareType:shareSet readTypes:shareSet];
NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
[permission requestAuthorizationWithCompletion:^(BOOL granted) {
	NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
}];
```

更多用法请参照**DEMO**

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