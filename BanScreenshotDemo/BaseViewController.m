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
    if (self.banScreenshot) {
        if (@available(iOS 13.2, *)) {
            self.view = [MAScreenShieldView creactWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        }else{
            [super loadView];
        }
    }else{
        [super loadView];
    }
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
