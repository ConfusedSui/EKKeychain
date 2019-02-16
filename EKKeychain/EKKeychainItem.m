//
//  EKKeychainItem.m
//  EKKeychain
//
//  Created by lx on 2019/2/16.
//  Copyright © 2019年 ekkeychain. All rights reserved.
//

#import "EKKeychainItem.h"
#import <Security/Security.h>

@interface EKKeychainItem()
@property (nonatomic, strong)NSMutableDictionary *keychainItemData;
@property (nonatomic, strong)NSMutableDictionary *genericDict;
@end

@implementation EKKeychainItem

- (EKKeychainItem *)initWithIdentifier:(NSString *)identifier
                           accessGroup:(NSString * _Nullable)accessGroup {
    self = [super init];
    
    if(self) {
        self.genericDict = [NSMutableDictionary dictionary];
        self.keychainItemData = [NSMutableDictionary dictionary];
        
        [self.genericDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [self.genericDict setObject:identifier forKey:(id)kSecAttrGeneric];
        
        if(accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
            /*
             * Ignore the access group if running on the iPhone simulator.
             */
#else
            [self.genericDict setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
        }
        
        [self.genericDict setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        //        [self.genericDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
        [self.genericDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        
        NSDictionary *tempDict = [self.genericDict copy];
        CFTypeRef result = nil;
        
        if ((SecItemCopyMatching((__bridge CFDictionaryRef)tempDict, &result) == noErr)) {
            self.keychainItemData = [self secItemWithDict:(__bridge_transfer NSDictionary *)result];
            
            [self.keychainItemData setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
            [self.keychainItemData setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        }else {
            [self resetKeychainItem];
            
            [self.keychainItemData setObject:identifier forKey:(id)kSecAttrGeneric];
            [self.keychainItemData setObject:identifier forKey:(id)kSecAttrAccount];
            
            if(accessGroup != nil) {
#if TARGET_IPHONE_SIMULATOR
                /*
                 * Ignore the access group if running on the iPhone simulator.
                 */
#else
                [self.keychainItemData setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
            }
        }
    }
    
    return self;
}

- (BOOL)setData:(NSData *)data
          error:(NSError * _Nullable __autoreleasing *)error {
    if(!data) {
        *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        return NO;
    }
    
    NSData *currentData = [self.keychainItemData objectForKey:(id)kSecValueData];
    
    if([currentData isEqual:data]) {
        return YES;
    }
    
    [self.keychainItemData setObject:data forKey:(id)kSecValueData];
    [self writeToKeychain];
    
    return YES;
}

- (NSData *)getData {
    NSData *data = [self.keychainItemData objectForKey:(id)kSecValueData];
    
    if(data.length <= 0) {
        return nil;
    }
    
    return data;
}

#pragma mark - Private

- (NSMutableDictionary *)secItemWithDict:(NSDictionary *)dict {
    NSMutableDictionary *resDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [resDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [resDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    CFTypeRef resData = nil;
    if (SecItemCopyMatching((CFDictionaryRef)resDict, &resData) == noErr) {
        NSData *data = (__bridge_transfer NSData *)resData;
        [resDict removeObjectForKey:(id)kSecReturnData];
        
        [resDict setObject:data forKey:(id)kSecValueData];
    }
    
    return resDict;
}

- (void)writeToKeychain {
    CFTypeRef attributes = nil;
    NSMutableDictionary *updateItem = nil;
    OSStatus result;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)self.genericDict, (CFTypeRef *)&attributes) == noErr)
    {
        updateItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary *)attributes];
        [updateItem setObject:[self.genericDict objectForKey:(id)kSecClass] forKey:(id)kSecClass];
        
        NSMutableDictionary *tempCheck = [self.keychainItemData mutableCopy];
        
        [tempCheck removeObjectForKey:(id)kSecClass];
        [tempCheck removeObjectForKey:(id)kSecReturnData];
        
#if TARGET_IPHONE_SIMULATOR
        [tempCheck removeObjectForKey:(id)kSecAttrAccessGroup];
#endif
        result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef)tempCheck);
        NSAssert( result == noErr, @"Couldn't update the Keychain Item." );
    }
    else
    {
        // No previous item found; add the new one.
        result = SecItemAdd((CFDictionaryRef)[self secItemWithDict:self.keychainItemData], NULL);
        NSAssert( result == noErr, @"Couldn't add the Keychain Item." );
    }
}

- (void)resetKeychainItem {
    // Default attributes for keychain item.
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrAccount];
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrLabel];
    [self.keychainItemData setObject:@"" forKey:(id)kSecAttrDescription];
    
    // Default data for keychain item.
    [self.keychainItemData setObject:@"" forKey:(id)kSecValueData];
    
    [self.keychainItemData setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
}

@end
