//
//  JLSinglePermissionViewController.m
//  JLAuthorizationManager_Example
//
//  Created by Jacklin on 2019/2/11.
//  Copyright © 2019年 401788217@qq.com. All rights reserved.
//

@import JLAuthorizationManager;

#import "JLSinglePermissionViewController.h"

@interface JLPermissionItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign)  JLAuthorizationType type;

+ (instancetype)createInstanceWithTitle:(NSString *)title type:(JLAuthorizationType)type;
- (instancetype)initWithTitle:(NSString *)title type:(JLAuthorizationType)type;

@end

@implementation JLPermissionItem

+ (instancetype)createInstanceWithTitle:(NSString *)title type:(JLAuthorizationType)type {
    return [[self alloc] initWithTitle:title type:type];
}

- (instancetype)initWithTitle:(NSString *)title type:(JLAuthorizationType)type {
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}
@end


@interface JLSinglePermissionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *permissionArray;
@property (nonatomic, strong) UITableView *authTableView;

@end

@implementation JLSinglePermissionViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单一权限测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.authTableView];
    
    [self loadPermissionsData];
}

#pragma mark - Private
- (void)loadPermissionsData {
    self.permissionArray = [NSMutableArray new];
    NSArray *types = @[@(JLAuthorizationTypePhotoLibrary),
                       @(JLAuthorizationTypeCellularNetWork),
                       @(JLAuthorizationTypeCamera),
                       @(JLAuthorizationTypeMicrophone),
                       @(JLAuthorizationTypeAddressBook),
                       @(JLAuthorizationTypeCalendar),
                       @(JLAuthorizationTypeReminder),
                       @(JLAuthorizationTypeNotification),
                       @(JLAuthorizationTypeMapAlways),
                       @(JLAuthorizationTypeMapWhenInUse),
                       @(JLAuthorizationTypeAppleMusic),
                       @(JLAuthorizationTypeSpeechRecognizer),
                       @(JLAuthorizationTypeSiri),
                       @(JLAuthorizationTypeBluetooth),
                       @(JLAuthorizationTypePeripheralBluetooth),
                       @(JLAuthorizationTypeHealth),
                       @(JLAuthorizationTypeMotion)];
    for (NSNumber *type in types) {
        JLAuthorizationType oneType = (JLAuthorizationType)type.integerValue;
        JLPermissionItem *item = [JLPermissionItem createInstanceWithTitle:[self titleWithType:oneType] type:oneType];
        [self.permissionArray addObject:item];
    }
    
    [self.authTableView reloadData];
}

- (NSString *)titleWithType:(JLAuthorizationType)type {
    switch (type) {
        case JLAuthorizationTypePhotoLibrary:
            return @"相册/PhotoLibrary";
            break;
        case JLAuthorizationTypeCellularNetWork:
            return @"蜂窝网络/Cellular Network";
            break;
        case JLAuthorizationTypeCamera:
            return @"相机/Camera";
            break;
        case JLAuthorizationTypeMicrophone:
            return @"麦克风/Audio";
            break;
        case JLAuthorizationTypeAddressBook:
            return @"通讯录/AddressBook";
            break;
        case JLAuthorizationTypeCalendar:
            return @"日历/Calendar";
            break;
        case JLAuthorizationTypeReminder:
            return @"提醒事项/Reminder";
            break;
        case JLAuthorizationTypeNotification:
            return @"通知/Notifications";
            break;
        case JLAuthorizationTypeMapAlways:
            return @"一直请求定位权限/RequestMapAlways";
            break;
        case JLAuthorizationTypeMapWhenInUse:
            return @"使用时请求定位权限/RequestWhenInUse";
            break;
        case JLAuthorizationTypeAppleMusic:
            return @"媒体资料库/AppleMusic";
            break;
        case JLAuthorizationTypeSpeechRecognizer:
            return @"语音识别/SpeechRecognizer";
            break;
        case JLAuthorizationTypeSiri:
            return @"Siri";
            break;
        case JLAuthorizationTypeBluetooth:
            return @"蓝牙共享/Bluetooth";
            break;
        case JLAuthorizationTypePeripheralBluetooth:
            return @"分机蓝牙共享/PeripheralBluetooth";
            break;
        case JLAuthorizationTypeHealth:
            return @"健康数据/HealthData";
            break;
        case JLAuthorizationTypeMotion:
            return @"活动与体能训练记录/MotionData";
            break;
            
        default:
            return @"其他";
            break;
    }
}

