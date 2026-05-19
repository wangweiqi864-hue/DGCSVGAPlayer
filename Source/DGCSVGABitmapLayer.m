//
//  DGCSVGABitmapLayer.m
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "DGCSVGABitmapLayer.h"
#import "DGCSVGABezierPath.h"
#import "DGCSVGAVideoSpriteFrameEntity.h"

@interface DGCSVGABitmapLayer ()

@property (nonatomic, strong) NSArray<DGCSVGAVideoSpriteFrameEntity *> *frames;
@property (nonatomic, assign) NSInteger drawedFrame;

@end

@implementation DGCSVGABitmapLayer

- (instancetype)initWithFrames:(NSArray *)frames {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.masksToBounds = NO;
        self.contentsGravity = kCAGravityResizeAspect;
        _frames = frames;
        [self stepToFrame:0];
    }
    return self;
}

- (void)stepToFrame:(NSInteger)frame {
}

@end
