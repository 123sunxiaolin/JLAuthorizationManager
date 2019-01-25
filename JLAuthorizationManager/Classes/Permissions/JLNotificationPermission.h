//
//  JLNotificationPermission.h
//  JLAuthorizationManager
//
//  Created by Jacklin on 2019/1/24.
//

#import "JLBasePermisssion.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLNotificationPermission : JLBasePermisssion

/**
 *  For iOS 10.0, async fetch notification permission.
 */
- (void)asyncFetchAuthorizedStatusWithCompletion:(void (^)(JLAuthorizationStatus status))completion;

@end

NS_ASSUME_NONNULL_END
