//
//  JCDeviceInfo.h
//  Pods
//
//  Created by Jam on 16/12/14.
//
//

#import <Foundation/Foundation.h>

//当前屏幕宽高
#define jc_ScreenW [UIScreen mainScreen].bounds.size.width
#define jc_ScreenH [UIScreen mainScreen].bounds.size.height

//版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface JCDeviceInfo : NSObject

//设备名称
+ (NSString *)getDeviceName;

//系统名称
+ (NSString *)getSystemName;

//系统版本号
+ (NSString *)getSystemVersion;

//设备模式
+ (NSString *)getSystemModel;

//本地设备模式
+ (NSString *)getLocalModel;

//设备类型 iphone4 4s 5 6等
+ (NSString *)deviceVersion;

// 通用唯一标识码
+ (NSString *)getIMEI;

// app build版本
+ (NSString *)getBundleVersion;

//app build 去掉.版本号
+ (NSString *)getBundleVersionWithNoDot;

// app版本
+ (NSString *)getBundleShortVersion;

// app bundleId
+ (NSString *)getBundleIdentifier;

//IP地址
+ (NSString *)getIPAddress;

//设备当前旋转方向, 除非正在生成设备方向的通知，否则返回UIDeviceOrientationUnknown
+ (UIDeviceOrientation)getCurrentOrientation;

//电池百分比,0 ..1.0，如果电池状态为UIDeviceBatteryStateUnknown，则百分比为-1.0
+ (CGFloat)getCurrentBatteryLevel;

//当前用户界面模式
+ (UIUserInterfaceIdiom)currentUserInterfaceIdiom;

//屏幕分辨率
+ (NSString *)getScreenSize;

@end
