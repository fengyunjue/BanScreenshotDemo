//
//  MAScreenShieldView.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/24.
//

#import "MAScreenShieldView.h"

/// 仿照https://github.com/RyukieSama/Swifty写的
@interface MAScreenShieldView()

@property (nonatomic, strong) UIView *safeZone;

@end

@implementation MAScreenShieldView

+ (UIView *)creactWithFrame:(CGRect)frame {
    return [[MAScreenShieldView alloc] initWithFrame:frame];
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.safeZone = [self makeSecureView] ?: [[UIView alloc] init];

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
    return self;
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


- (UIView *)makeSecureView {
    UITextField *textField = [[UITextField alloc]init];
    textField.secureTextEntry = YES;
    UIView *fv = textField.subviews.firstObject;
    for (UIView *v in fv.subviews) {
        [v removeFromSuperview];
    }
    fv.userInteractionEnabled = YES;
    NSString *errorMsg = @"[MAScreenShieldView log] Create safeZone failed!";
#ifdef DEBUG
    NSAssert(fv != nil, errorMsg);
#else
    NSLog(@"%@",errorMsg);
#endif
    return fv;
}


@end
