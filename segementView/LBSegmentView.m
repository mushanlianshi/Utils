//
//  LBSegmentView.m
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBSegmentView.h"
#define kSegmentBorderColor [UIColor colorWithRed:0.15 green:0.15 blue:0.16 alpha:1.00]
#define kSegmentItemNormalColor [UIColor colorWithRed:0.86 green:0.85 blue:0.80 alpha:1.00]
#define kSegmentItemSelectedColor [UIColor colorWithRed:0.40 green:0.33 blue:0.28 alpha:1.00]
@interface LBSegmentView ()
{
    NSArray *_titlesArray;
    UIButton *selectedButton;
}
@end

@implementation LBSegmentView

-(instancetype)initWithItemTitles:(NSArray *)itemTitles{
    if (self=[self init]) {
        NSLog(@"segmeng init ============");
        _titlesArray=itemTitles;
        self.layer.borderColor=kSegmentBorderColor.CGColor;
        self.layer.cornerRadius=7;
        self.layer.borderWidth=2;
        self.clipsToBounds=YES;
        [self setUpViews];
    }
    return self;
}
/**
 * 设置views
 */
-(void)setUpViews{
    int i=0;
    for (NSString *title in _titlesArray) {
        UIButton *button=[[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:kSegmentItemSelectedColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:kSegmentItemNormalColor];
        i++;
        button.tag=i;
        [button addTarget:self action:@selector(itemOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
}

-(void)defaultClicked{
    if (_titlesArray.count) {
        UIButton *defaultBtg=[self viewWithTag:1];
        [self itemOnClicked:defaultBtg];
    }
}
-(void)itemOnClicked:(UIButton *)button{
    
    selectedButton.selected=NO;
    selectedButton.backgroundColor=kSegmentItemNormalColor;
    
    selectedButton=button;
    selectedButton.selected=YES;
    selectedButton.backgroundColor=kSegmentItemSelectedColor;
    
  
    NSInteger tag=button.tag;
    NSString *title=button.titleLabel.text;
    
    selectedButton=button;
    if (self.segmentItemClicked) {
        self.segmentItemClicked(title,tag);
    }
}
-(void)layoutSubviews{
    NSLog(@"layoutSubviews===========");
    CGSize size=self.bounds.size;
    for (int i=0; i<_titlesArray.count; i++) {
        UIButton *button=[self viewWithTag:i+1];
        button.frame=CGRectMake((size.width/_titlesArray.count)*i, 0, size.width/_titlesArray.count, size.height);
    }
}
-(void)layoutIfNeeded{
    NSLog(@"layoutIfNeeded============");
    CGSize size=self.bounds.size;
    for (int i=0; i<_titlesArray.count; i++) {
        UIButton *button=[self viewWithTag:i+1];
        button.frame=CGRectMake((size.width/_titlesArray.count)*i, 0, size.width/_titlesArray.count, size.height);
    }
}

@end
