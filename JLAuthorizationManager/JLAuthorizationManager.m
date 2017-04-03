//
//  JLAuthorizationManager.m
//  JLAuthorizationManager<https://github.com/123sunxiaolin/JLAuthorizationManager.git>
//
//  <Wechat Public:iOSDevSkills>
//  Created by Jacklin on 2017/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "JLAuthorizationManager.h"
@import UIKit;
@import Photos;
@import AssetsLibrary;
@import CoreTelephony;
@import AVFoundation;
@import AddressBook;
@import Contacts;
@import EventKit;
@import CoreLocation;
@import MediaPlayer;
@import Speech;//Xcode 8.0 or later
@import HealthKit;
@import Intents;
@import CoreBluetooth;

#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define IOS10 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)

@interface JLAuthorizationHealthManager : NSObject

- (void)JL_requestHealthAuthorizationWithShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                                          readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                                  authorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler;
@end

@implementation JLAuthorizationHealthManager

- (void)JL_requestHealthAuthorizationWithShareTypes:(nullable NSSet<HKSampleType *> *)typesToShare
                                          readTypes:(nullable NSSet<HKObjectType *> *)typesToRead
                                  authorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler{

    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
   __block BOOL shouldRequestAccess = NO;
    if (typesToShare.count > 0) {
        
        [typesToShare enumerateObjectsUsingBlock:^(HKObjectType * _Nonnull type, BOOL * _Nonnull stop) {
            HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
            if (authStatus == HKAuthorizationStatusNotDetermined) {
                shouldRequestAccess = YES;
                *stop = YES;
            }
        }];
        
    }else{
        if (typesToRead.count > 0) {
            
            [typesToRead enumerateObjectsUsingBlock:^(HKObjectType * _Nonnull type, BOOL * _Nonnull stop) {
                HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
                if (authStatus == HKAuthorizationStatusNotDetermined) {
                    shouldRequestAccess = YES;
                    *stop = YES;
                }
            }];
            
            
        }else{
            NSAssert(!(typesToRead.count > 0), @"待请求的权限类型数组不能为空");
        }
    }
    
    if (shouldRequestAccess) {
        [healthStore requestAuthorizationToShareTypes:typesToShare readTypes:typesToRead completion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
    }else{
       __block BOOL isAuthorized = NO;
        if (typesToShare.count > 0) {
            [typesToShare enumerateObjectsUsingBlock:^(HKSampleType * _Nonnull type, BOOL * _Nonnull stop) {
                HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
                if (authStatus == HKAuthorizationStatusNotDetermined
                    || authStatus == HKAuthorizationStatusSharingDenied) {
                    isAuthorized = NO;
                }else{
                    isAuthorized = YES;
                }
            }];
        }else{
            if (typesToRead.count > 0) {
                
                [typesToRead enumerateObjectsUsingBlock:^(HKObjectType * _Nonnull type, BOOL * _Nonnull stop) {
                    HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
                    if (authStatus == HKAuthorizationStatusNotDetermined
                        || authStatus == HKAuthorizationStatusSharingDenied) {
                        isAuthorized = NO;
                    }else{
                        isAuthorized = YES;
                    }
                }];
                
            }else{
                NSAssert(!(typesToRead.count > 0), @"待请求的权限类型数组不能为空");
            }
        }
        
        if (isAuthorized) {
            authorizedHandler ? authorizedHandler() : nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler() : nil;
        }
        
    }
    
}
@end

@interface JLAuthorizationManager ()<CLLocationManagerDelegate>

@property (nonatomic, copy) void (^mapAlwaysAuthorizedHandler)();
@property (nonatomic, copy) void (^mapAlwaysUnAuthorizedHandler)();
@property (nonatomic, copy) void (^mapWhenInUseAuthorizedHandler)();
@property (nonatomic, copy) void (^mapWhenInUseUnAuthorizedHandler)();

/**
 地理位置管理对象
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL isRequestMapAlways;
@end
@implementation JLAuthorizationManager

+ (JLAuthorizationManager *)defaultManager{
    static JLAuthorizationManager *authorizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizationManager = [[JLAuthorizationManager alloc] init];
    });
    return authorizationManager;
}

- (instancetype)init{
    if (self = [super init]) {
        _isRequestMapAlways = NO;
    }
    return self;
}

- (void)JL_requestAuthorizationWithAuthorizationType:(JLAuthorizationType)authorizationType
                                   authorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    switch (authorizationType) {
        case JLAuthorizationTypePhotoLibrary:
            [self p_requestPhotoLibraryAccessWithAuthorizedHandler:authorizedHandler
                                               unAuthorizedHandler:unAuthorizedHandler];
            break;
            
        case JLAuthorizationTypeNetWork:
            [self p_requestNetworkAccessWithAuthorizedHandler:authorizedHandler
                                          unAuthorizedHandler:unAuthorizedHandler];
            break;
        
        case JLAuthorizationTypeVideo:
            [self p_requestCameraAccessWithAuthorizedHandler:authorizedHandler
                                         unAuthorizedHandler:unAuthorizedHandler];
            break;
            
        case JLAuthorizationTypeAudio:
            [self p_requestAudioAccessWithAuthorizedHandler:authorizedHandler
                                        unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeAddressBook:
            [self p_requestAddressBookAccessWithAuthorizedHandler:authorizedHandler
                                        unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeCalendar:
            [self p_requestCalendarAccessWithAuthorizedHandler:authorizedHandler
                                           unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeReminder:
            [self p_requestReminderAccessWithAuthorizedHandler:authorizedHandler
                                           unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeMapAlways:
            [self p_requestMapAlwaysAccessWithAuthorizedHandler:authorizedHandler
                                            unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeMapWhenInUse:
            [self p_requestMapWhenInUseAccessWithAuthorizedHandler:authorizedHandler
                                               unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeAppleMusic:
            [self p_requestAppleMusicAccessWithAuthorizedHandler:authorizedHandler
                                             unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeSpeechRecognizer:
            [self p_requestSpeechRecognizerAccessWithAuthorizedHandler:authorizedHandler
                                                   unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeSiri:
            [self p_requestSiriAccessWithAuthorizedHandler:authorizedHandler
                                       unAuthorizedHandler:unAuthorizedHandler];
            break;
        case JLAuthorizationTypeBluetooth:
            [self p_requestBluetoothAccessWithAuthorizedHandler:authorizedHandler
                                            unAuthorizedHandler:unAuthorizedHandler];
            break;
            
        default:
            NSAssert(!1, @"该方法暂不提供");
            
            break;
    }
}

- (void)JL_requestHealthAuthorizationWithShareTypes:(NSSet*)typesToShare
                                          readTypes:(NSSet*)typesToRead
                                  authorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    JLAuthorizationHealthManager *healthManager = [JLAuthorizationHealthManager new];
    [healthManager JL_requestHealthAuthorizationWithShareTypes:typesToShare
                                                     readTypes:typesToRead
                                             authorizedHandler:authorizedHandler
                                           unAuthorizedHandler:unAuthorizedHandler];
    
    
}

#pragma mark - Photo Library
- (void)p_requestPhotoLibraryAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                     unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    if (IOS8) {
        //used `PHPhotoLibrary`
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorizedHandler ? authorizedHandler(): nil;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        unAuthorizedHandler ? unAuthorizedHandler(): nil;
                    });
                }
            }];
        }else if (authStatus == PHAuthorizationStatusAuthorized){
            authorizedHandler ? authorizedHandler(): nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler(): nil;
        }
        
    }else{
        //used `AssetsLibrary`
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusAuthorized) {
            authorizedHandler ? authorizedHandler() : nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler() : nil;
        }
#pragma clang diagnostic pop
    }
}

#pragma mark - Network
- (void)p_requestNetworkAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    CTCellularDataRestrictedState authState = cellularData.restrictedState;
    if (authState == kCTCellularDataRestrictedStateUnknown) {
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
            if (state == kCTCellularDataNotRestricted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        };
    }else if (authState == kCTCellularDataNotRestricted){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - AvcaptureMedia
- (void)p_requestCameraAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                               unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
        
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

- (void)p_requestAudioAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                              unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
        
    }else if(authStatus == AVAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - AddressBook
- (void)p_requestAddressBookAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                              unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    if (IOS9) {
        
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorizedHandler ? authorizedHandler() : nil;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        unAuthorizedHandler ? unAuthorizedHandler() : nil;
                    });
                }
            }];
        }else if (authStatus == CNAuthorizationStatusAuthorized){
             authorizedHandler ? authorizedHandler() : nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler() : nil;
        }
        
        
    }else{
        //iOS9.0 eariler

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorizedHandler ? authorizedHandler() : nil;
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        unAuthorizedHandler ? unAuthorizedHandler() : nil;
                    });
                }
            });
            
            if (addressBook) {
                CFRelease(addressBook);
            }
           
        }else if (authStatus == kABAuthorizationStatusAuthorized){
            authorizedHandler ? authorizedHandler() : nil;
        }else{
            unAuthorizedHandler ? unAuthorizedHandler() : nil;
        }
#pragma clang diagnostic pop
        
    }
}

#pragma mark - Calendar
- (void)p_requestCalendarAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (authStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
    }else if (authStatus == EKAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - Reminder
- (void)p_requestReminderAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                 unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (authStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
    }else if (authStatus == EKAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - Map

- (void)p_requestMapAlwaysAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                  unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    if (![CLLocationManager locationServicesEnabled]) {
        NSAssert(![CLLocationManager locationServicesEnabled], @"Location service enabled failed");
        return;
    }
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        
        self.mapAlwaysAuthorizedHandler = authorizedHandler;
        self.mapAlwaysUnAuthorizedHandler = unAuthorizedHandler;
        [self.locationManager requestAlwaysAuthorization];
        self.isRequestMapAlways = YES;
        
    }else if (authStatus == kCLAuthorizationStatusAuthorizedAlways){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

- (void)p_requestMapWhenInUseAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                     unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    if (![CLLocationManager locationServicesEnabled]) {
        NSAssert(![CLLocationManager locationServicesEnabled], @"Location service enabled failed");
        return;
    }
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusNotDetermined) {
        
        self.mapWhenInUseAuthorizedHandler = authorizedHandler;
        self.mapAlwaysUnAuthorizedHandler = unAuthorizedHandler;
        [self.locationManager requestWhenInUseAuthorization];
        self.isRequestMapAlways = NO;
        
    }else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}
#pragma mark - Apple Music
- (void)p_requestAppleMusicAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                   unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
    }else if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized){
         authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - SpeechRecognizer
- (void)p_requestSpeechRecognizerAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                         unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    
    /*SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];
    if (authStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
        
    }else if (authStatus == SFSpeechRecognizerAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }*/
}

