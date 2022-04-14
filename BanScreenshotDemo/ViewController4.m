//
//  ViewController4.m
//  BanScreenshotDemo
//
//  Created by fengyunjue on 2022/4/14.
//

#import "ViewController4.h"
#import "MAAutoLayout.h"

@interface ViewController4 ()

@property (nonatomic, strong) UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.label];
    [self.label ma_makeConstraints:^(MAAutoLayout * _Nonnull make) {
        make.top.equalTo(self.imageView.ma_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
}


- (UILabel *)label{
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.text = @"上面的图片在截图时会隐藏起来";
    }
    return _label;
}
@end
