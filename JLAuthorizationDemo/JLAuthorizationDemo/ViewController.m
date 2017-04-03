//
//  ViewController.m
//  JLAuthorizationDemo
//
//  Created by Sunxiaolin on 17/3/27.
//  Copyright © 2017年 com.jack.lin. All rights reserved.
//

#import "ViewController.h"
#import "JLAuthorizationManager.h"
@import HealthKit;

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_authDataArray;
    NSArray *_authTypeArray;
}

@property (nonatomic, strong) UITableView *authTableView;

@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"权限集锦";
    _authDataArray = @[@"相册/PhotoLibrary",
                       @"网络/Cellular Network",
                       @"相机/Camera",
                       @"麦克风/Audio",
                       @"通讯录/AddressBook",
                       @"日历/Calendar",
                       @"提醒事项/Reminder",
                       @"一直请求定位权限/RequestMapAlways",
                       @"使用时请求定位权限/RequestWhenInUse",
                       @"媒体资料库/AppleMusic",
                       @"语音识别/SpeechRecognizer",
                       @"Siri",
                       @"健康数据/HealthData",
                       @"蓝牙共享/Bluetooth"];
    
    _authTypeArray = @[@(JLAuthorizationTypePhotoLibrary),
                       @(JLAuthorizationTypeNetWork),
                       @(JLAuthorizationTypeVideo),
                       @(JLAuthorizationTypeAudio),
                       @(JLAuthorizationTypeAddressBook),
                       @(JLAuthorizationTypeCalendar),
                       @(JLAuthorizationTypeReminder)];
    
    [self.view addSubview:self.authTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([HKHealthStore isHealthDataAvailable]) {
        NSLog(@"support Motion");
    }
//    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
//    HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//    HKObjectType *type1 = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//    HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
//    if (authStatus == HKAuthorizationStatusNotDetermined) {
//        /*[healthStore handleAuthorizationForExtensionWithCompletion:^(BOOL success, NSError * _Nullable error) {
//            if (success) {
//                NSLog(@"thread:%@", [NSThread currentThread]);
//            }else{
//                NSLog(@"thread:%@", [NSThread currentThread]);
//                NSLog(@"789");
//                if (error) {
//                    NSLog(@"error:%@", error.description);
//                }
//            }
//            
//
//        }];*/
//        [healthStore requestAuthorizationToShareTypes:[NSSet setWithObjects:type, type1, nil] readTypes:[NSSet setWithObjects:type, type1, nil]completion:^(BOOL success, NSError * _Nullable error) {
//            if (success) {
//                NSLog(@"thread:%@", [NSThread currentThread]);
//            }else{
//                NSLog(@"thread:%@", [NSThread currentThread]);
//                NSLog(@"789");
//                if (error) {
//                    NSLog(@"error:%@", error.description);
//                }
//            }
//                    }];
//    }else if (authStatus == HKAuthorizationStatusSharingAuthorized){
//        NSLog(@"456");
//    }else{
//        NSLog(@"123");
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters
- (UITableView *)authTableView{
    if (!_authTableView) {
        _authTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _authTableView.dataSource = self;
        _authTableView.delegate = self;
        _authTableView.tableFooterView = [UIView new];
    }
    return _authTableView;
}
#pragma mark - Action
#pragma mark - Private
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _authDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"AuthorizationManageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _authDataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypePhotoLibrary authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 1:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeNetWork authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 2:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeVideo authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 3:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeAudio authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 4:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeAddressBook authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 5:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeCalendar authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 6:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeReminder authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 7:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeMapAlways authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 8:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeMapWhenInUse authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 9:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeAppleMusic authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 10:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeSpeechRecognizer authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 11:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeSiri authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 12:{
//            HKHealthStore *healthStore = [[HKHealthStore alloc] init];
//            HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
//            HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:type];
//            if (authStatus == HKAuthorizationStatusNotDetermined) {
//                [healthStore handleAuthorizationForExtensionWithCompletion:^(BOOL success, NSError * _Nullable error) {
//                    if (success) {
//                        NSLog(@"thread:%@", [NSThread currentThread]);
//                    }else{
//                        NSLog(@"thread:%@", [NSThread currentThread]);
//                        NSLog(@"789");
//                        if (error) {
//                            NSLog(@"error:%@", error.description);
//                        }
//                    }
//                    
//                    
//                }];
//            }
            HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            HKObjectType *type1 = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            NSSet *shareSet = [NSSet setWithObjects:type, type1, nil];
            [[JLAuthorizationManager defaultManager] JL_requestHealthAuthorizationWithShareTypes:shareSet readTypes:shareSet authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                 NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
            
        }
            break;
        case 13:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeBluetooth authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
            
            
        default:
            break;
    }
}

@end
