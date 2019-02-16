//
//  EKKeychain.h
//  EKKeychain
//
//  Created by lx on 2019/2/16.
//  Copyright © 2019年 ekkeychain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EKKeychain : NSObject

- (EKKeychain *)initWithGroup:(NSString *)group;

- (void)setString:(NSString *)string forKey:(NSString *)key;

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;

- (NSDictionary *)dictionaryForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
