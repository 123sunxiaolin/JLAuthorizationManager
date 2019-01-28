//
//  JLHealthPermission.h
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/28.
//

@import HealthKit;
#import "JLBasePermisssion.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLHealthPermission : JLBasePermisssion

@property (nonatomic, strong) NSSet <HKSampleType *> *shareTypes;
@property (nonatomic, strong) NSSet <HKObjectType *> *readTypes;

- (instancetype)initWithShareType:(NSSet <HKSampleType *> *)shareTypes
                        readTypes:(NSSet <HKSampleType *> *)readTypes;

@end

NS_ASSUME_NONNULL_END
