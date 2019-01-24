//
//  JLContactPermission.m
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

@import AddressBook;
@import Contacts;
#import "JLContactPermission.h"

@implementation JLContactPermission

- (JLAuthorizationType)type {
    return JLAuthorizationTypeAddressBook;
}

- (JLAuthorizationStatus)authorizationStatus {
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (authStatus) {
            case CNAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case CNAuthorizationStatusRestricted:
            case CNAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case CNAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
    } else {
        //iOS9.0 eariler
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        switch (authStatus) {
            case kABAuthorizationStatusAuthorized:
                return JLAuthorizationStatusAuthorized;
                break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied:
                return JLAuthorizationStatusUnAuthorized;
                break;
            case kABAuthorizationStatusNotDetermined:
                return JLAuthorizationStatusNotDetermined;
                break;
        }
        
#pragma clang diagnostic pop
        
    }
}

- (void)requestAuthorizationWithCompletion:(JLAuthorizationCompletion)completion {
    
    JLAuthorizationStatus status = [self authorizationStatus];
    if (status == JLAuthorizationStatusNotDetermined) {
        
        if (@available(iOS 9.0, *)) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(granted);
                    }
                }];
                
            }];
        } else {
            //iOS9.0 eariler
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            ABAddressBookRef addressBook = ABAddressBookCreate();
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                [self safeAsyncWithCompletion:^{
                    if (completion) {
                        completion(granted);
                    }
                }];
            });
            
#pragma clang diagnostic pop
        }
        
    } else {
        if (completion) {
            completion(status == JLAuthorizationStatusAuthorized);
        }
    }
}

@end
