//
//  Macros.h
//  OCKit
//
//  Created by HuangPeng on 8/24/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WEAK_VAR(v) \
__weak typeof(v) _##v = v

#define RGBCOLOR_HEX(hexColor) [UIColor colorWithRed: (((hexColor >> 16) & 0xFF))/255.0f         \
green: (((hexColor >> 8) & 0xFF))/255.0f          \
blue: ((hexColor & 0xFF))/255.0f                 \
alpha: 1]


static inline NSString *EnsureNotNull(id src) {
    if (src == nil) {
        return @"";
    }
    if ([src isKindOfClass:[NSNull class]]) {
        return  @"";
    }
    return src;
}

static inline BOOL iOSOver(CGFloat version) {
    return [[UIDevice currentDevice].systemVersion floatValue] >= version;
}