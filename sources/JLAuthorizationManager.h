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
     *  相册
     */
    JLAuthorizationTypePhotoLibrary = 0,
    /**
     *  网络
     */
    JLAuthorizationTypeNetWork,
    /**
     *  相机
     */
    JLAuthorizationTypeVideo,
    /**
     *  麦克风
     */
    JLAuthorizationTypeAudio,
    /**
     *  通讯录
     */
    JLAuthorizationTypeAddressBook,
    /**
     *  日历
     */
    JLAuthorizationTypeCalendar,
    /**
     *  备忘提醒
     */
    JLAuthorizationTypeReminder,
};

@interface JLAuthorizationManager : NSObject

+ (JLAuthorizationManager *)defaultManager;

- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end
