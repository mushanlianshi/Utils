//
//  MenuView.m
//  UIDemoCollection
//
//  Created by 123 on 16/8/11.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "MenuView.h"
#import "MenuViewModal.h"
#import "MenuTableViewCell.h"
@interface MenuView()

@property (nonatomic,strong)UITableView *menuTableView;
@property (nonatomic,strong)NSArray *menuTableArray;
@end
@implementation MenuView

-(id)initWithFrame:(CGRect)rect showView:(UIView *)view withDataArray:(NSArray *)dataArray itemClickedBlock:(ItemsClickedBlock)block{
    self=[super initWithFrame:rect];
    if (self) {
//        NSLog(@"dataArray is %@ ",dataArray);
//        NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:dataArray.count];
//        for (NSDictionary *dic in dataArray) {
//            MenuViewModal *modal=[[MenuViewModal alloc] init];
//            modal.imageUrl=dic[@"imageUrl"];
//            modal.titleName=dic[@"titleName"];
//            [array addObject:modal];
//        }
//        self.menuTableArray=array;
//        //设置数据源
        self.menuTableArray=dataArray;
//        [self setMenuTableArray:dataArray];
        //image图片的拉伸，以指定点的像素拉伸，主要用于背景图气泡类型的，以免等比例拉伸造成的不协调
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *image=[UIImage imageNamed:@"pop_black_backGround"];
        CGFloat leftCapWidth=image.size.width*0.5;
        CGFloat topCapHeight=image.size.height*0.5;
        image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        imageView.image =image;
        [self addSubview:imageView];
        self.menuTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 10, rect.size.width, rect.size.height-10)];
        self.menuTableView.backgroundColor=[UIColor clearColor];
        self.menuTableView.delegate=self;
        self.menuTableView.dataSource=self;
        self.menuTableView.bounces=NO;
        self.layer.anchorPoint = CGPointMake(1, 0);
        self.layer.position = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [self addSubview:self.menuTableView];
        [view addSubview:self];
        self.itemsClickedBlock=block;
    }
    return self;
}

-(void)showMenuView:(BOOL)isShow{
        [UIView animateWithDuration:0.3 animations:^{
            if (isShow) {
                self.alpha=1;
                self.transform=CGAffineTransformMakeScale(1.0, 1.0);
            }else{
                self.alpha=0.0;
                self.transform=CGAffineTransformMakeScale(0.01, 0.01);
            }
        } completion:^(BOOL finish){
            NSLog(@"self.frame is %@ ",NSStringFromCGRect(self.frame));
            //如果是不显示就移除
            if (!isShow) {
                [self removeFromSuperview];
            }
        }];
    
}


#pragma mark tableview delegate 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuTableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *menuCellIndentifer=@"menuCellIndentifer";
    MenuTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:menuCellIndentifer];
    if (cell==nil) {
        cell=[[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuCellIndentifer];
    }
    cell.modal=self.menuTableArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuViewModal *modal=self.menuTableArray[indexPath.row];
    MenuTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor redColor];
    if(self.itemsClickedBlock){
        self.itemsClickedBlock(modal.titleName,indexPath.row);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
}
-(void)setMenuTableArray:(NSArray *)menuTableArray{
    NSLog(@"menutablearray is %@ ",menuTableArray);
    NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:menuTableArray.count];
    for (NSDictionary *dic in menuTableArray) {
        MenuViewModal *modal=[[MenuViewModal alloc] init];
        modal.imageUrl=dic[@"imageUrl"];
        modal.titleName=dic[@"titleName"];
        [array addObject:modal];
    }
    //这里要用_menuTabelArray 进行赋值  不然用self.menuTableArray赋值又会调用这个方法死循环了  还有可能导致崩溃这里是崩溃
    _menuTableArray=array;
}
@end
