//
//  DGCSVGAAudioEntity.h
//  DGCSVGAPlayer
//
//  Created by PonyCui on 2018/10/18.
//  Copyright © 2018年 UED Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DGCSVGAProtoAudioEntity;

@interface DGCSVGAAudioEntity : NSObject

@property (nonatomic, readonly) NSString *audioKey;
@property (nonatomic, readonly) NSInteger startFrame;
@property (nonatomic, readonly) NSInteger endFrame;
@property (nonatomic, readonly) NSInteger startTime;
    
- (instancetype)initWithProtoObject:(DGCSVGAProtoAudioEntity *)protoObject;
    
@end
