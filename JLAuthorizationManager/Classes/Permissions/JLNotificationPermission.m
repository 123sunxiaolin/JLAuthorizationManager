//
//  JLNotificationPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import UserNotifications;
#import "JLNotificationPermission.h"

@interface JLNotificationPermission() {
    // temp use
    NSTimer *timer;
}

@property (nonatomic, assign) JLAuthorizationStatus currentAuthorizedStatus;

/**
 For iOS 10.0 before, user the property to store request notification status
 */
@property (nonatomic, assign) BOOL isRequestNotification;

@property (nonatomic, copy) JLAuthorizationCompletion authorizationCompletion;


@end

@implementation JLNotificationPermission

- (instancetype)init {
    if (self = [super init]) {
        self.currentAuthorizedStatus = JLAuthorizationStatusNotDetermined;
    }
    return self;
}

#pragma mark - JLAuthorizationNotificationProtocol

- (JLAuthorizationType)type {
    return JLAuthorizationTypeNotification;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (@available(iOS 10.0, *)) {
        return self.currentAuthorizedStatus;
    } else {
        UIUserNotificationSettings *settings = UIApplication.sharedApplication.currentUserNotificationSettings;
        if (settings.types != UIUserNotificationTypeNone) {
            return JLAuthorizationStatusAuthorized;
        } else {
            if (self.isRequestNotification) {
                return JLAuthorizationStatusUnAuthorized;
            } else {
                return JLAuthorizationStatusNotDetermined;
            }
        }
    }
}

- (void)asyncFetchAuthorizedStatusWithCompletion:(void (^)(JLAuthorizationStatus))completion {
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            JLAuthorizationStatus status = JLAuthorizationStatusNotDetermined;
            switch (settings.authorizationStatus) {
                case UNAuthorizationStatusAuthorized:
                    status = JLAuthorizationStatusAuthorized;
                    break;
                case UNAuthorizationStatusDenied:
                    status = JLAuthorizationStatusUnAuthorized;
                    break;
                case UNAuthorizationStatusNotDetermined:
                    status = JLAuthorizationStatusNotDetermined;
                    break;
                default:
                    if (@available(iOS 12.0, *)) {
                        status = JLAuthorizationStatusAuthorized;
                    } else {
                        status = JLAuthorizationStatusNotDetermined;
                    }
                    break;
            }
            
            self.currentAuthorizedStatus = status;
            
            [self safeAsyncWithCompletion:^{
                if (completion) {
                    completion(status);
                }
            }];
        }];
        
    } else {
        if (completion) {
            completion(JLAuthorizationStatusDisabled);
        }
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        if (@available(iOS 10.0, *)) {
            UNAuthorizationOptions options = UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
            [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(granted);
                    }
                }];
            }];
        } else {
            self.authorizationCompletion = completion;
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(requestingNotificationPermission)
                                                       name:UIApplicationWillResignActiveNotification
                                                     object: nil];
            timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(finishedRequestNotificationPermission)
                                                   userInfo:nil
                                                    repeats:NO];
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
            [UIApplication.sharedApplication registerUserNotificationSettings:settings];
        }
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}


#pragma mark - Getters/Setters

- (BOOL)isRequestNotification {
    return [NSUserDefaults.standardUserDefaults boolForKey:JLAuthorizationRequestedNotificationsKey];
}

- (void)setIsRequestNotification:(BOOL)isRequestNotification {
    [NSUserDefaults.standardUserDefaults setBool:isRequestNotification forKey:JLAuthorizationRequestedNotificationsKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

#pragma mark - Notification
- (void)requestingNotificationPermission {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(finishedRequestNotificationPermission)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)finishedRequestNotificationPermission {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object: nil];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    self.isRequestNotification = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.authorizationCompletion) {
            self.authorizationCompletion(self.currentAuthorizedStatus == JLAuthorizationStatusAuthorized);
        }
    });
}

@end
