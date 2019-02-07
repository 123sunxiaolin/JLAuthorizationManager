//
//  JLCellularNetWorkPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import CoreTelephony;
#import "JLCellularNetWorkPermission.h"

@implementation JLCellularNetWorkPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeCellularNetWork;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (@available(iOS 10.0, *)) {
        
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState authState = cellularData.restrictedState;
        switch (authState) {
            case kCTCellularDataNotRestricted:
                return JLAuthorizationStatusAuthorized;
                break;
            case kCTCellularDataRestricted:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case kCTCellularDataRestrictedStateUnknown:
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
            CTCellularData *cellularData = [[CTCellularData alloc] init];
            cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(state == kCTCellularDataNotRestricted);
                    }
                }];
            };
            
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
