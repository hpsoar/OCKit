//
//  UIView+Utility.h
//  OCKit
//
//  Created by HuangPeng on 8/24/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utility)

+ (id) viewWithFrame: (CGRect)frame andBkColor: (UIColor*) color;

+ (UIView *)lineWithPattern:(NSString *)name width:(CGFloat)width height:(CGFloat)height;

+ (UIView *)lineWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height;

+ (UIView *)roundView:(CGFloat)radius;

+ (UIView *)roundViewWithDiameter:(CGFloat)diameter;

+ (CGFloat)width;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

- (void)makeRound;

- (UIImage *)snapshot;

- (UIImageView *)snapshotAsImageView;

- (void)printFrame:(NSString*)info;

@end

@interface UIScrollView (Utility)

@property (nonatomic) CGFloat topInset;

@end
