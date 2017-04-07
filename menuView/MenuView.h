//
//  MenuView.h
//  UIDemoCollection
//
//  Created by 123 on 16/8/11.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^ItemsClickedBlock)(NSString *str,NSUInteger index);
@interface MenuView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)ItemsClickedBlock itemsClickedBlock;
/**
 * description 在一个view上添加一个菜单最初是不显示的  需要调用showmenuview方法来控制显示与不显示
 * param rect  显示的位置frame
 * param view  在哪个父控件上显示
 * param dataArray 显示的数据源
 * block item点击的回调
 */
-(id)initWithFrame:(CGRect)rect showView:(UIView *)view withDataArray:(NSArray *)dataArray itemClickedBlock:(ItemsClickedBlock)block;
/**
 * 显示菜单的方法
 * isShow yes显示No不显示
 */
-(void)showMenuView:(BOOL)isShow;
@end

/**  下面是使用例子
*
 -(MenuView *)menuView{
 if (!_menuView) {
 NSDictionary *dict1 = @{@"imageUrl" : @"icon_button_affirm",
 @"titleName" : @"撤回"
 };
 NSDictionary *dict2 = @{@"imageUrl" : @"icon_button_recall",
 @"titleName" : @"确认"
 };
 //icon_button_record
 NSDictionary *dict3 = @{@"imageUrl" : @"icon_button_record",
 @"titleName" : @"记录"
 };
 menuArray = @[dict1,dict2,dict3];
 //        NSLog(@"menuArray is %@ ",menuArray);
 CGRect frame=CGRectMake(ScreenWIDTH*2/3, offsetTop-10, ScreenWIDTH/3, 44*menuArray.count+15);
 self.menuView=[[MenuView alloc] initWithFrame:frame showView:self.view withDataArray:menuArray itemClickedBlock:^(NSString *str,NSUInteger index){
 NSLog(@"菜单被点击的是 %@ %d ",str,index);
 }];
 }
 return _menuView;
 }
 -(void)rightButtonOnSelected:(UIButton *)button{
 isShowMenu=!isShowMenu;
 [self.menuView showMenuView:isShowMenu];
 if (!isShowMenu) {
 self.menuView =nil;
 }
 
 
 }
*/