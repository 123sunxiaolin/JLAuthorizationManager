//
//  JLBasePermisssion.m
//  JLAuthorizationDemo
//
//  Created by Jacklin on 2019/1/24.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//

#import "JLBasePermisssion.h"

@implementation JLBasePermisssion
@synthesize type;

+ (instancetype)instance {
    return [[self alloc] init];
}

- (void)safeAsyncWithCompletion:(dispatch_block_t)completion {
    if (NSThread.isMainThread) {
        if (completion) {
            completion();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
}

- (JLAuthorizationStatus)authorizationStatus {
    return JLAuthorizationStatusNotDetermined;
}

- (BOOL)hasSpecificPermissionKeyFromInfoPlist {
    return YES;
}

- (void)requestAuthorizationWithCompletion:(nonnull JLAuthorizationCompletion)completion {}

- (NSString *)permissionDescriptionKey {
    switch (self.type) {
        case JLAuthorizationTypePhotoLibrary:
            return JLAuthorizationInfoPlistKeyPhotoLibrary;
            break;
        case JLAuthorizationTypeCamera:
            return JLAuthorizationInfoPlistKeyCamera;
            break;
        case JLAuthorizationTypeMicrophone:
            return JLAuthorizationInfoPlistKeyMicrophone;
            break;
        case JLAuthorizationTypeAddressBook:
            return JLAuthorizationInfoPlistKeyContact;
            break;
        case JLAuthorizationTypeCalendar:
            return JLAuthorizationInfoPlistKeyCalendar;
            break;
        case JLAuthorizationTypeMapWhenInUse:
            return JLAuthorizationInfoPlistKeyLocationWhenInUse;
            break;
        case JLAuthorizationTypeMapAlways:
            return JLAuthorizationInfoPlistKeyLocationAlways;
            break;
        case JLAuthorizationTypeAppleMusic:
            return JLAuthorizationInfoPlistKeyAppleMusic;
            break;
        case JLAuthorizationTypeSpeechRecognizer:
            return JLAuthorizationInfoPlistKeySpeechRecognizer;
            break;
        case JLAuthorizationTypeMotion:
            return JLAuthorizationInfoPlistKeyMotion;
            break;
        case JLAuthorizationTypeHealth:// only return healthShareType
            return JLAuthorizationInfoPlistKeyHealthShare;
            break;
            
        default:
            return @" ";
            break;
    }
}

@end
