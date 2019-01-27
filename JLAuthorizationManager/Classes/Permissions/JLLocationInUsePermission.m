//
//  JLLocationInUsePermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/27.
//

@import CoreLocation;
#import "JLLocationInUsePermission.h"

@interface JLLocationInUsePermission()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) JLAuthorizationCompletion completion;

@end

@implementation JLLocationInUsePermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeMapWhenInUse;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (![CLLocationManager locationServicesEnabled]) {
        return  JLAuthorizationStatusLocationDisabled;
    }
    
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            return JLAuthorizationStatusAuthorized;
            break;
        case  kCLAuthorizationStatusRestricted:
        case  kCLAuthorizationStatusDenied:
            return JLAuthorizationStatusUnAuthorized;
            break;
        case kCLAuthorizationStatusNotDetermined:
            return JLAuthorizationStatusNotDetermined;
            break;
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        self.completion = completion;
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (self.completion) {
        self.completion(status == kCLAuthorizationStatusAuthorizedWhenInUse);
    }
}

@end
