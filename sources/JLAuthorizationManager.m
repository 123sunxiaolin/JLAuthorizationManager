//
//  JLAuthorizationManager.m
//  JLUtilsDemo
//
//  Created by perfect on 2017/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
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

#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)

@implementation JLAuthorizationManager

+ (JLAuthorizationManager *)defaultManager{
    static JLAuthorizationManager *authorizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizationManager = [[JLAuthorizationManager alloc] init];
    });
    return authorizationManager;
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
            
            
        default:
            break;
    }
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
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

@end
