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

+ (instancetype)instance {
    NSAssert(NO, @"please use 'sharedInstance' singleton method!");
    return nil;
}

+ (instancetype)sharedInstance {
    static JLLocationInUsePermission *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLLocationInUsePermission alloc] init];
    });
    return instance;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypeMapWhenInUse;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (![CLLocationManager locationServicesEnabled]) {
        return  JLAuthorizationStatusDisabled;
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

- (BOOL)hasSpecificPermissionKeyFromInfoPlist {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:self.permissionDescriptionKey];
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    NSString *desc = [NSString stringWithFormat:@"%@ not found in Info.plist.", self.permissionDescriptionKey];
    NSAssert([self hasSpecificPermissionKeyFromInfoPlist], desc);
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        self.completion = completion;
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        [self.locationManager requestWhenInUseAuthorization];
        
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
