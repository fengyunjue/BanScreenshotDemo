//
//  ViewController2.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/22.
//

#import "ViewController2.h"
#import "MAAutoLayout.h"

@interface ViewController2 ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController2


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    [self.label ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.center.equalTo(self.view);
    }];
    
    UIView *theView = self.textField.subviews.firstObject;
    [self.view addSubview:theView];
    theView.userInteractionEnabled = YES;
    [theView addSubview:self.imageView];
    [theView ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.edge.equalTo(self.view);
    }];
    [self.imageView ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.center.equalTo(theView);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123.jpg"]];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.secureTextEntry = YES;
        _textField.enabled = NO;
    }
    return _textField;
}

- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.text = @"禁止截图";
    }
    return _label;
}

@end
