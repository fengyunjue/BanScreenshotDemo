//
//  MAScreenShieldView.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/24.
//

#import "MAScreenShieldView.h"

/// 仿照https://github.com/RyukieSama/Swifty/blob/master/Swifty/Classes/UIKit/UIView/View/ScreenShieldView.swift写的,不过Swifty上的有bug,->在iOS15.0和iOS15.1时,点击到禁止截图界面然后退到后台再进入APP,APP会崩溃
@interface MAScreenShieldView()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *safeZone;

@end

@implementation MAScreenShieldView

+ (UIView *)creactWithFrame:(CGRect)frame {
    return [[MAScreenShieldView alloc] initWithFrame:frame];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSafeZoneView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSafeZoneView];
    }
    return self;
}

- (void)addSafeZoneView {
    [self addSubview:self.safeZone];
    
    UILayoutPriority lowPriority = UILayoutPriorityDefaultLow - 1;
    UILayoutPriority heightPriority = UILayoutPriorityDefaultHigh - 1;

    self.safeZone.translatesAutoresizingMaskIntoConstraints = NO;
    [self.safeZone setContentHuggingPriority:lowPriority forAxis:UILayoutConstraintAxisVertical];
    [self.safeZone setContentHuggingPriority:lowPriority forAxis:UILayoutConstraintAxisHorizontal];
    [self.safeZone setContentCompressionResistancePriority:heightPriority forAxis:UILayoutConstraintAxisVertical];
    [self.safeZone setContentCompressionResistancePriority:heightPriority forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.safeZone attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.safeZone attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.safeZone attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.safeZone attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
    ]];
}

- (void)addSubview:(UIView *)view {
    if (self.safeZone == view) {
        [super addSubview:view];
    }else{
        [self.safeZone addSubview:view];
    }
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    if (self.safeZone == view) {
        [super insertSubview:view atIndex:index];
    }else{
        [self.safeZone insertSubview:view atIndex:index];
    }
}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    if (self.safeZone == view) {
        [super insertSubview:view aboveSubview:siblingSubview];
    }else{
        [self.safeZone insertSubview:view aboveSubview:siblingSubview];
    }
}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    if (self.safeZone == view) {
        [super insertSubview:view belowSubview:siblingSubview];
    }else{
        [self.safeZone insertSubview:view belowSubview:siblingSubview];
    }
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.secureTextEntry = YES;
        _textField.enabled = NO;
    }
    return _textField;
}

- (UIView *)safeZone{
    if(!_safeZone){
        _safeZone = self.textField.subviews.firstObject ?: [[UIView alloc] init];
        _safeZone.userInteractionEnabled = YES;
        for (UIView *v in _safeZone.subviews) {
            [v removeFromSuperview];
        }
    }
    return _safeZone;
}

@end
