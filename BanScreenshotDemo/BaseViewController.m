//
//  BaseViewController.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/22.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView {
    if (self.banScreenshot) {
        UITextField *textField = [[UITextField alloc] init];
        textField.secureTextEntry = YES;
        textField.enabled = NO;
        if (textField.subviews.firstObject != nil) {
            self.view = textField.subviews.firstObject;
        }else{
            self.view = [[UIView alloc] init];
        }
    }else{
        self.view = [[UIView alloc] init];
    }
    self.view.userInteractionEnabled = YES;
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.view.backgroundColor = [UIColor whiteColor];
}


@end
