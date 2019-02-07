//
//  JLLocationAlwaysPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/27.
//

@import CoreLocation;
#import "JLLocationAlwaysPermission.h"

@interface JLLocationAlwaysPermission()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) JLAuthorizationCompletion completion;

@end

@implementation JLLocationAlwaysPermission

+ (instancetype)instance {
    NSAssert(NO, @"please use 'sharedInstance' singleton method!");
    return nil;
}

+ (instancetype)sharedInstance {
    static JLLocationAlwaysPermission *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLLocationAlwaysPermission alloc] init];
    });
    return instance;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypeMapAlways;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (![CLLocationManager locationServicesEnabled]) {
        return  JLAuthorizationStatusDisabled;
    }
    
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            return JLAuthorizationStatusAuthorized;
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            // InUse to Always upgrade case
            BOOL isAlwaysFormInUse = [NSUserDefaults.standardUserDefaults boolForKey:JLAuthorizationRequestedInUseToAlwaysUpgradeKey];
            if (isAlwaysFormInUse) {
                return JLAuthorizationStatusAuthorized;
            }
            return JLAuthorizationStatusNotDetermined;
        }
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
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [NSUserDefaults.standardUserDefaults setBool:YES
                                                  forKey:JLAuthorizationRequestedInUseToAlwaysUpgradeKey];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
        
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
        [self.locationManager requestAlwaysAuthorization];
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (self.completion) {
        self.completion(status == kCLAuthorizationStatusAuthorizedAlways);
    }
}
@end
