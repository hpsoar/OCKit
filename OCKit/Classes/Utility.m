//
//  Utility.m
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>

NSString *DefStr(NSString *format, ...) {
    va_list args;
    va_start(args,format);
    //loop, get every next arg by calling va_arg(args,<type>)
    // e.g. NSString *arg=va_arg(args,NSString*) or int arg=(args,int)
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return s;
}
 
@implementation NSDate (Utility)

- (NSInteger)year {
    return self.solarComponents.year;
}

- (NSInteger)month {
    return self.solarComponents.month;
}

- (NSInteger)day {
    return self.solarComponents.day;
}

- (NSInteger)week {
    return self.solarComponents.weekday;
}

- (NSDateComponents *)solarComponents {
    return [self dateComponentsWithIdentifier:NSGregorianCalendar];
}

- (NSDateComponents *)lunarComponents {
    return [self dateComponentsWithIdentifier:NSChineseCalendar];
}

- (NSDateComponents *)dateComponentsWithIdentifier:(NSString *)identifier {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:identifier];
    NSCalendarUnit units = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit;
    return [calendar components:units fromDate:self];
}

+ (NSDate*) dateWithFormatter:(NSString *)formatter dateStr:(NSString *)dateStr {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}

// 例如: @"yyyy-MM-dd"
//
- (NSString *)formatWith:(NSString *)formatter {
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:self];
}

- (BOOL)isToday {
    return [self compareDateOnly:[NSDate date]] == NSOrderedSame;
}

#warning test
- (NSComparisonResult)compareDateOnly:(NSDate *)date {
    NSInteger t0 = [self timeIntervalSince1970] / (3600 * 24);
    NSInteger t1 = [date timeIntervalSince1970] / (3600 * 24);
    if (t0 < t1) {
        return NSOrderedAscending;
    }
    else if (t0 > t1) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

@end

@implementation LunarDate

- (id)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        NSDateComponents *lunarComps = date.lunarComponents;
        self.day = lunarComps.day;
        self.month = lunarComps.month;
        self.year = lunarComps.year;
    }
    return self;
}

- (NSString *)dayString {
    NSArray *days = @[ @"", @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                       @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                       @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十" ];
    return days[self.day];
}

- (NSString *)monthString {
    NSArray *months = @[ @"", @"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"冬",@"腊" ];
    return [NSString stringWithFormat:@"%@月", months[self.month]];
}


@end


@implementation Utility

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)documentPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}


+ (NSString *)filepath:(NSString *)filename {
    NSString *docPath = [self documentPath];
    return [docPath stringByAppendingPathComponent:filename];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)md5:(NSString *)password {
    const char *cStr = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    
    return [[NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1],
             result[2], result[3],
             result[4], result[5],
             result[6], result[7],
             result[8], result[9],
             result[10], result[11],
             result[12 ], result[13],
             result[14 ], result[15]] lowercaseString];
}

+ (NSString*)UUID {
    //
    // https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSUUID_Class/Reference/Reference.html
    // NSUUID为128-bit, 全球唯一(Globally Unique Identifiers)
    // 经过HEX编码之后变成32个字节的字符串
    NSString *uuid;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        uuid = [[NSUUID UUID] UUIDString];
    } else {
        CFUUIDRef UUID = CFUUIDCreate(NULL);
        uuid = CFBridgingRelease(CFUUIDCreateString(NULL, UUID));
    }
    
    return [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

+ (id)userDefaultObjectForKey:(NSString *)key {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    return [info objectForKey:key];
}

+ (void)setUserDefaultObjects:(NSDictionary *)dict {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [info setObject:obj forKey:key];
    }];
    [info synchronize];
}

+ (void)removeUserDefaultObject:(NSString *)key {
    NSUserDefaults *info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:key];
    [info synchronize];
}

@end

@implementation Utility (UI)

+ (CGFloat)heightForText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    return [self heightForText:text font:[UIFont systemFontOfSize:fontSize] width:width];
}

+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    NSDictionary *attrs = @{ NSFontAttributeName: font };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return rect.size.height;
}

@end
