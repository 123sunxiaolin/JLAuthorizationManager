//
//  JLAppleMusicPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import MediaPlayer;
#import "JLAppleMusicPermission.h"

@implementation JLAppleMusicPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeAppleMusic;
}

- (JLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 9.3, *)) {
        MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
        switch (authStatus) {
            case MPMediaLibraryAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case MPMediaLibraryAuthorizationStatusRestricted:
            case MPMediaLibraryAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case MPMediaLibraryAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
        
    } else {
        return JLAuthorizationStatusDisabled;
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
        if (@available(iOS 9.3, *)) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(status == MPMediaLibraryAuthorizationStatusAuthorized);
                    }
                }];
            }];
        } else {
            NSAssert(NO, @"Please use at least 9.3 and later!");
        }
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

@end
