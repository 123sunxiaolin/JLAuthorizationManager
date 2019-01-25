//
//  JLNotificationPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import UserNotifications;
#import "JLNotificationPermission.h"

@interface JLNotificationPermission()

@property (nonatomic, assign) JLAuthorizationStatus curr;

@end

@implementation JLNotificationPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeNotification;
}

@end
