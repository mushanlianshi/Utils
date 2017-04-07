//
//  LBSwitch.m
//  LBTabbarController
//
//  Created by liubin on 16/11/14.
//  Copyright © 2016年 lb. All rights reserved.
//

#define horiztolMargin 1 //中间滑块圆圈左边调整的间距
#define verticalMargin 1 //中间滑块圆圈竖直方向调整的间距
#define annimationDuration 0.3
#import "LBSwitch.h"
@interface LBSwitch()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, copy) NSString *onTitle;
@property (nonatomic, copy) NSString *offTitle;

@property (nonatomic, strong) UIColor *onTitleColor;
@property (nonatomic, strong) UIColor *offTitleColor;
@end
@implementation LBSwitch
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI{
    UITapGestureRecognizer *selfTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTapped:)];
    _backView=[[UIView alloc] initWithFrame:self.bounds];
    _backView.backgroundColor=[UIColor clearColor];
    _backView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _backView.layer.borderWidth=1;
    _backView.layer.cornerRadius=self.frame.size.height/2;
    [_backView addGestureRecognizer:selfTap];
    [self addSubview:_backView];
    
    
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(horiztolMargin*2, verticalMargin, self.bounds.size.width-horiztolMargin*2, self.bounds.size.height-verticalMargin*2)];
    _titleLabel.layer.cornerRadius=self.bounds.size.height/2;
    _titleLabel.backgroundColor=[UIColor clearColor];
//    _titleLabel.userInteractionEnabled=YES;
    _titleLabel.textAlignment=NSTextAlignmentRight;
    _titleLabel.clipsToBounds=YES;
//    [_titleLabel addGestureRecognizer:selfTap];
    [self addSubview:_titleLabel];
    
    UITapGestureRecognizer *thumTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbViewTapped:)];
    _thumbView=[[UIView alloc] initWithFrame:CGRectMake(horiztolMargin, verticalMargin, (self.bounds.size.height-2*verticalMargin), (self.bounds.size.height-2*verticalMargin))];
    _thumbView.backgroundColor=[UIColor whiteColor];
    _thumbView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    _thumbView.layer.borderWidth=1;
    _thumbView.layer.cornerRadius=_thumbView.bounds.size.height/2;
    [_thumbView addGestureRecognizer:thumTap];
//    [_thumbView showRedBorder];
    [self addSubview:_thumbView];
}

#pragma mark 开关的点击时间处理
-(void)selfTapped:(UITapGestureRecognizer *)tapGesture{
    self.on=!self.isOn;
    [self dealTapView];
}
-(void)thumbViewTapped:(UITapGestureRecognizer *)tapGesture{
    self.on=!self.isOn;
    [self dealTapView];
}
-(void)dealTapView{
    [UIView animateWithDuration:annimationDuration animations:^{
        if (self.isOn) {
            _backView.backgroundColor=_onTintColor?_onTintColor:[UIColor greenColor];
            _backView.layer.borderColor=_onTintBorderColor?_onTintBorderColor.CGColor:_backView.backgroundColor.CGColor;
            if (_onTitle) {
                _titleLabel.text=_onTitle;
                _titleLabel.textColor=_onTitleColor;
                _titleLabel.textAlignment=NSTextAlignmentLeft;
            }
            _thumbView.frame=CGRectMake(self.bounds.size.width-(self.bounds.size.height-2*verticalMargin), verticalMargin, (self.bounds.size.height-2*verticalMargin), (self.bounds.size.height-2*verticalMargin));
        }else{
            _backView.backgroundColor=_tintColor?_tintColor:[UIColor clearColor];
            _backView.layer.borderColor=_tintBorderColor?_tintBorderColor.CGColor:[UIColor lightGrayColor].CGColor;
            if (_offTitle) {
                _titleLabel.text=_offTitle;
                _titleLabel.textColor=_offTitleColor;
                _titleLabel.textAlignment=NSTextAlignmentRight;
            }
            _thumbView.frame=CGRectMake(horiztolMargin, verticalMargin, (self.bounds.size.height-2*verticalMargin), (self.bounds.size.height-2*verticalMargin));
        }
    } completion:^(BOOL finished) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    
    
}
-(void)layoutSubviews{
    [self setupUI];
}

#pragma 颜色设置
-(void)setTintColor:(UIColor *)tintColor{
    _tintColor=tintColor;
    _backView.backgroundColor=tintColor;
}
-(void)setOnTintColor:(UIColor *)onTintColor{
    _onTintColor=onTintColor;
}
-(void)setThumbTintColor:(UIColor *)thumbTintColor{
    _thumbTintColor=thumbTintColor;
    self.thumbView.backgroundColor=thumbTintColor;
}
-(void)setTintBorderColor:(UIColor *)tintBorderColor{
    _tintBorderColor=tintBorderColor;
    _backView.layer.borderColor=tintBorderColor.CGColor;
}
-(void)setOnTintBorderColor:(UIColor *)onTintBorderColor{
    _onTintBorderColor=onTintBorderColor;
}
-(void)setOnTitle:(NSString *)onTitle onTitleColor:(UIColor *)onTitleColor offTitle:(NSString *)offTitle offTitleColor:(UIColor *)offTitleColor{
    _titleLabel.text=offTitle;
    _titleLabel.textColor=offTitleColor;
    _onTitle=onTitle;
    _onTitleColor=onTitleColor;
    _offTitle=offTitle;
    _offTitleColor=offTitleColor;
}
-(void)setShape:(LBSwitchShape)shape{
    if (shape==LBSwitchShapeOval) {
        _backView.layer.cornerRadius=self.frame.size.height/2;
        _titleLabel.layer.cornerRadius=self.bounds.size.height/2;
        _thumbView.layer.cornerRadius=_thumbView.bounds.size.height/2;
    }else if(shape==LBSwitchShapeRectangle){
        _backView.layer.cornerRadius=0;
        _titleLabel.layer.cornerRadius=0;
        _thumbView.layer.cornerRadius=0;
    }
}
@end
