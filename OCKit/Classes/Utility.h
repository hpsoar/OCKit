//
//  Utility.h
//  Knife
//
//  Created by HuangPeng on 8/23/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macros.h"
#import "UIView+Utility.h"

NSString *DefStr(NSString *format, ...);

@interface NSDate (Utility)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger week;

@property (nonatomic, readonly) NSDateComponents *solarComponents;
@property (nonatomic, readonly) NSDateComponents *lunarComponents;

- (NSString *)formatWith:(NSString *)formatter;

- (BOOL)isToday;

- (NSComparisonResult)compareDateOnly:(NSDate *)date;

+ (NSDate*)dateWithFormatter:(NSString *)formatter dateStr:(NSString *)dateStr;

@end


@interface LunarDate : NSObject

@property (nonatomic, readonly) NSString *dayString;
@property (nonatomic, readonly) NSString *monthString;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger year;

- (id)initWithDate:(NSDate *)date;

@end

@interface Utility : NSObject

+ (NSString *)documentPath;

+ (NSString *)filepath:(NSString *)filename;

+ (NSString *)md5:(NSString *)password;

+ (NSString*)UUID;

+ (id)userDefaultObjectForKey:(NSString *)key;
+ (void)setUserDefaultObjects:(NSDictionary *)dict;
+ (void)removeObject:(NSString *)key;

@end

@interface Utility (UI)

+ (CGFloat)heightForText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGFloat)heightForText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

@end

@interface NSNumber (Arithmetic)

- (NSNumber *)addInt:(NSInteger)value;

- (NSNumber *)addFloat:(CGFloat)value;

- (NSNumber *)addDouble:(double)value;

@end
