//
//  JLAuthorizationManager.h
//  JLAuthorizationManager<https://github.com/123sunxiaolin/JLAuthorizationManager.git>
//
//  <Wechat Public:iOSDevSkills>
//  Created by Jacklin on 2017/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
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
    /**
     *  蓝牙共享/Bluetooth
     */
    JLAuthorizationTypeBluetooth
};

@interface JLAuthorizationManager : NSObject

+ (JLAuthorizationManager *)defaultManager;

/**
 请求权限统一入口

 @param authorizationType 权限类型
 @param authorizedHandler 授权后的回调
 @param unAuthorizedHandler 未授权的回调
 */
- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;

/**
 请求健康数据权限统一入口

 @param typesToShare 共享/写入共享数据类型集合
 @param typesToRead 读入共享数据类型集合
 @param authorizedHandler 授权后的回调
 @param unAuthorizedHandler 未授权的回调
 */
- (void)JL_requestHealthAuthorizationWithShareTypes:(NSSet*)typesToShare
                                          readTypes:(NSSet*)typesToRead
                                  authorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end
