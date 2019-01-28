//
//  JLConstant.h
//  JLAuthorizationManager<https://github.com/123sunxiaolin/JLAuthorizationManager.git>
//
//  <Wechat Public:iOSDevSkills>
//  Created by Jacklin on 2019/1/17.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#ifndef JLConstant_h
#define JLConstant_h

typedef NS_ENUM(NSInteger, JLAuthorizationType) {
    /**
     *  相册/PhotoLibrary
     */
    JLAuthorizationTypePhotoLibrary = 0,
    /**
     *  网络/Cellular Network
     */
    JLAuthorizationTypeCellularNetWork,
    /**
     *  相机/Camera
     */
    JLAuthorizationTypeCamera,
    /**
     *  麦克风/Microphone
     */
    JLAuthorizationTypeMicrophone,
    /**
     *  通讯录/AddressBook
     */
    JLAuthorizationTypeAddressBook,
    /**
     *  日历/Calendar
     */
    JLAuthorizationTypeCalendar,
    /**
     *  提醒事项/Reminder
     */
    JLAuthorizationTypeReminder,
    /**
     *  通知/Notification
     */
    JLAuthorizationTypeNotification,
    /**
     *  一直请求定位权限/AlwaysAuthorization
     */
    JLAuthorizationTypeMapAlways,
    /**
     *  使用时请求定位权限/WhenInUseAuthorization
     */
    JLAuthorizationTypeMapWhenInUse,
    /**
     *  媒体资料库/AppleMusic
     */
    JLAuthorizationTypeAppleMusic,
    /**
     *  语音识别/SpeechRecognizer
     */
    JLAuthorizationTypeSpeechRecognizer,
    /**
     *  Siri(must in iOS10 or later)
     */
    JLAuthorizationTypeSiri,
    /**
     *  蓝牙共享/Bluetooth
     */
    JLAuthorizationTypeBluetooth,
    /**
     *  健康数据/Health
     */
    JLAuthorizationTypeHealth,
    /**
     *  推特/Twitter
     */
    JLAuthorizationTypeTwitter,
    /**
     *  脸书/Facebook
     */
    JLAuthorizationTypeFacebook,
    /**
     *  新浪微博/SinaWeibo
     */
    JLAuthorizationTypeSinaWeibo,
    /**
     *  腾讯微博/TencentWeibo
     */
    JLAuthorizationTypeTencentWeibo,
    
};

/**
 AuthorizedStatus
 */
typedef NS_ENUM(NSInteger, JLAuthorizationStatus) {
    JLAuthorizationStatusNotDetermined = 0,
    JLAuthorizationStatusAuthorized,
    JLAuthorizationStatusUnAuthorized,
    JLAuthorizationStatusLocationDisabled,
};

#pragma mark - Constant Key

/**
 Motion
 */
static NSString *const JLAuthorizationRequestedMotionKey               = @"JL_requestedMotion";

/**
 Notifications
 */
static NSString *const JLAuthorizationRequestedNotificationsKey        = @"JL_requestedNotifications";

/**
 Bluetooth
 */
static NSString *const JLAuthorizationRequestedBluetoothKey            = @"JL_requestedBluetooth";

/**
 Map
 */
static NSString *const JLAuthorizationRequestedInUseToAlwaysUpgradeKey = @"JL_requestedInUseToAlwaysUpgrade";

#pragma mark - App InfoPlist Key
static NSString *const JLAuthorizationInfoPlistKeyCamera               = @"NSCameraUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyMicrophone           = @"NSMicrophoneUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyPhotoLibrary         = @"NSPhotoLibraryUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyContact              = @"NSContactsUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyCalendar             = @"NSCalendarsUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyReminder             = @"NSRemindersUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyLocationWhenInUse    = @"NSLocationWhenInUseUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyLocationAlways       = @"NSLocationAlwaysUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyAppleMusic           = @"NSAppleMusicUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeySpeechRecognizer     = @"NSSpeechRecognitionUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyMotion               = @"NSMotionUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyHealthUpdate         = @"NSHealthUpdateUsageDescription";
static NSString *const JLAuthorizationInfoPlistKeyHealthShare          = @"NSHealthShareUsageDescription";

#endif /* JLConstant_h */
