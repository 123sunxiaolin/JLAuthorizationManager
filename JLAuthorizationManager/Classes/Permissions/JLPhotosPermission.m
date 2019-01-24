//
//  JLPhotosPermission.m
//  JLAuthorizationDemo
//
//  Created by Jacklin on 2019/1/24.
//  Copyright © 2019年 com.jack.lin. All rights reserved.
//

@import Photos;
@import AssetsLibrary;
#import "JLPhotosPermission.h"

@implementation JLPhotosPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypePhotoLibrary;
}

- (JLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 8.0, *)) {
        //used `PHPhotoLibrary`
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        switch (authStatus) {
            case PHAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case PHAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
        
    }else{
        //used `AssetsLibrary`
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        switch (authStatus) {
            case ALAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case ALAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
#pragma clang diagnostic pop
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self safeAsyncWithCompletion:^{
                if (completion) {
                    completion(status == PHAuthorizationStatusAuthorized);
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
