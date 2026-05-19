//
//  DGCSVGAContentLayer.h
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/2/22.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGCSVGAPlayer.h"

@class DGCSVGABitmapLayer, DGCSVGAVectorLayer, DGCSVGAVideoSpriteFrameEntity;

@interface DGCSVGAContentLayer : CALayer

@property (nonatomic, strong) NSString *imageKey;
@property (nonatomic, assign) BOOL dynamicHidden;
@property (nonatomic, copy) DGCSVGAPlayerDynamicDrawingBlock dynamicDrawingBlock;
@property (nonatomic, strong) DGCSVGABitmapLayer *bitmapLayer;
@property (nonatomic, strong) DGCSVGAVectorLayer *vectorLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

- (instancetype)initWithFrames:(NSArray<DGCSVGAVideoSpriteFrameEntity *> *)frames;

- (void)stepToFrame:(NSInteger)frame;
- (void)resetTextLayerProperties:(NSAttributedString *)attributedString;

@end
