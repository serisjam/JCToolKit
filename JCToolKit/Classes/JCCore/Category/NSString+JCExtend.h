//
//  NSString+JCExtraMethod.h
//  Pods
//
//  Created by 贾淼 on 16/12/17.
//
//

#import <Foundation/Foundation.h>

@interface NSString (JCExtend)

//是否为空
- (BOOL)jc_isEmpty;

//密码:（6-16）位字符
- (BOOL)jc_isLegalPassword;

//合法手机号码检查
-(BOOL)jc_isLegalPhone;

//邮箱
- (BOOL)jc_isLegalEmail;

//URL
- (BOOL)jc_isLegalURL;

//IP
- (BOOL)jc_isLegalIPAddress;

// 昵称
- (BOOL)jc_isLegalNickname;

//大写MD5值
- (NSString *)jc_MD5;

//小写MD5值
- (NSString *)jc_md5;

//大写SHA1值
- (NSString *)jc_SHA1;

//小写SHA1值
- (NSString *)jc_sha1;

// URL编码
- (NSString *)jc_URLEncoding;

// URL解码
- (NSString *)jc_URLDecoding;

//base64解码
- (NSData *)jc_BASE64Decode;

@end
