//
//  JLAuthorizationManager.h
//  JLUtilsDemo
//
//  Created by perfect on 2017/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JLAuthorizationType) {
    JLAuthorizationTypePhotoLibrary = 0,
    JLAuthorizationTypeNetWork,
    JLAuthorizationTypeVideo,
    JLAuthorizationTypeAudio
};

@interface JLAuthorizationManager : NSObject

+ (JLAuthorizationManager *)defaultManager;

- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end
