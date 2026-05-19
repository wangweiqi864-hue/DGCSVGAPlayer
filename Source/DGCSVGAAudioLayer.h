//
//  DGCSVGAAudioLayer.h
//  DGCSVGAPlayer
//
//  Created by PonyCui on 2018/10/18.
//  Copyright © 2018年 UED Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class DGCSVGAAudioEntity, DGCSVGAVideoEntity;

@interface DGCSVGAAudioLayer : NSObject

@property (nonatomic, readonly) AVAudioPlayer *audioPlayer;
@property (nonatomic, readonly) DGCSVGAAudioEntity *audioItem;
@property (nonatomic, assign) BOOL audioPlaying;


- (instancetype)initWithAudioItem:(DGCSVGAAudioEntity *)audioItem videoItem:(DGCSVGAVideoEntity *)videoItem;

@end
