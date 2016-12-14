//
//  JCDeviceInfo.h
//  Pods
//
//  Created by 贾淼 on 16/12/14.
//
//

#import <Foundation/Foundation.h>

@interface JCDeviceInfo : NSObject

+ (NSString *)getDeviceName;//设备名称

+ (NSString *)getSystemName;//系统名称

+ (NSString *)getSystemVersion;//系统版本号

+ (NSString *)getSystemModel;//设备模式

+ (NSString *)getLocalModel;//本地设备模式

+ (NSString *)deviceVersion;//设备类型 iphone4 4s 5 6等

+ (NSString *)getIMEI;//通用唯一标识码

@end
