//
//  LBBarcodeScanner.m
//  LBTabbarController
//
//  Created by liubin on 16/11/1.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBBarcodeScanner.h"
#import <AVFoundation/AVFoundation.h>
#define  scanAnimationKey @"scanAnimation"
#import "Masonry.h"
#import "QRCodeGenerator.h"
@interface LBBarcodeScanner ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    UIView *_scanView;
    AVCaptureDevice *device;
}
@property (nonatomic,strong) UIView *scanLine;
@end
@implementation LBBarcodeScanner
-(void)startScanBarcode:(UIView *)scanView{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            //            UIAlertController *alert=[[UIAlertController alloc] init];
            
            NSLog(@"有相机权限");
        }else{
            NSLog(@"没有相机权限");
        }
    }];
    _scanView=scanView;
    //1.获取设备
    device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    //2.创建输入流
    AVCaptureDeviceInput *input=[[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (!input) {
        NSLog(@"没有可扫描的设备");
        return ;
    }
    //3.创建输出流
    AVCaptureMetadataOutput *output=[[AVCaptureMetadataOutput alloc] init];
    //设置输出流的属性
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //5.设置扫描的有效区域
    //    CGRect scanCrop=[self getScanCrop:self.view.window.bounds readerViewBounds:_scanView.frame];
    //    output.rectOfInterest=scanCrop;
    //4.初始化连接对象
    session=[[AVCaptureSession alloc] init];
    //5.设置连接属性
    [session setSessionPreset:AVCaptureSessionPresetHigh];//高采样率
    [session addInput:input];
    [session addOutput:output];
    //.设置扫码支持的编码格式(如下设置条形码和二维码兼容)  注意  设置扫描的类型必须在添加output后  不然有问题
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypeDataMatrixCode,
                                 AVMetadataObjectTypeITF14Code,
                                 AVMetadataObjectTypeInterleaved2of5Code,
                                 AVMetadataObjectTypeAztecCode,
                                 AVMetadataObjectTypePDF417Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeUPCECode];
    
    //6.创建扫描的图层
    layer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    layer.frame=scanView.layer.bounds;
    [scanView.layer addSublayer:layer];
    scanView.backgroundColor=[UIColor clearColor];
    [session startRunning];
    //设置扫描的方向  横屏竖屏
    layer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
    //设置扫描区域 默认是全屏
//    [output setRectOfInterest:CGRectMake((kScreenWidth-kScanWidth)/(2*kScreenWidth), (kScreenHeight-kScanWidth)/(2*kScreenHeight), kScanWidth/kScreenWidth, kScanWidth/kScreenHeight)];
    //    [output setRectOfInterest:CGRectMake(0.25, 0.25, 0.5, 0.5)];中心扫描
    if ([device isTorchModeSupported:AVCaptureTorchModeOn]) {
        [device setTorchMode:AVCaptureTorchModeOn];
    }else{
        NSLog(@"系统不支持打开砂光灯");
    }
    //添加屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/** 处理屏幕旋转后的扫描方向 */
-(void)orientationChanged:(NSNotification *)notification{
    NSLog(@"LBLog orientationChanged================");
    layer.connection.videoOrientation = [self videoOrientationFromCurrentDeviceOrientation];
}
- (AVCaptureVideoOrientation) videoOrientationFromCurrentDeviceOrientation {
    UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation){
//    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            return AVCaptureVideoOrientationPortrait;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            return AVCaptureVideoOrientationLandscapeLeft;
        }
        case UIInterfaceOrientationLandscapeRight: {
            return AVCaptureVideoOrientationLandscapeRight;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            return AVCaptureVideoOrientationPortraitUpsideDown;
        }
    }
    return AVCaptureVideoOrientationPortrait;
}
-(void)recognizeBarcodeImage:(UIViewController *)viewController{
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *pickerVC=[[UIImagePickerController alloc] init];
            pickerVC.delegate=self;
            pickerVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            [viewController presentViewController:pickerVC animated:YES completion:nil];
        }else{
            NSLog(@"LBLog 图库不可用");
        }
}
-(UIImage *)createBarcodeImage:(NSString *)content imageSize:(CGFloat)size{
    if (!content) return nil;
//    UIImage *img=[UIImage imageNamed:@"home_press"];
    
    UIImage *image=[QRCodeGenerator qrImageForString:content imageSize:size Topimg:nil];
    return image;
}
-(UIImage *)createBarcodeImageByAVFoundation:(NSString *)content imageSize:(CGSize)size{
    /** 生成指定大小的黑白二维码 */

        NSData *stringData = [content dataUsingEncoding:NSUTF8StringEncoding];
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        //    NSLog(@"%@",qrFilter.inputKeys);
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
        
        CIImage *qrImage = qrFilter.outputImage;
        //放大并绘制二维码 (上面生成的二维码很小，需要放大)
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        //翻转一下图片 不然生成的QRCode就是上下颠倒的
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
        UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRelease(cgImage);
        
        return codeImage;
    
}

