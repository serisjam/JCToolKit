//
//  NSData+JCExtraMethod.m
//  Pods
//
//  Created by 贾淼 on 16/12/17.
//
//

#import "NSData+JCExtend.h"

@implementation NSData (JCExtend)

- (NSString *)jc_BASE64Encode {
    static char * __base64EncodingTable = (char *)"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    // copy from THREE20
    
    if ( 0 == [self length] )
    {
        return @"";
    }
    
    char * characters = (char *)malloc((([self length] + 2) / 3) * 4);
    if ( NULL == characters )
    {
        return nil;
    }
    
    NSUInteger length = 0;
    NSUInteger i = 0;
    
    while ( i < [self length] )
    {
        char	buffer[3] = { 0 };
        short	bufferLength = 0;
        
        while ( bufferLength < 3 && i < [self length] )
        {
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        }
        
        // Encode the bytes in the buffer to four characters,
        // including padding "=" characters if necessary.
        characters[length++] = __base64EncodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = __base64EncodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        
        if ( bufferLength > 1 )
        {
            characters[length++] = __base64EncodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        }
        else
        {
            characters[length++] = '=';
        }
        
        if ( bufferLength > 2 )
        {
            characters[length++] = __base64EncodingTable[buffer[2] & 0x3F];
        }
        else
        {
            characters[length++] = '=';
        }
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
