//
//  UIView+Utility.m
//  OCKit
//
//  Created by HuangPeng on 8/24/14.
//  Copyright (c) 2014 Beacon. All rights reserved.
//

#import "UIView+Utility.h"
#import "NIDebuggingTools.h"

@implementation UIView (Utility)

+ (id) viewWithFrame: (CGRect)frame andBkColor: (UIColor*) color {
    UIView * view = [[UIView alloc] initWithFrame: frame];
    view.backgroundColor = color;
    return view;
}

+ (UIView *)roundView:(CGFloat)radius {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    [v makeRound];
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

+ (UIView *)lineWithPattern:(NSString *)name width:(CGFloat)width height:(CGFloat)height {
    return [self lineWithColor:[UIColor colorWithPatternImage:[UIImage imageNamed:name]] width:width height:height];
}

+ (UIView *)lineWithColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    v.backgroundColor = color;
    return v;
}

+ (UIView *)roundViewWithDiameter:(CGFloat)diameter {
    return [self roundView:diameter / 2];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (void)makeRound {
    self.layer.cornerRadius = self.width / 2;
    self.clipsToBounds = YES;
}

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImageView *)snapshotAsImageView {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[self snapshot]];
    return iv;
}

- (void)printFrame:(NSString*)info {
    CGRect frame = self.frame;
    NIDPRINT(@"%@, %f, %f, %f, %f", info, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

@end

@implementation UIScrollView(Utility)

- (void)setTopInset:(CGFloat)topInset {
    UIEdgeInsets inset = self.contentInset;
    inset.top = topInset;
    self.contentInset = inset;
}

- (CGFloat)topInset {
    return self.contentInset.top;
}

@end
