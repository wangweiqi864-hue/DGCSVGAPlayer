//
//  DGCSVGAAudioLayer.m
//  DGCSVGAPlayer
//
//  Created by PonyCui on 2018/10/18.
//  Copyright © 2018年 UED Center. All rights reserved.
//

#import "DGCSVGAAudioLayer.h"
#import "DGCSVGAAudioEntity.h"
#import "DGCSVGAVideoEntity.h"

@interface DGCSVGAAudioLayer ()

@property (nonatomic, readwrite) AVAudioPlayer *audioPlayer;
@property (nonatomic, readwrite) DGCSVGAAudioEntity *audioItem;

@end

@implementation DGCSVGAAudioLayer

- (instancetype)initWithAudioItem:(DGCSVGAAudioEntity *)audioItem videoItem:(DGCSVGAVideoEntity *)videoItem
{
    self = [super init];
    if (self) {
        _audioItem = audioItem;
        if (audioItem.audioKey != nil && videoItem.audiosData[audioItem.audioKey] != nil) {
            _audioPlayer = [[AVAudioPlayer alloc] initWithData:videoItem.audiosData[audioItem.audioKey]
                                                  fileTypeHint:@"mp3"
                                                         error:NULL];
            [_audioPlayer prepareToPlay];
        }
    }
    return self;
}

@end
