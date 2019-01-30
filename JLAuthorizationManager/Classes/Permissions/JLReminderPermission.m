//
//  JLReminderPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import EventKit;
#import "JLReminderPermission.h"

@implementation JLReminderPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeReminder;
}

- (JLAuthorizationStatus)authorizationStatus {
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (authStatus) {
        case EKAuthorizationStatusAuthorized:
            return JLAuthorizationStatusAuthorized;
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            return JLAuthorizationStatusUnAuthorized;
            break;
        case EKAuthorizationStatusNotDetermined:
            return JLAuthorizationStatusNotDetermined;
            break;
    }
}

- (BOOL)hasSpecificPermissionKeyFromInfoPlist {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:self.permissionDescriptionKey];
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    NSString *desc = [NSString stringWithFormat:@"%@ not found in Info.plist.", self.permissionDescriptionKey];
    NSAssert([self hasSpecificPermissionKeyFromInfoPlist], desc);
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            [self safeAsyncWithCompletion:^{
                if (completion) {
                    completion(granted);
                }
            }];
        }];
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

@end
