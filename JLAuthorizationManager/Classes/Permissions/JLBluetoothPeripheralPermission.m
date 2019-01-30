//
//  JLBluetoothPeripheralPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/30.
//

@import CoreBluetooth;
#import "JLBluetoothPeripheralPermission.h"

@interface JLBluetoothPeripheralPermission()<CBPeripheralManagerDelegate>

@property (nonatomic, assign) BOOL isRequestedBluetooth;
/// wheather wait for user to enable or disable bluetooth access or not
@property (nonatomic, assign) BOOL waitingForBluetooth;
@property (nonatomic, strong) CBPeripheralManager *bluetoothManager;
@property (nonatomic, copy) JLAuthorizationCompletion completion;

@end
@implementation JLBluetoothPeripheralPermission

+ (instancetype)instance {
    NSAssert(NO, @"please use 'sharedInstance' singleton method!");
    return nil;
}

+ (instancetype)sharedInstance {
    static JLBluetoothPeripheralPermission *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JLBluetoothPeripheralPermission alloc] init];
    });
    return instance;
}

- (JLAuthorizationType)type {
    return JLAuthorizationTypePeripheralBluetooth;
}

- (JLAuthorizationStatus)authorizationStatus {
    
    if (!self.isRequestedBluetooth) {
        return JLAuthorizationStatusDisabled;
    }
    
    // start requesting ...
    [self startUpdateBluetoothStatus];
    
    if (@available(iOS 10.0, *)) {
        CBManagerState state = self.bluetoothManager.state;
        CBPeripheralManagerAuthorizationStatus status = CBPeripheralManager.authorizationStatus;
        switch (state) {
            case CBManagerStateUnsupported:
            case CBManagerStatePoweredOff:
                return JLAuthorizationStatusDisabled;
                break;
            case CBManagerStatePoweredOn: {
                switch (status) {
                    case CBPeripheralManagerAuthorizationStatusAuthorized:
                        return JLAuthorizationStatusAuthorized;
                        break;
                        
                    case CBPeripheralManagerAuthorizationStatusDenied:
                    case CBPeripheralManagerAuthorizationStatusRestricted:
                        return JLAuthorizationStatusUnAuthorized;
                        break;
                    case CBPeripheralManagerAuthorizationStatusNotDetermined:
                        return JLAuthorizationStatusNotDetermined;
                        break;
                }
            }
                break;
                
            case CBManagerStateUnauthorized:
                return JLAuthorizationStatusUnAuthorized;
                break;
                
            default:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
        
    } else {
        return JLAuthorizationStatusDisabled;
    }
}

- (void)requestAuthorizationWithCompletion:(nonnull JLAuthorizationCompletion)completion {
   
    if (@available(iOS 10.0, *)) {
        if (self.bluetoothManager.state != CBManagerStatePoweredOn) {
            return;
        }
        
        JLAuthorizationStatus status = [self authorizationStatus];
        if (status == JLAuthorizationStatusNotDetermined) {
            self.completion = completion;
            [self startUpdateBluetoothStatus];
        } else {
            if (completion) {
                completion(status == JLAuthorizationStatusAuthorized);
            }
        }
    } else {
        if (completion) {
            completion(false);
        }
    }
}

#pragma mark - Private
- (void)startUpdateBluetoothStatus {
    
    if (@available(iOS 10.0, *)) {
        if (!self.waitingForBluetooth
            && self.bluetoothManager.state == CBManagerStateUnknown) {
            [self.bluetoothManager startAdvertising:nil];
            [self.bluetoothManager stopAdvertising];
            self.waitingForBluetooth = NO;
            self.isRequestedBluetooth = YES;
        }
    }
}

#pragma mark - Getters/Setters
- (BOOL)isRequestedBluetooth {
    return [NSUserDefaults.standardUserDefaults boolForKey:JLAuthorizationRequestedBluetoothKey];
}

- (void)setIsRequestedBluetooth:(BOOL)isRequestedBluetooth {
    [NSUserDefaults.standardUserDefaults setBool:isRequestedBluetooth forKey:JLAuthorizationRequestedBluetoothKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}


- (CBPeripheralManager *)bluetoothManager {
    if (!_bluetoothManager) {
        _bluetoothManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                    queue:nil
                                                                  options:@{CBPeripheralManagerOptionShowPowerAlertKey: @NO}];
    }
    return _bluetoothManager;
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    self.waitingForBluetooth = NO;
    if (self.completion) {
        self.completion(CBPeripheralManager.authorizationStatus == CBPeripheralManagerAuthorizationStatusAuthorized);
    }
}

@end
