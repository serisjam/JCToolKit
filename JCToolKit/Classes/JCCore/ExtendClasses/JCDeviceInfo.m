//
//  JCDeviceInfo.m
//  Pods
//
//  Created by Jam on 16/12/14.
//
//

#import "JCDeviceInfo.h"
#import "JCDefine.h"

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
    NSString *retrieveuuid = [SAMKeychain passwordForService:[self getBundleIdentifier] account:@"uuid"];
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]){
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid != NULL);
        CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@", uuidStr];
        [SAMKeychain setPassword:retrieveuuid forService:[self getBundleIdentifier] account:@"uuid"];
    }
    return retrieveuuid;
}

+ (NSString *)getBundleVersion {
    return [[jc_currentBundle infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getBundleVersionWithNoDot {
    NSDictionary *infoDict=[jc_currentBundle infoDictionary];
    NSString *sVersion=[infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSRange fRange = [sVersion rangeOfString:@"."];
    
    
    NSString * version = @"";
    
    if(fRange.location != NSNotFound){
        sVersion = [sVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSMutableString *mVersion = [NSMutableString stringWithString:sVersion];
        [mVersion insertString:@"." atIndex:fRange.location];
        version = mVersion;
    }else {
        // 版本应该有问题(由于ios 的版本 是7.0.1，没有发现出现过没有小数点的情况)
        version = sVersion;
    }
    NSString * newversion =[NSString stringWithFormat:@"%.0f",[version floatValue]*100];
    
    return newversion;
}

+ (NSString *)getBundleShortVersion {
    return [jc_currentBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)getBundleIdentifier {
    return [[jc_currentBundle infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (UIDeviceOrientation)getCurrentOrientation {
    return [[UIDevice currentDevice] orientation];
}

+ (CGFloat)getCurrentBatteryLevel {
    CGFloat currentBatteryLevel = [[UIDevice currentDevice] batteryLevel];
    return currentBatteryLevel;
}

+ (UIUserInterfaceIdiom)currentUserInterfaceIdiom {
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

@end
