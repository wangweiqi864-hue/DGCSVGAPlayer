//
//  DGCSVGAVideoEntity.h
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 16/6/17.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DGCSVGAVideoEntity, DGCSVGAVideoSpriteEntity, DGCSVGAVideoSpriteFrameEntity, DGCSVGABitmapLayer, DGCSVGAVectorLayer, DGCSVGAAudioEntity;
@class DGCSVGAProtoMovieEntity;

@interface DGCSVGAVideoEntity : NSObject

@property (nonatomic, readonly) CGSize videoSize;
@property (nonatomic, readonly) int FPS;
@property (nonatomic, readonly) int frames;
@property (nonatomic, readonly) NSDictionary<NSString *, UIImage *> *images;
@property (nonatomic, readonly) NSDictionary<NSString *, NSData *> *audiosData;
@property (nonatomic, readonly) NSArray<DGCSVGAVideoSpriteEntity *> *sprites;
@property (nonatomic, readonly) NSArray<DGCSVGAAudioEntity *> *audios;

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject cacheDir:(NSString *)cacheDir;
- (void)resetImagesWithJSONObject:(NSDictionary *)JSONObject;
- (void)resetSpritesWithJSONObject:(NSDictionary *)JSONObject;

- (instancetype)initWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject cacheDir:(NSString *)cacheDir;
- (void)resetImagesWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject;
- (void)resetSpritesWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject;
- (void)resetAudiosWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject;

+ (DGCSVGAVideoEntity *)readCache:(NSString *)cacheKey;
// NSCache缓存
- (void)saveCache:(NSString *)cacheKey;
// NSMapTable弱缓存
- (void)saveWeakCache:(NSString *)cacheKey;
@end