/** 为二维码改变颜色 */
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor
{
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    
    return [UIImage imageWithCIImage:colorFilter.outputImage];
}
#pragma output delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"扫描===============");
    if (metadataObjects.count) {
        [self stopScan];
        AVMetadataMachineReadableCodeObject *metadataObject=[metadataObjects objectAtIndex:0];
        NSString *result=[metadataObject stringValue];
        NSLog(@"扫描结果是 %@ ",result);
        if (self.delegate) {
            [self.delegate barcodeScanResult:result barcodeScanner:self];
        }
    }
}
#pragma mark 图库的回调
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"图片选择取消");
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //1.初始化一个检测器 设置检测精度
    CIDetector *detector=[CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSArray *featuresArr= [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (featuresArr.count) {
            CIQRCodeFeature *feature=featuresArr[0];
            NSString *result=[feature messageString];
            NSLog(@"途中二维码的信息是 ：%@",result);
            if (self.delegate) {
                [self.delegate barcodeRecognizeImageResult:result barcodeScanner:self];
            }
        }
    }];
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    NSLog(@"getScanCrop rect is %@ ",NSStringFromCGRect(CGRectMake(x, y, width, height)));
    return CGRectMake(x, y, width, height);
    
}

-(void)startScan{
    if (session) {
        [session startRunning];
        [self startScanLineAnimation:YES];
    }
}
-(void)stopScan{
    if (session) {
        if ([session isRunning]) {
            [session stopRunning];
            [self startScanLineAnimation:NO];
        }
    }
}
//描动画
-(void)startScanLineAnimation:(BOOL)isStart{
    if(isStart){
        self.scanLine.hidden=NO;
        CABasicAnimation *scanAnimation=[[CABasicAnimation alloc] init];
        CGFloat height=_scanView.frame.size.height;
        scanAnimation.keyPath=@"transform.translation.y";
        scanAnimation.byValue=@(height);
        scanAnimation.duration=1.5f;
        scanAnimation.repeatCount=MAXFLOAT;
        [self.scanLine.layer addAnimation:scanAnimation forKey:scanAnimationKey];
    }else{
        //判断是否有动画 有动画移除动画
        CABasicAnimation *scanAnimation=[CABasicAnimation animationWithKeyPath:scanAnimationKey];
        if (scanAnimation) {
            [self.scanLine.layer removeAnimationForKey:scanAnimationKey];
            self.scanLine.hidden=YES;
        }
    }
    
}
#pragma mark 懒加载
-(UIView *)scanLine{
    if (!_scanLine) {
        _scanLine=[[UIView alloc] init];
        //        _scanLine.layer.borderWidth=1;
        //        _scanLine.layer.borderColor=[UIColor blueColor].CGColor;
        //        CGRect rect=_scanView.frame;
        _scanLine.backgroundColor=[UIColor greenColor];
        //        [_scanLine showRedBorder];
        //        _scanLine.frame=CGRectMake(0, 0, rect.size.width, 5);
        [_scanView addSubview:_scanLine];
        [_scanLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scanView);
            make.left.equalTo(_scanView);
            make.width.equalTo(_scanView);
            make.height.mas_equalTo(2);
        }];
        //        _scanLine.hidden=YES;
    }
    return _scanLine;
}
-(void)setTorchModeOn{
    if (device) {
        [device setTorchMode:AVCaptureTorchModeOn];
    }
}
-(void)setTorchModeOff{
    if (device) {
        [device setTorchMode:AVCaptureTorchModeOff];
    }
}
-(void)dealloc{
    NSLog(@"LBBarcodeScanner  dealloc=================================");
}
@end
