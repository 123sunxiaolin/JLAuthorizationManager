//
//  JLBluetoothPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/30.
//

@import CoreBluetooth;
#import "JLBluetoothPermission.h"

@interface JLBluetoothPermission()<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centerManager;
@property (nonatomic, copy) JLAuthorizationCompletion completion;

@end

@implementation JLBluetoothPermission

+ (instancetype)instance {
    NSAssert(NO, @"please use 'sharedInstance' singleton method!");
    return nil;
}

+ (instancetype)sharedInstance {
    static JLBluetoothPermission *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLBluetoothPermission alloc] init];
    });
    return instance;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypeBluetooth;
}

- (JLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 10.0, *)) {
        switch (self.centerManager.state) {
            case CBManagerStateUnsupported:
            case CBManagerStatePoweredOff:
                return JLAuthorizationStatusDisabled;
                break;
            case CBManagerStateUnauthorized:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case CBManagerStateUnknown:
            case CBManagerStateResetting:
                return JLAuthorizationStatusNotDetermined;
                break;
            case CBManagerStatePoweredOn:
                return JLAuthorizationStatusAuthorized;
                break;
        }
    } else {
        return JLAuthorizationStatusDisabled;
    }
}

- (void)requestAuthorizationWithCompletion:(nonnull JLAuthorizationCompletion)completion {
    self.completion = completion;
    JLAuthorizationStatus status = [self authorizationStatus];
    if (completion) {
        completion(status == JLAuthorizationStatusAuthorized);
    }
}

#pragma mark - Getters
- (CBCentralManager *)centerManager {
    if (!_centerManager) {
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    }
    return _centerManager;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    
    if (self.completion) {
        if (@available(iOS 10.0, *)) {
            self.completion(central.state == CBManagerStatePoweredOn);
        } else {
            self.completion(NO);
        }
    }
}

@end
