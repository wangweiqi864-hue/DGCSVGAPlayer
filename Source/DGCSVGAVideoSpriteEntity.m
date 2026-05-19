//
//  DGCSVGAVideoSpriteEntity.m
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import "DGCSVGAVideoSpriteEntity.h"
#import "DGCSVGAVideoSpriteFrameEntity.h"
#import "DGCSVGABitmapLayer.h"
#import "DGCSVGAContentLayer.h"
#import "DGCSVGAVectorLayer.h"
#import "Svga.pbobjc.h"

@implementation DGCSVGAVideoSpriteEntity

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject {
    self = [super init];
    if (self) {
        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            NSString *imageKey = JSONObject[@"imageKey"];
            NSString *matteKey = JSONObject[@"matteKey"];
            NSArray<NSDictionary *> *JSONFrames = JSONObject[@"frames"];
            if ([imageKey isKindOfClass:[NSString class]] && [JSONFrames isKindOfClass:[NSArray class]]) {
                NSMutableArray<DGCSVGAVideoSpriteFrameEntity *> *frames = [[NSMutableArray alloc] init];
                [JSONFrames enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [frames addObject:[[DGCSVGAVideoSpriteFrameEntity alloc] initWithJSONObject:obj]];
                    }
                }];
                _imageKey = imageKey;
                _frames = frames;
                _matteKey = matteKey;
            }
        }
    }
    return self;
}

- (instancetype)initWithProtoObject:(DGCSVGAProtoSpriteEntity *)protoObject {
    self = [super init];
    if (self) {
        if ([protoObject isKindOfClass:[DGCSVGAProtoSpriteEntity class]]) {
            NSString *imageKey = protoObject.imageKey;
            NSString *matteKey = protoObject.matteKey;
            NSArray<NSDictionary *> *protoFrames = [protoObject.framesArray copy];
            if ([imageKey isKindOfClass:[NSString class]] && [protoFrames isKindOfClass:[NSArray class]]) {
                NSMutableArray<DGCSVGAVideoSpriteFrameEntity *> *frames = [[NSMutableArray alloc] init];
                [protoFrames enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[DGCSVGAProtoFrameEntity class]]) {
                        [frames addObject:[[DGCSVGAVideoSpriteFrameEntity alloc] initWithProtoObject:obj]];
                    }
                }];
                _imageKey = imageKey;
                _frames = frames;
                _matteKey = matteKey;
            }
        }
    }
    return self;
}

- (DGCSVGAContentLayer *)requestLayerWithBitmap:(UIImage *)bitmap {
    DGCSVGAContentLayer *layer = [[DGCSVGAContentLayer alloc] initWithFrames:self.frames];
    if (bitmap != nil) {
        layer.bitmapLayer = [[DGCSVGABitmapLayer alloc] initWithFrames:self.frames];
        layer.bitmapLayer.contents = (__bridge id _Nullable)([bitmap CGImage]);
    }
    layer.vectorLayer = [[DGCSVGAVectorLayer alloc] initWithFrames:self.frames];
    return layer;
}

@end
