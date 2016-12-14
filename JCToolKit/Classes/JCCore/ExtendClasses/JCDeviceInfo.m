//
//  JCDeviceInfo.m
//  Pods
//
//  Created by Jam on 16/12/14.
//
//

#import "JCDeviceInfo.h"
#import "SSKeychain.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

#import "sys/utsname.h"

@implementation JCDeviceInfo

+ (NSString *)getDeviceName{
    NSString *deviceName = [[UIDevice currentDevice] name];
    return deviceName;
}

+ (NSString *)getSystemName{
    NSString *systemName = [[UIDevice currentDevice] systemName];
    return systemName;
    
}

+ (NSString *)getSystemVersion{
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    return systemVersion;
}

+ (NSString *)getSystemModel{
    NSString *systemModel = [[UIDevice currentDevice] model];
    return systemModel;
}

+ (NSString *)getLocalModel{
    NSString *localModel = [[UIDevice currentDevice] localizedModel];;
    return localModel;
}

+ (NSString *)deviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

+ (NSString *)getIMEI{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.nahuasuan.nahuasuan" account:@"uuid"];
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]){
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@", uuidStr];
        [SSKeychain setPassword: retrieveuuid forService:@"com.nahuasuan.nahuasuan" account:@"uuid"];
    }
    return retrieveuuid;
}

@end
