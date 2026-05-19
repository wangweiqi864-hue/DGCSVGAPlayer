//
//  DGCSVGAImageView.m
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/10/17.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "DGCSVGAImageView.h"
#import "DGCSVGAParser.h"

static DGCSVGAParser *sharedParser;

@implementation DGCSVGAImageView

+ (void)load {
    sharedParser = [DGCSVGAParser new];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _autoPlay = YES;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    if ([imageName hasPrefix:@"http://"] || [imageName hasPrefix:@"https://"]) {
        [sharedParser parseWithURL:[NSURL URLWithString:imageName] completionBlock:^(DGCSVGAVideoEntity * _Nullable videoItem) {
            [self setVideoItem:videoItem];
            if (self.autoPlay) {
                [self startAnimation];
            }
        } failureBlock:nil];
    }
    else {
        [sharedParser parseWithNamed:imageName inBundle:nil completionBlock:^(DGCSVGAVideoEntity * _Nonnull videoItem) {
            [self setVideoItem:videoItem];
            if (self.autoPlay) {
                [self startAnimation];
            }
        } failureBlock:nil];
    }
}

@end
