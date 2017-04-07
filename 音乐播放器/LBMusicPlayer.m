//
//  LBMusicPlayer.m
//  LBTabbarController
//
//  Created by liubin on 16/11/9.
//  Copyright © 2016年 lb. All rights reserved.
//

#import "LBMusicPlayer.h"

@implementation LBMusicPlayer
-(instancetype)init{
    if(self=[super init]){
        //获取音频会话
        AVAudioSession *session = [AVAudioSession sharedInstance];
        //设置类型是播放。
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //激活音频会话。
        [session setActive:YES error:nil];
    }
    return self;
}
-(instancetype)initWithUrl:(NSString *)url{
    if (self=[super init]) {
        AVAudioSession *session=[AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        NSURL *musicUrl;
        NSLog(@"url ---- %@",url);
        //防止汉子乱码
//        url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"url ---- %p",url);
        if ([url hasPrefix:@"http"]) {
            musicUrl=[NSURL URLWithString:url];
        }else{
            musicUrl=[NSURL fileURLWithPath:url];
        }
        self.currentPlayItem=[[AVPlayerItem alloc] initWithURL:musicUrl];
        self.player=[[AVPlayer alloc] initWithPlayerItem:self.currentPlayItem];
        [self.player play];
        //添加状态和缓冲监控
        [self addMusicObservers];
    }
    return self;
}


#pragma mark 监控播放状态
//typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
//    AVPlayerItemStatusUnknown,//未知状态
//    AVPlayerItemStatusReadyToPlay,//准备播放
//    AVPlayerItemStatusFailed//加载失败
//};
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    //1.判断是不是监控状态的
    if ([keyPath isEqualToString:@"status"]) {
        //2.//注意这里查看的是self.player.status属性
        NSLog(@"status changed %@ %@ ",object,change);
        switch (playerItem.status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"未知状态====");
                self.state=LBMusicPlayStateUnknow;
                break;
                
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备播放====");
                self.state=LBMusicPlayStateCanPlay;
                //获取视频信息
                CMTime duration = playerItem.duration;// 获取视频总长度
//                self.totalMusicTime = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
                //或则
                self.totalMusicTime=CMTimeGetSeconds(duration);
                if ([self.delegate respondsToSelector:@selector(musicPlayerCanGetTotalLength:totalLength:)]) {
                    [self.delegate musicPlayerCanGetTotalLength:self totalLength:self.totalMusicTime];
                }
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"加载失败====");
                self.state=LBMusicPlayStateFailed;
                [self showErrorInfo:@"加载失败"];
                break;
            default:
                break;
        }
    }
    //如果是缓冲的监控
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *timeRanges=self.player.currentItem.loadedTimeRanges;
        //1.本次缓冲的时间范围
        CMTimeRange timeRange=[timeRanges[0] CMTimeRangeValue];
        //2.缓冲总的缓冲长度
         self.loadTotalTime= CMTimeGetSeconds(timeRange.start)+CMTimeGetSeconds(timeRange.duration);
        //3.音乐的总长度
//         self.totalMusicTime=CMTimeGetSeconds(self.player.currentItem.duration);
//        NSLog(@"缓冲的总长度是 %f %f ",self.loadTotalTime,self.totalMusicTime);
        if ([self.delegate respondsToSelector:@selector(musicPlayerLoadTimeLength:loadLength:)]) {
            [self.delegate musicPlayerLoadTimeLength:self loadLength:self.loadTotalTime];
        }
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        NSLog(@"缓冲不足暂停了");
        self.state=LBMusicPlayStateBuffering;
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        NSLog(@"缓冲达到可播放程度了");
        self.state=LBMusicPlayStateCanPlay;
        //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [_player play];
        self.state=LBMusicPlayStatePlaying;
    }
}

