//
//  JCToolKit.h
//  Pods
//
//  Created by Jam on 16/12/14.
//
//

#import <Foundation/Foundation.h>

#if __has_include(<JCToolKit/JCToolKit.h>)

//! Project version number for JCToolKit.
FOUNDATION_EXPORT double JCToolKitVersionNumber;

//! Project version string for JCToolKit.
FOUNDATION_EXPORT const unsigned char JCToolKitVersionString[];

#import <JCToolKit/JCDefine.h>
#import <JCToolKit/JCToolKit_Core.h>
#import <JCToolKit/JCToolKit_Network.h>
#import <JCToolKit/JCToolKit_UI.h>
#import <JCToolKit/JCRouter.h>
#import <JCToolKit/JCMediatorProtocol.h>
#import <JCToolKit/Masonry.h>
#import <JCToolKit/MBProgressHUD.h>
#import <JCToolKit/CocoaLumberjack.h>

#else

#import "JCDefine.h"
#import "JCToolKit_Core.h"
#import "JCToolKit_Network.h"
#import "JCToolKit_UI.h"
#import "JCRouter.h"
#import "JCMediatorProtocol.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "CocoaLumberjack.h"

#endif /* JCToolKit_h */
