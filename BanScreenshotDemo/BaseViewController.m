//
//  BaseViewController.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/22.
//

#import "BaseViewController.h"
#import "MAScreenShieldView.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView {
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);;
    if (@available(iOS 13.2, *)) {
        if (self.banScreenshot) {
            self.view = [MAScreenShieldView creactWithFrame:frame];
        }else{
            self.view = [[UIView alloc] initWithFrame:frame];
        }
    }else{
        self.view = [[UIView alloc] initWithFrame:frame];
    }
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
