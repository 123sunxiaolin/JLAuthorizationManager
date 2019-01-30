//
//  JLSiriPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import Intents;
#import "JLSiriPermission.h"

@implementation JLSiriPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeSpeechRecognizer;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (@available(iOS 10.0, *)) {
        
        INSiriAuthorizationStatus authStatus = [INPreferences siriAuthorizationStatus];
        switch (authStatus) {
            case INSiriAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case INSiriAuthorizationStatusRestricted:
            case INSiriAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case INSiriAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
        
    } else {
        return JLAuthorizationStatusDisabled;
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        if (@available(iOS 10.0, *)) {
            [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(status == INSiriAuthorizationStatusAuthorized);
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