- (NSString *)authorizationWithStatus:(JLAuthorizationStatus)status {
    switch (status) {
        case JLAuthorizationStatusAuthorized:
            return @"已授权/Authorized";
            break;
            case JLAuthorizationStatusUnAuthorized:
            return @"未授权/UnAuthorized";
            break;
            case JLAuthorizationStatusNotDetermined:
            return @"不确定/NotDetermined";
            case JLAuthorizationStatusDisabled:
            return @"不支持/UnSupported";
            
        default:
            return @"其他/Other";
            break;
    }
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
#pragma mark - Delegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.permissionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"PermissionManageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    JLPermissionItem *item = self.permissionArray[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JLPermissionItem *item = self.permissionArray[indexPath.row];
    switch (item.type) {
        case JLAuthorizationTypePhotoLibrary: {
            JLPhotosPermission *permission = [JLPhotosPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeCellularNetWork: {
            JLCellularNetWorkPermission *permission = [JLCellularNetWorkPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeCamera: {
            JLCameraPermission *permission = [JLCameraPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeMicrophone: {
            JLMicrophonePermission *permission = [JLMicrophonePermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeAddressBook: {
            JLContactPermission *permission = [JLContactPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeCalendar: {
            JLCalendarPermission *permission = [JLCalendarPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeReminder: {
            JLReminderPermission *permission = [JLReminderPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeNotification: {
            JLNotificationPermission *permission = [JLNotificationPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission asyncFetchAuthorizedStatusWithCompletion:^(JLAuthorizationStatus status) {
                NSLog(@"async fetch current authoriazation status:%@", [self authorizationWithStatus:status]);
            }];
            
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeMapAlways: {
            JLLocationAlwaysPermission *permission = [JLLocationAlwaysPermission sharedInstance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeMapWhenInUse: {
            JLLocationInUsePermission *permission = [JLLocationInUsePermission sharedInstance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeAppleMusic: {
            JLAppleMusicPermission *permission = [JLAppleMusicPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeSpeechRecognizer: {
            JLSpeechRecognizerPermission *permission = [JLSpeechRecognizerPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeSiri: {
            JLSiriPermission *permission = [JLSiriPermission instance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeBluetooth: {
            JLBluetoothPermission *permission = [JLBluetoothPermission sharedInstance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypePeripheralBluetooth: {
            JLBluetoothPeripheralPermission *permission = [JLBluetoothPeripheralPermission sharedInstance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
        case JLAuthorizationTypeHealth: {
            HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            HKObjectType *type1 = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            NSSet *shareSet = [NSSet setWithObjects:type, type1, nil];
            JLHealthPermission *permission = [[JLHealthPermission alloc] initWithShareType:shareSet readTypes:shareSet];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }

            break;
        case JLAuthorizationTypeMotion: {
            JLMotionPermission *permission = [JLMotionPermission sharedInstance];
            NSLog(@"current authoriazation status:%@", [self authorizationWithStatus:permission.authorizationStatus]);
            NSLog(@"%@添加权限Plist描述", permission.hasSpecificPermissionKeyFromInfoPlist ? @"是" : @"没有");
            [permission requestAuthorizationWithCompletion:^(BOOL granted) {
                NSLog(@"%@ : %@", [self titleWithType:permission.type], granted ? @"已授权" : @"未授权");
            }];
        }
            break;
            
        default: {
            NSLog(@"其他/Other ~~");
        }
            break;
    }
}

@end
