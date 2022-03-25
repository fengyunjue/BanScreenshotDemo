//
//  ViewController.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/3/22.
//

#import "ViewController.h"
#import "MAAutoLayout.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"

@interface ViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *banScreenshotButton;
@property (nonatomic, strong) UIButton *banScreenshotButton2;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.banScreenshotButton];
    [self.view addSubview:self.banScreenshotButton2];
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    [self.textField ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.view).offset(100);
        make.leftRight.equalTo(self.view).offsets(20);
        make.height.ma_equal(44);
    }];
    [self.banScreenshotButton ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.textField.ma_bottom).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [self.banScreenshotButton2 ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.banScreenshotButton.ma_bottom).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [self.button ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.banScreenshotButton2.ma_bottom).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [self.label ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.leftRight.equalTo(self.view).offsets(30);
        make.bottom.equalTo(self.view).offset(-50);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.layer.cornerRadius = 5;
        _textField.layer.borderWidth =1;
        _textField.layer.borderColor = [UIColor blackColor].CGColor;
        _textField.secureTextEntry = YES;
    }
    return _textField;
}

- (UIButton *)banScreenshotButton{
    if(!_banScreenshotButton){
        _banScreenshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_banScreenshotButton addTarget:self action:@selector(clickBanScreenshotButton) forControlEvents:UIControlEventTouchUpInside];
        [_banScreenshotButton setTitle:@"禁止截屏" forState:UIControlStateNormal];
        [_banScreenshotButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _banScreenshotButton;
}

- (void)clickBanScreenshotButton {
    [self.navigationController pushViewController:[[ViewController1 alloc]init] animated:YES];
}

- (UIButton *)banScreenshotButton2{
    if(!_banScreenshotButton2){
        _banScreenshotButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_banScreenshotButton2 addTarget:self action:@selector(clickBanScreenshotButton2) forControlEvents:UIControlEventTouchUpInside];
        [_banScreenshotButton2 setTitle:@"禁止截屏2" forState:UIControlStateNormal];
        [_banScreenshotButton2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _banScreenshotButton2;
}

- (void)clickBanScreenshotButton2 {
    [self.navigationController pushViewController:[[ViewController2 alloc]init] animated:YES];
}

- (UIButton *)button{
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"TableView" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (void)clickButton {
    [self.navigationController pushViewController:[[ViewController3 alloc]init] animated:YES];
}


- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.text = @"截图测试,请点击模拟器菜单\nDevice->Trigger Screenshot";
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
