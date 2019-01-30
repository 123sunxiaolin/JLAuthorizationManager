//
//  JLHealthPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/28.
//

#import "JLHealthPermission.h"

@interface JLHealthPermission()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation JLHealthPermission

- (instancetype)initWithShareType:(NSSet <HKSampleType *> *)shareTypes
                        readTypes:(NSSet <HKObjectType *> *)readTypes {
    if (self = [super init]) {
        self.shareTypes = shareTypes;
        self.readTypes = readTypes;
    }
    return self;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypeHealth;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if ([HKHealthStore isHealthDataAvailable]) {
        return JLAuthorizationStatusDisabled;
    }
    
    NSMutableArray *statusForHealth = [NSMutableArray new];
    if (self.shareTypes.count > 0) {
        for (HKSampleType *oneType in self.shareTypes) {
            @autoreleasepool {
                HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:oneType];
                [statusForHealth addObject:@(status)];
            }
        }
    }
    
    if (self.readTypes.count > 0) {
        for (HKObjectType *oneType in self.readTypes) {
            @autoreleasepool {
                HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:oneType];
                [statusForHealth addObject:@(status)];
            }
        }
    }
    
    if (statusForHealth.count > 0) {
        if ([statusForHealth containsObject:@(HKAuthorizationStatusNotDetermined)]) {
            return JLAuthorizationStatusNotDetermined;
        } else if ([statusForHealth containsObject:@(HKAuthorizationStatusSharingDenied)]) {
            return JLAuthorizationStatusUnAuthorized;
        } else {
            return JLAuthorizationStatusAuthorized;
        }
    } else {
        return JLAuthorizationStatusDisabled;
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    if (self.shareTypes.count > 0) {
        id isHasHealthSharePlistKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:JLAuthorizationInfoPlistKeyHealthShare];
        NSAssert(isHasHealthSharePlistKey, @"NSHealthShareUsageDescription not found in Info.plist.");
    }
    
    id isHasHealthUpdatePlistKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:JLAuthorizationInfoPlistKeyHealthUpdate];
    NSAssert(isHasHealthUpdatePlistKey, @"NSHealthUpdateUsageDescription not found in Info.plist.");
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        
        [self.healthStore requestAuthorizationToShareTypes:self.shareTypes readTypes:self.readTypes completion:^(BOOL success, NSError * _Nullable error) {
            [self safeAsyncWithCompletion:^{
                if (completion) {
                    completion(success);
                }
            }];
        }];
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - Getters
- (HKHealthStore *)healthStore {
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc] init];
    }
    return _healthStore;
}

@end
