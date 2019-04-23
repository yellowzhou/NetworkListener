//
//  PMStatusBar.m
//  Listener
//
//  Created by yellow on 2019/4/22.
//  Copyright © 2019 yellow. All rights reserved.
//

#import "PMStatusBar.h"
#import <FrameAccessor.h>

@interface PMStatusBar ()

@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *stringLabel;
@property (nonatomic, strong) NSMutableArray *statuses;

@property (atomic, assign)      BOOL flag;


@end
@implementation PMStatusBar

+ (void)showStatus:(NSString *)text
{
    UIColor *barColor = [UIColor colorWithRed:12/255.0 green:79/255.0 blue:126/255.0 alpha:1];
    [self showWithText:text barColor:barColor textColor:[UIColor greenColor] delay:2];
}

+ (void)showWithText:(NSString *)text barColor:(UIColor*)barColor textColor:(UIColor*)textColor delay:(NSInteger)second
{
    if (!text) {
        return;
    }
    if ([PMStatusBar shareView].flag) {
        @synchronized (self) {
            NSDictionary *item = [@{@"text":text,@"barColor":barColor,@"textColor":textColor} copy];
            [[PMStatusBar shareView].statuses addObject:item];
        }
        return;
    }
    
    if ([[PMStatusBar shareView]showWithText:text barColor:barColor textColor:textColor]) {
        [[PMStatusBar shareView] performSelector:@selector(dismiss) withObject:nil afterDelay:MAX(second, 2.f)];
    }
}

+ (instancetype)shareView
{
    static PMStatusBar *o = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [[PMStatusBar alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        o.statuses=[[NSMutableArray alloc]init];
    });
    return o;
}

- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (BOOL)showWithText:(NSString *)text barColor:(UIColor*)barColor textColor:(UIColor*)textColor
{
    if (!text || text.length == 0) {
        return NO;
    }
    
    if (!barColor) {
        barColor = [UIColor colorWithRed:12/255.0 green:79/255.0 blue:126/255.0 alpha:1];
    }
    
    if (!textColor) {
        textColor = [UIColor greenColor];
    }

    self.flag = YES;
    
    self.stringLabel.frame = [UIApplication sharedApplication].statusBarFrame;
    self.stringLabel.hidden = NO;
    self.stringLabel.alpha = 1;
    self.stringLabel.text = text;
    self.stringLabel.textColor = textColor;
    self.topBar.backgroundColor = barColor;
    
    if (self.overlayWindow.hidden) {
        [self.topBar addSubview:self.stringLabel];
        [self.overlayWindow addSubview:self.topBar];
        [self.overlayWindow addSubview:self];
        [self.overlayWindow setHidden:NO];
    }

    [UIView animateWithDuration:0.4 animations:^{
        self.stringLabel.alpha = 1.0;
        self.topBar.top= 0 ;
    }];
    [self setNeedsDisplay];
    return YES;
}

- (void) dismiss
{
    self.flag = NO;
    NSDictionary *item = self.statuses.firstObject;
    if (item) {
        
        @synchronized (self) {
            [self.statuses removeObject:item];
        }
        [PMStatusBar showWithText:item[@"text"] barColor:item[@"barColor"] textColor:item[@"textColor"] delay:1];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.stringLabel.alpha = 0.0;
            self.topBar.top = -[UIApplication sharedApplication].statusBarFrame.size.height;
        } completion:^(BOOL finished) {
            [self.topBar removeFromSuperview];
            self.topBar = nil;
            [self.overlayWindow removeFromSuperview];
            self.overlayWindow = nil;
        }];
    }
    

}

#pragma mark -- property....
- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.hidden = YES;
    }
    return _overlayWindow;
}

- (UIView *)topBar {
    if(!_topBar) {
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        _topBar = [[UIView alloc] initWithFrame:frame];
    }
    return _topBar;
}

- (UILabel *)stringLabel {
    if (_stringLabel == nil) {
        _stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stringLabel.textColor = [UIColor blackColor];
        _stringLabel.backgroundColor = [UIColor clearColor];
//        _stringLabel.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        _stringLabel.textAlignment = UITextAlignmentCenter;
#else
        _stringLabel.textAlignment = NSTextAlignmentCenter;
#endif
//        _stringLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _stringLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _stringLabel.shadowColor = [UIColor clearColor];
        _stringLabel.shadowOffset = CGSizeMake(0, -1);
        _stringLabel.numberOfLines = 0;
    }
    
    return _stringLabel;
}

@end
