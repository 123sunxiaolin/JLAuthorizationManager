//
//  JLMotionPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/28.
//

@import CoreMotion;
#import "JLMotionPermission.h"

@interface JLMotionPermission()

@property (nonatomic, assign) BOOL isRequestedMotion;
@property (nonatomic, copy) JLAuthorizationCompletion completion;
@property (nonatomic, strong) CMMotionActivityManager *motionManager;
@property (nonatomic, assign) JLAuthorizationStatus motionPermissionStatus;

@end
@implementation JLMotionPermission

+ (instancetype)instance {
    NSAssert(NO, @"please use 'sharedInstance' singleton method!");
    return nil;
}

+ (instancetype)sharedInstance {
    static JLMotionPermission *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLMotionPermission alloc] init];
    });
    return instance;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypeMotion;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (!CMMotionActivityManager.isActivityAvailable) {
        return JLAuthorizationStatusDisabled;
    }
    
    if (@available(iOS 11.0, *)) {
        
        CMAuthorizationStatus status = CMMotionActivityManager.authorizationStatus;
        switch (status) {
            case CMAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case  CMAuthorizationStatusDenied:
            case  CMAuthorizationStatusRestricted:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case CMAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
        }
        
    } else {
        if (self.isRequestedMotion) {
            [self startUpdateMotionStatus];
        }
        return self.motionPermissionStatus;
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        self.completion = completion;
        [self startUpdateMotionStatus];
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

#pragma mark - Private
- (void)startUpdateMotionStatus {
    JLAuthorizationStatus tempStatus = self.motionPermissionStatus;
    __weak typeof(self) weakSelf = self;
    [self requestMotionPermissionWithCompletion:^(JLAuthorizationStatus status) {
        weakSelf.motionPermissionStatus = status;
        if (tempStatus != status) {
            if (weakSelf.completion) {
                weakSelf.completion(status == JLAuthorizationStatusAuthorized);
            }
        }
    }];
}

- (void)requestMotionPermissionWithCompletion:(void (^)(JLAuthorizationStatus status))completion {
    
    NSDate *date = [NSDate date];
    __weak typeof(self) weakSelf = self;
    [self.motionManager queryActivityStartingFromDate:date toDate:date toQueue:NSOperationQueue.mainQueue withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
        
        [weakSelf.motionManager stopActivityUpdates];
        JLAuthorizationStatus status;
        if (error) {
            switch (error.code) {
                case CMErrorMotionActivityNotAuthorized:
                    status = JLAuthorizationStatusUnAuthorized;
                    break;
                case CMErrorMotionActivityNotAvailable:
                    status = JLAuthorizationStatusDisabled;
                    break;
                    
                default:
                    status = JLAuthorizationStatusUnAuthorized;
                    break;
            }
        } else {
            status = JLAuthorizationStatusAuthorized;
        }
        
        [weakSelf safeAsyncWithCompletion:^{
            if (completion) {
                completion(status);
            }
        }];
        
    }];
    
}

#pragma mark - Getters/Setters
- (BOOL)isRequestedMotion {
    return [NSUserDefaults.standardUserDefaults boolForKey:JLAuthorizationRequestedMotionKey];
}

- (void)setIsRequestedMotion:(BOOL)isRequestedMotion {
    [NSUserDefaults.standardUserDefaults setBool:isRequestedMotion forKey:JLAuthorizationRequestedMotionKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (CMMotionActivityManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionActivityManager alloc] init];
    }
    return _motionManager;
}

@end
