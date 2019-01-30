//
//  JLSpeechRecognizerPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import Speech;
#import "JLSpeechRecognizerPermission.h"

@implementation JLSpeechRecognizerPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeSpeechRecognizer;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (@available(iOS 10.0, *)) {
        
        SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];
        switch (authStatus) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
            case SFSpeechRecognizerAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
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
        if (@available(iOS 10.0, *)) {
            [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(status == SFSpeechRecognizerAuthorizationStatusAuthorized);
                    }
                }];
            }];
    
        } else {
            NSAssert(NO, @"Please use at least 10.0 and later!");
        }
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

@end
