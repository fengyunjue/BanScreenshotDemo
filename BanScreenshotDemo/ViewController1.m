//
//  ViewController1.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/22.
//

#import "ViewController1.h"
#import "MAAutoLayout.h"

@interface ViewController1 ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *theView = self.textField.subviews.firstObject;
    [self.view addSubview:theView];
    theView.userInteractionEnabled = YES;
    [theView addSubview:self.imageView];
    [theView ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.ma_safeAreaTopLayoutGuide);
        make.leftRight.equalTo(self.view);
        make.width.equalTo(theView.ma_height);
    }];
    [self.imageView ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.edge.equalTo(theView);
    }];
    
    [self.view addSubview:self.label];
    [self.label ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(theView.ma_bottom).offset(100);
        make.centerX.equalTo(self.view);
    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"123.jpg"]];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)]];
    }
    return _imageView;
}

- (void)tapView {
    NSLog(@"点击图片");
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
        _label.text = @"上面的图片在截图时会隐藏起来";
    }
    return _label;
}
@end
