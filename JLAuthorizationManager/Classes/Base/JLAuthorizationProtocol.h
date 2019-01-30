//
//  JLAuthorizationProtocol.h
//  JLAuthorizationDemo
//
//  Created by Jacklin on 2019/1/24.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLConstant.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^JLAuthorizationCompletion)(BOOL);

@protocol JLAuthorizationProtocol <NSObject>

/**
 return current request authorization type.
 */
@property (nonatomic, assign, readonly) JLAuthorizationType type;

/**
 return current authorization status.
 In most cases, suggest use 'requestAuthorizationWithCompletion:completion' method.
 */
- (JLAuthorizationStatus)authorizationStatus;

/**
 Request authorization and return authorization status in main thread.
 */
- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion;

@optional
/**
 Wheather add specific permission description key needed.
 */
- (BOOL)hasSpecificPermissionKeyFromInfoPlist;

@end

NS_ASSUME_NONNULL_END
