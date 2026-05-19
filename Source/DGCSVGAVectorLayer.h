//
//  DGCSVGAVectorLayer.h
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class DGCSVGAVideoSpriteFrameEntity;

@interface DGCSVGAVectorLayer : CALayer

- (instancetype)initWithFrames:(NSArray<DGCSVGAVideoSpriteFrameEntity *> *)frames;

- (void)stepToFrame:(NSInteger)frame;

@end
