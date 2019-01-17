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
    JLAuthorizationStatusNotDetermine = 0,
    JLAuthorizationStatusAuthorized,
    JLAuthorizationStatusUnAuthorized,
    JLAuthorizationStatusLocationDisabled,
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
/**
  请求社交账号访问权限

 @param authorizationType 权限类型
 @param options 请求账号时需要的配置信息(Facebook 和 腾讯微博不能为空)
 @param authorizedHandler 授权后的回调
 @param unAuthorizedHandler 未授权的回调
 @param errorHandler 产生错误的回调
 */
- (void)JL_requestAccountAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                                    options:(NSDictionary *)options
                                          authorizedHandler:(void(^)())authorizedHandler
                                        unAuthorizedHandler:(void(^)())unAuthorizedHandler
                                               errorHandler:(void(^)(NSError *error))errorHandler;
@end
