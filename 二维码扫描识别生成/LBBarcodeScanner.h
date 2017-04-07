//
//  LBBarcodeScanner.h
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,BarcodeScanType){
    BarcodeRecognizeBarcodeImage,//识别图库中的二维码
    BarcodeCreateBarcodeImage, //生成二维码 需要借助liqrencode这个库
};
@class LBBarcodeScanner;
@protocol LBBarcodeScannerDelegate <NSObject>
/**
 * 扫描二维码结果的代理方法
 */
-(void)barcodeScanResult:(NSString *)scanResult barcodeScanner:(LBBarcodeScanner *)scanner;
/**
 * 识别图库中二维码图片的结果代理方法
 */
-(void)barcodeRecognizeImageResult:(NSString *)result barcodeScanner:(LBBarcodeScanner *)scanner;
@end

@interface LBBarcodeScanner : NSObject
//代理  用来把扫描结果传递过去 的
@property (nonatomic,weak)id<LBBarcodeScannerDelegate> delegate;
/**
 * 扫描二维码的参数 第一个是二维码扫描区的view
 * 注意 需要把 LBBarcodeScanner设置成属性  不然会被释放。。。。需要修改的地方
 */
//-(LBBarcodeScanner *)initWithScanView:(UIView *)scanView;
//-(LBBarcodeScanner *)initRecognizeBarcoImage:(UIViewController *)viewController;
//-(LBBarcodeScanner *)initWithBarcodeType:(BarcodeScanType)type withViewController:(UIViewController *)viewController;
-(void)startScanBarcode:(UIView *)scanView;
-(void)recognizeBarcodeImage:(UIViewController *)viewController;
-(UIImage *)createBarcodeImage:(NSString *)content imageSize:(CGFloat)size;
//用系统自带的框架实现二维码的生成
-(UIImage *)createBarcodeImageByAVFoundation:(NSString *)content imageSize:(CGSize)size;
/** 为二维码改变颜色 */
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor;
-(void)startScan;
-(void)stopScan;
-(void)setTorchModeOn;
-(void)setTorchModeOff;
@end
