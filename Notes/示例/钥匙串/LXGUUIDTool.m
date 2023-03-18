//
//  LXGUUIDTool.m
//  Notes
//
//  Created by 龙兴国 on 2019/11/25.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGUUIDTool.h"
#import <Security/SecItem.h>
#import <Security/SecBase.h>
@implementation LXGUUIDTool
+(NSString *)getUUID {
    NSString * strUUID = (NSString *)[LXGUUIDTool readKeychainValue:@"uuid"];
    if ([strUUID isEqualToString:@""] || !strUUID){
        CFUUIDRef   uuid       = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString(nil, uuid);
        NSString  * result     = CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
        CFRelease(uuid);
        CFRelease(uuidString);
        [LXGUUIDTool saveKeychainValue:result key:@"uuid"];
    }
    return strUUID;
}
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service,(__bridge_transfer id)kSecAttrService,
            service,(__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,nil];
}
+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey{
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:sValue] forKey:(__bridge_transfer id)kSecValueData];
    SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
}
+ (NSString *)readKeychainValue:(NSString *)sKey{
    NSString            * ret           = nil;
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = (NSString *)[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", sKey, e);
        } @finally {
        }
    }
    if (keyData){
        CFRelease(keyData);
    }
    return ret;
}
+ (void)deleteKeychainValue:(NSString *)sKey{
    NSMutableDictionary * keychainQuery = [self getKeychainQuery:sKey];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}







//SecItemAdd 添加一个keychain item
//SecItemUpdate 修改一个keychain item
//SecItemCopyMatching 搜索一个keychain item
//SecItemDelete 删除一个keychain item
// kSecClassInternetPassword
// kSecClassGenericPassword
// kSecClassCertificate
// kSecClassKey
// kSecClassIdentity
//kSecAttrService
//kSecAttrAccount
-(NSMutableDictionary *)newSearchDictionary:(NSString *)str{
    NSMutableDictionary * searchDictionary = [[NSMutableDictionary alloc] init];
    //指定item的类型为GenericPassword
    [searchDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    //类型为GenericPassword的信息必须提供以下两条属性作为unique identifier
    [searchDictionary setObject:str forKey:(id)kSecAttrAccount];
    [searchDictionary setObject:str forKey:(id)kSecAttrService];
    return searchDictionary;
}
- (CFTypeRef *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary * searchDictionary = [self newSearchDictionary:identifier];
    //在搜索keychain item的时候必须提供下面的两条用于搜索的属性
    //只返回搜索到的第一条item，这个是搜索条件。
    [searchDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    //返回item的kSecValueData 字段。也就是我们一般用于存放的密码，返回类型为NSData *类型
    [searchDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    //我来解释下这里匹配出的是 找到一条符合ksecAttrAccount、类型为普通密码类型kSecClass，返回ksecValueData字段。
    CFTypeRef * result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)searchDictionary,
                                          (CFTypeRef *)&result);
    return result;
}
- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary * dictionary = [self newSearchDictionary:identifier];
    //非常值得注意的事kSecValueData字段只接受UTF8格式的 NSData *类型，否则addItem/updateItem就会crash，并且一定记得带上service和account字段
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(id)kSecValueData];
    OSStatus status = SecItemAdd((CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}
- (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [updateDictionary setObject:passwordData forKey:(id)kSecValueData];
    //这里也有需要注意的地方，searchDictionary为搜索条件，updateDictionary为需要更新的字典。这两个字典中一定不能有相同的key，否则就会更新失败
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}
- (void)deleteKeychainValue:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    SecItemDelete((CFDictionaryRef)searchDictionary);
}
@end
