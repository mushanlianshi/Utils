//
//  LBMusicPlayer.h
//  LBTabbarController
//
//  Created by liubin on 16/11/9.
//  Copyright © 2016年 lb. All rights reserved.
//


typedef NS_ENUM(NSUInteger,LBMusicPlayState){
    LBMusicPlayStateFinished=1,
    LBMusicPlayStateBuffering=2,
    LBMusicPlayStateCanPlay=3,
    LBMusicPlayStateFailed=4,//加载失败
    LBMusicPlayStateUnknow=5,
    LBMusicPlayStatePaused=6,
    LBMusicPlayStatePlaying=7,
};

@class LBMusicPlayer;
@protocol LBMusicPlayerDelegate <NSObject>
-(void)musicPlayerDidFinished:(LBMusicPlayer *)player;
-(void)musicPlayerCanGetTotalLength:(LBMusicPlayer *)player totalLength:(NSTimeInterval)totalLength;
-(void)musicPlayerLoadTimeLength:(LBMusicPlayer *)player loadLength:(NSTimeInterval)loadedLength;
-(void)musicPlayerCurrentTime:(LBMusicPlayer *)player currentTime:(NSTimeInterval)currentTime;
-(void)musicPlayerStateChanged:(LBMusicPlayer *)player state:(LBMusicPlayState)state;
@end

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 * 封装了播放音乐的类
 */
@interface LBMusicPlayer : NSObject

@property (nonatomic,strong)AVPlayer *player;
//当前播放的item
@property (nonatomic,strong)AVPlayerItem *currentPlayItem;
//缓冲的长度
@property (nonatomic,assign)NSTimeInterval loadTotalTime;
//音乐总时间
@property (nonatomic,assign)NSTimeInterval totalMusicTime;
//当前播放时间
@property (nonatomic,assign)NSTimeInterval currentMusicTime;
//当前歌曲进度监听者
@property(nonatomic,strong) id timeObserver;
@property(nonatomic,assign) LBMusicPlayState state;
@property(nonatomic,weak) id<LBMusicPlayerDelegate> delegate;

//设置锁屏显示信息
-(void)setLockScreenInfoMusicName:(NSString *)name artist:(NSString *)artist lockImage:(UIImage *)image totalTime:(NSString *)totalTime;

-(instancetype)initWithUrl:(NSString *)url;

-(void)pause;
-(void)play;
-(void)nextWithUrl:(NSString *)murl;
-(void)seekToTime:(NSUInteger)seekTime;
/**
 * 结束  释放资源
 */
-(void)stop;
@end