#pragma  mark 移除监控
-(void)removeMusicObservers{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}
//移除监听音乐播放进度
-(void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}
-(void)addMusicObservers{
    //添加当前播放的状态监控  注意结束或则下一首之前移除监控
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //添加当前缓冲的监控
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //添加缓冲不了的监听
    [self.player.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    //添加缓冲可以播放的监听
    [self.player.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    //添加当前播放时间的监控
    [self removeTimeObserver];
    __weak typeof(self) weakSelf=self;
    self.timeObserver=[self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"当前播放时间 :%f ",CMTimeGetSeconds(time));
         weakSelf.currentMusicTime=CMTimeGetSeconds(time);
        if ([weakSelf.delegate respondsToSelector:@selector(musicPlayerCurrentTime:currentTime:)]) {
            [weakSelf.delegate musicPlayerCurrentTime:weakSelf currentTime:weakSelf.currentMusicTime];
        }
    }];
    //添加播放结束的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)musicPlayDidFinished:(NSNotification *)notification{
    self.state=LBMusicPlayStateFinished;
    if ([self.delegate respondsToSelector:@selector(musicPlayerDidFinished:)]) {
        [self.delegate musicPlayerDidFinished:self];
    }
    NSLog(@"音乐播放结束");
}
#pragma mark 控制播放方法
-(void)pause{
    [self.player pause];
    self.state=LBMusicPlayStatePaused;
}
-(void)play{
    [self.player play];
    self.state=LBMusicPlayStatePlaying;
}
-(void)nextWithUrl:(NSString *)murl{
    murl=[murl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url;
    if ([murl hasPrefix:@"http"]) {
        NSLog(@"网络歌曲=====");
        url=[NSURL URLWithString:murl];
    }else{
        NSLog(@"本地网络歌曲=====");
        url=[NSURL fileURLWithPath:murl];
    }
    [self removeMusicObservers];
    
    AVPlayerItem *item=[[AVPlayerItem alloc] initWithURL:url];
    self.currentPlayItem=item;
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self addMusicObservers];
}
-(void)seekToTime:(NSUInteger)seekTime{
//    CMTime time=self.player.currentItem.duration;
    [self.player seekToTime:CMTimeMake(seekTime, 1.0)];
}


/**
 * 结束  释放资源
 */
-(void)stop{
    [self removeMusicObservers];
    [self removeTimeObserver];
    self.player=nil;
    self.currentPlayItem=nil;
}
-(void)showErrorInfo:(NSString *)info{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)setState:(LBMusicPlayState)state{
    if ([self.delegate respondsToSelector:@selector(musicPlayerStateChanged:state:)]) {
        [self.delegate musicPlayerStateChanged:self state:state];
    }
    _state=state;
}

#pragma mark 设置锁屏信息
-(void)setLockScreenInfoMusicName:(NSString *)name artist:(NSString *)artist lockImage:(UIImage *)image totalTime:(NSString *)totalTime{
    //1.获取锁屏中心
    MPNowPlayingInfoCenter *playerCenter=[MPNowPlayingInfoCenter defaultCenter];
    //2.初始化一个存放音乐信息的字典
    NSMutableDictionary *infoDic=[[NSMutableDictionary alloc] init];
    if (name) {
        [infoDic setObject:name forKey:MPMediaItemPropertyTitle];
    }
    if (artist) {
        [infoDic setObject:artist forKey:MPMediaItemPropertyArtist];
    }
    if (image) {
        MPMediaItemArtwork *artWork=[[MPMediaItemArtwork alloc] initWithImage:image];
        [infoDic setObject:artWork forKey:MPMediaItemPropertyArtwork];
    }
    if(totalTime){
        [infoDic setObject:totalTime forKey:MPMediaItemPropertyPlaybackDuration];
    }
    //3.设置锁屏信息
    [playerCenter setNowPlayingInfo:infoDic];
    
    //4.设置远程交互
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}



#pragma mark 监听远程交互的方法  需要在一个vc中实现
////监听远程交互方法
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event
//{
//    
//    switch (event.subtype) {
//            //播放
//        case UIEventSubtypeRemoteControlPlay:{
//            [self.player play];
//        }
//            break;
//            //停止
//        case UIEventSubtypeRemoteControlPause:{
//            [self.player pause];
//        }
//            break;
//            //下一首
//        case UIEventSubtypeRemoteControlNextTrack:
//            [self nextMusicButton:nil];
//            break;
//            //上一首
//        case UIEventSubtypeRemoteControlPreviousTrack:
//            [self backMusicButton:nil];
//            break;
//            
//        default:
//            break;
//    }
//}

//#pragma mark 懒加载
//-(AVPlayer *)player{
//    if (_player==nil) {
//        _player=[[AVPlayer alloc] init];
//    }
//    return _player;
//}
-(void)dealloc{
    NSLog(@"音乐播放器dealloc=====");
    [self stop];
}
@end
