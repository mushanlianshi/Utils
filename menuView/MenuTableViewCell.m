//
//  MenuViewCellTableViewCell.m
//  UIDemoCollection
//
//  Created by 123 on 16/8/11.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "MenuViewModal.h"
@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
/**
 * 复写menuViewCell的初始化方法 来进行初始化
 */

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_setCellViewUI];
    }
    return self;
}
-(void)p_setCellViewUI{
    self.backgroundColor=[UIColor clearColor];
    self.textLabel.font=[UIFont systemFontOfSize:14];
    self.textLabel.textColor=[UIColor whiteColor];
    //设置分割线没有   自己绘制分割线
    self.selectionStyle=UITableViewCellSelectionStyleNone;
//    self.selectionStyle=UITableViewCellSelectionStyleGray;
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    lineView.backgroundColor=[UIColor whiteColor];
    [self addSubview:lineView];
}

-(void)setModal:(MenuViewModal *)modal{
    self.imageView.image=[UIImage imageNamed:modal.imageUrl];
    self.textLabel.text=modal.titleName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
