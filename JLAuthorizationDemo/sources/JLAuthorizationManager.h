//
//  JLAuthorizationManager.h
//  JLUtilsDemo
//
//  Created by perfect on 2017/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JLAuthorizationType) {
    /**
     *  相册/PhotoLibrary
     */
    JLAuthorizationTypePhotoLibrary = 0,
    /**
     *  网络/Cellular Network
     */
    JLAuthorizationTypeNetWork,
    /**
     *  相机/Camera
     */
    JLAuthorizationTypeVideo,
    /**
     *  麦克风/Audio
     */
    JLAuthorizationTypeAudio,
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
};

@interface JLAuthorizationManager : NSObject

+ (JLAuthorizationManager *)defaultManager;

- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end