#pragma mark - Health
- (void)p_requestHealthAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                               unAuthorizedHandler:(void(^)())unAuthorizedHandler{
}
#pragma mark - Siri
- (void)p_requestSiriAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                             unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    if (!IOS10) {
        NSAssert(!IOS10, @"This method must used in iOS 10.0 or later/该方法必须在iOS10.0或以上版本使用");
        authorizedHandler = nil;
        unAuthorizedHandler = nil;
        return;
    }
    
    INSiriAuthorizationStatus authStatus = [INPreferences siriAuthorizationStatus];
    if (authStatus == INSiriAuthorizationStatusNotDetermined) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            if (status == INSiriAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     authorizedHandler ? authorizedHandler() : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    unAuthorizedHandler ? unAuthorizedHandler() : nil;
                });
            }
        }];
        
    }else if (authStatus == INSiriAuthorizationStatusAuthorized){
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - Bluetooth
- (void)p_requestBluetoothAccessWithAuthorizedHandler:(void(^)())authorizedHandler
                                  unAuthorizedHandler:(void(^)())unAuthorizedHandler{
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    if (authStatus == CBPeripheralManagerAuthorizationStatusAuthorized) {
        authorizedHandler ? authorizedHandler() : nil;
    }else{
        unAuthorizedHandler ? unAuthorizedHandler() : nil;
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        self.mapAlwaysAuthorizedHandler ? self.mapAlwaysAuthorizedHandler() : nil;
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
        self.mapWhenInUseAuthorizedHandler ? self.mapWhenInUseAuthorizedHandler() : nil;
    }else{
        if (self.isRequestMapAlways) {
            self.mapAlwaysUnAuthorizedHandler ? self.mapAlwaysUnAuthorizedHandler() : nil;
        }else{
             self.mapWhenInUseUnAuthorizedHandler ? self.mapWhenInUseUnAuthorizedHandler() : nil;
        }
    }
}

@end
