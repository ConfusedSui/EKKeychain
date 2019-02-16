//
//  EKKeychain.m
//  EKKeychain
//
//  Created by lx on 2019/2/16.
//  Copyright © 2019年 ekkeychain. All rights reserved.
//

#import "EKKeychain.h"
#import "EKKeychainItem.h"

@interface EKKeychain()
@property (nonatomic, copy)NSString *group;
@property (nonatomic, strong)NSMutableDictionary *itemDict;
@end

@implementation EKKeychain

- (EKKeychain *)initWithGroup:(NSString *)group {
    self = [super init];
    
    if(self) {
        self.group = group;
    }
    
    return self;
}

- (void)setString:(NSString *)string forKey:(NSString *)key {
    NSData* data=[string dataUsingEncoding:NSUTF8StringEncoding];
    
    [self setData:data forKey:key];
}

- (void)setDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    [self setData:data forKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    NSString *string = nil;
    
    if(data) {
        string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return string;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    NSData *data = [self dataForKey:key];
    NSDictionary *dict = nil;
    
    if(data) {
        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    
    return dict;
}

#pragma mark - Private

- (void)setData:(NSData *)data forKey:(NSString *)key {
    EKKeychainItem *item = [self.itemDict objectForKey:key];
    
    if(!item) {
        item = [[EKKeychainItem alloc]initWithIdentifier:key accessGroup:self.group];
        [self.itemDict setObject:item forKey:key];
    }
    
    [item setData:data error:nil];
}

- (NSData *)dataForKey:(NSString *)key {
    EKKeychainItem *item = [self.itemDict objectForKey:key];
    
    if(!item) {
        item = [[EKKeychainItem alloc]initWithIdentifier:key accessGroup:self.group];
        [self.itemDict setObject:item forKey:key];
    }
    
    return [item getData];
}

- (NSMutableDictionary *)itemDict {
    if(_itemDict == nil) {
        _itemDict = [NSMutableDictionary dictionary];
    }
    
    return _itemDict;
}

@end
