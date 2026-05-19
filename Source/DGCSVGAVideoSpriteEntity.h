//
//  DGCSVGAVideoSpriteEntity.h
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/2/20.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DGCSVGAVideoSpriteFrameEntity, DGCSVGAContentLayer;
@class DGCSVGAProtoSpriteEntity;

@interface DGCSVGAVideoSpriteEntity : NSObject

@property (nonatomic, readonly) NSString *imageKey;
@property (nonatomic, readonly) NSArray<DGCSVGAVideoSpriteFrameEntity *> *frames;
@property (nonatomic, readonly) NSString *matteKey;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject;
- (instancetype)initWithProtoObject:(DGCSVGAProtoSpriteEntity *)protoObject;

- (DGCSVGAContentLayer *)requestLayerWithBitmap:(UIImage *)bitmap;

@end
