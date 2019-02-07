//
//  JLViewController.m
//  JLAuthorizationManager
//
//  Created by 401788217@qq.com on 01/24/2019.
//  Copyright (c) 2019 401788217@qq.com. All rights reserved.
//

@import HealthKit;
@import Accounts;
@import JLAuthorizationManager;

#import "JLViewController.h"
#import "JLSinglePermissionViewController.h"


@interface JLViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *_authDataArray;
    NSArray *_authTypeArray;
}

@property (nonatomic, strong) UITableView *authTableView;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) UIButton *authorizationButton;

@end

@implementation JLViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    
    self.title = @"权限集锦";
    _authDataArray = @[@"相册/PhotoLibrary",
                       @"蜂窝网络/Cellular Network",
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
                       @"蓝牙共享/Bluetooth",
                       @"推特/Twitter",
                       @"脸书/Facebook",
                       @"新浪微博/SinaWeibo",
                       @"腾讯微博/TencentWeibo",
                       @"通知/Notifications"];
    
    _authTypeArray = @[@(JLAuthorizationTypePhotoLibrary),
                       @(JLAuthorizationTypeCellularNetWork),
                       @(JLAuthorizationTypeCamera),
                       @(JLAuthorizationTypeMicrophone),
                       @(JLAuthorizationTypeAddressBook),
                       @(JLAuthorizationTypeCalendar),
                       @(JLAuthorizationTypeReminder)];
    
    [self.view addSubview:self.authTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
- (void)authorizationButtonClick:(id)sender {
    JLSinglePermissionViewController *singleVC = [[JLSinglePermissionViewController alloc] init];
    [self.navigationController pushViewController:singleVC animated:YES];
}

#pragma mark - Private
#pragma mark - Getters
- (UIBarButtonItem *)rightButtonItem {
    if (!_rightButtonItem) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.authorizationButton];
    }
    return _rightButtonItem;
}

- (UIButton *)authorizationButton {
    if (!_authorizationButton) {
        _authorizationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authorizationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_authorizationButton setTitle:@"权限2" forState:UIControlStateNormal];
        [_authorizationButton addTarget:self
                                 action:@selector(authorizationButtonClick:)
                       forControlEvents:UIControlEventTouchUpInside];
    }
    return _authorizationButton;
}

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
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeCellularNetWork authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 2:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeCamera authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
        }
            break;
        case 3:{
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeMicrophone authorizedHandler:^{
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
        case 14:{
            [[JLAuthorizationManager defaultManager] JL_requestAccountAuthorizationWithAuthorizationType:JLAuthorizationTypeTwitter options:nil authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } errorHandler:^(NSError *error) {
                NSLog(@"error:%@", error);
            }];
        }
            break;
        case 15:{
            NSDictionary *options = @{ ACFacebookAppIdKey: @"MY_CODE",
                                       ACFacebookPermissionsKey: @[@"email", @"user_about_me"],
                                       ACFacebookAudienceKey: ACFacebookAudienceFriends };
            [[JLAuthorizationManager defaultManager] JL_requestAccountAuthorizationWithAuthorizationType:JLAuthorizationTypeFacebook options:options authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }errorHandler:^(NSError *error) {
                NSLog(@"error:%@", error);
            }];
        }
            break;
        case 16:{
            [[JLAuthorizationManager defaultManager] JL_requestAccountAuthorizationWithAuthorizationType:JLAuthorizationTypeSinaWeibo options:nil authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }errorHandler:^(NSError *error) {
                NSLog(@"error:%@", error);
            }];
        }
            break;
        case 17:{
            NSDictionary *options = @{ACTencentWeiboAppIdKey: @"123"};
            [[JLAuthorizationManager defaultManager] JL_requestAccountAuthorizationWithAuthorizationType:JLAuthorizationTypeTencentWeibo options:options authorizedHandler:^{
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }errorHandler:^(NSError *error) {
                NSLog(@"error:%@", error);
            }];
        }
            break;
        case 18: {
            [[JLAuthorizationManager defaultManager] JL_requestAuthorizationWithAuthorizationType:JLAuthorizationTypeNotification authorizedHandler:^{
                
                NSLog(@"Has granted:%@", _authDataArray[indexPath.row]);
                
            } unAuthorizedHandler:^{
                NSLog(@"Not granted:%@", _authDataArray[indexPath.row]);
            }];
            
        }
            
        default:
            break;
    }
}


@end
