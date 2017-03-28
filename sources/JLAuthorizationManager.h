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
     *  备忘提醒/Reminder
     */
    JLAuthorizationTypeReminder,
};

@interface JLAuthorizationManager : NSObject

+ (JLAuthorizationManager *)defaultManager;

- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end
