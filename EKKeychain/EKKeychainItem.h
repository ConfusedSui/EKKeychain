//
//  EKKeychainItem.h
//  EKKeychain
//
//  Created by lx on 2019/2/16.
//  Copyright © 2019年 ekkeychain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKKeychainItem : NSObject

- (EKKeychainItem *)initWithIdentifier:(NSString *)identifier
                           accessGroup:(NSString *_Nullable)accessGroup;

- (BOOL)setData:(NSData *)data
          error:(NSError **_Nullable)error;

- (NSData *)getData;

@end

NS_ASSUME_NONNULL_END
