//
//  NSString+JCExtraMethod.m
//  Pods
//
//  Created by 贾淼 on 16/12/17.
//
//

#import "NSString+JCExtend.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (JCExtend)

- (BOOL)jc_isEmpty {
    if (self == nil || self == NULL) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isRegularWithExpress:(NSString *)expressString {
    if ([self jc_isEmpty]) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expressString];
    return [pred evaluateWithObject:self];
}

- (BOOL)jc_isLegalPassword {
    NSString *regex = @"(?=.*?[a-zA-Z])(?=.*?[0-9])[a-zA-Z0-9]{6,20}$";
    return [self isRegularWithExpress:regex];
}

- (BOOL)jc_isLegalPhone {
    NSString *moblie = @"^1(3[0-9]|47|5[0-35-9]|8[0-9])\\d{8}$";
    NSString *chinaMoblie = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278]|78)\\d)\\d{7}$";
    NSString *chinaUnicom = @"^1(3[0-2]|5[256]|8[56]|76)\\d{8}$";
    NSString *chinaTelecom = @"^1((33|53|8[09]|77|73)[0-9]|349)\\d{7}$";
    
    if ([self isRegularWithExpress:moblie]
        || [self isRegularWithExpress:chinaMoblie]
        || [self isRegularWithExpress:chinaUnicom]
        || [self isRegularWithExpress:chinaTelecom]) {
        return YES;
    }
    return NO;
}

- (BOOL)jc_isLegalEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self isRegularWithExpress:regex];
}

- (BOOL)jc_isLegalURL {
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    return [self isRegularWithExpress:regex];
}

- (BOOL)jc_isLegalIPAddress {
    
    if ([self jc_isEmpty]) {
        return NO;
    }
    
    NSArray *			components = [self componentsSeparatedByString:@"."];
    NSCharacterSet *	invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    if ( [components count] == 4 )
    {
        NSString *part1 = [components objectAtIndex:0];
        NSString *part2 = [components objectAtIndex:1];
        NSString *part3 = [components objectAtIndex:2];
        NSString *part4 = [components objectAtIndex:3];
        
        if ( [part1 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part2 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part3 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound &&
            [part4 rangeOfCharacterFromSet:invalidCharacters].location == NSNotFound )
        {
            if ( [part1 intValue] < 255 &&
                [part2 intValue] < 255 &&
                [part3 intValue] < 255 &&
                [part4 intValue] < 255 )
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)jc_isLegalNickname {
    NSString *regex = @"^[a-zA-Z0-9_\u4E00-\u9FFF-]{1,12}+$";
    return [self isRegularWithExpress:regex];
}

- (NSString *)jc_MD5 {
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

- (NSString *)jc_md5 {
    return [[self jc_MD5] lowercaseString];
}

- (NSString *)jc_SHA1 {
    
    if ([self jc_isEmpty]) {
        return nil;
    }
    
    NSData *data = [NSData dataWithBytes:self.UTF8String length:self.length];
    uint8_t	digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };
    
    CC_SHA1( data.bytes, (CC_LONG)data.length, digest );
    
    char tmp[16] = { 0 };
    char hex[256] = { 0 };
    
    for ( CC_LONG i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i )
    {
        sprintf( tmp, "%02X", digest[i] );
        strcat( (char *)hex, tmp );
    }
    
    return [NSString stringWithUTF8String:(const char *)hex];
}

- (NSString *)jc_sha1 {
    
    if ([self jc_isEmpty]) {
        return nil;
    }
    
    return [[self jc_SHA1] lowercaseString];
}

- (NSString *)jc_URLEncoding {
    CFStringRef aCFString = CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    kCFStringEncodingUTF8 );
    NSString * result = (NSString *)CFBridgingRelease(aCFString);
    
    return result;
}

- (NSString *)jc_URLDecoding {
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)jc_BASE64Decode {
    
    static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static char * __base64DecodingTable = nil;
    
    // copy from THREE20
    
    if ( 0 == [self length] )
    {
        return [NSData data];
    }
    
    if ( NULL == __base64DecodingTable )
    {
        __base64DecodingTable = (char *)malloc( 256 );
        if ( NULL == __base64DecodingTable )
        {
            return nil;
        }
        
        memset( __base64DecodingTable, CHAR_MAX, 256 );
        
        for ( int i = 0; i < 64; i++)
        {
            __base64DecodingTable[(short)__base64EncodingTable[i]] = (char)i;
        }
    }
    
    const char * characters = [self cStringUsingEncoding:NSASCIIStringEncoding];
    if ( NULL == characters )     //  Not an ASCII string!
    {
        return nil;
    }
    
    char * bytes = (char *)malloc( ([self length] + 3) * 3 / 4 );
    if ( NULL == bytes )
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while ( 1 )
    {
        char	buffer[4] = { 0 };
        short	bufferLength = 0;
        
        for ( bufferLength = 0; bufferLength < 4; i++ )
        {
            if ( characters[i] == '\0' )
            {
                break;
            }
            
            if ( isspace(characters[i]) || characters[i] == '=' )
            {
                continue;
            }
            
            buffer[bufferLength] = __base64DecodingTable[(short)characters[i]];
            if ( CHAR_MAX == buffer[bufferLength++] )
            {
                free(bytes);
                return nil;
            }
        }
        
        if ( 0 == bufferLength )
        {
            break;
        }
        
        if ( 1 == bufferLength )
        {
            // At least two characters are needed to produce one byte!
            
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        
        bytes[length++] = (char)((buffer[0] << 2) | (buffer[1] >> 4));
        
        if (bufferLength > 2)
        {
            bytes[length++] = (char)((buffer[1] << 4) | (buffer[2] >> 2));
        }
        
        if (bufferLength > 3)
        {
            bytes[length++] = (char)((buffer[2] << 6) | buffer[3]);
        }
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-result"
    realloc(bytes, length );
#pragma clang diagnostic pop
    
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end
