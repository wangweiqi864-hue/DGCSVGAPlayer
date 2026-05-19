//
//  DGCSVGAVideoEntity.m
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 16/6/17.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "DGCSVGAVideoEntity.h"
#import "DGCSVGABezierPath.h"
#import "DGCSVGAVideoSpriteEntity.h"
#import "DGCSVGAAudioEntity.h"
#import "Svga.pbobjc.h"

#define MP3_MAGIC_NUMBER "ID3"


@interface UIImage (Ext)

- (UIImage *)imageByResizeToSize:(CGSize)size;

@end

@implementation UIImage (Ext)

- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@interface DGCSVGAVideoEntity ()

@property (nonatomic, assign) CGSize videoSize;
@property (nonatomic, assign) int FPS;
@property (nonatomic, assign) int frames;
@property (nonatomic, copy) NSDictionary<NSString *, UIImage *> *images;
@property (nonatomic, copy) NSDictionary<NSString *, NSData *> *audiosData;
@property (nonatomic, copy) NSArray<DGCSVGAVideoSpriteEntity *> *sprites;
@property (nonatomic, copy) NSArray<DGCSVGAAudioEntity *> *audios;
@property (nonatomic, copy) NSString *cacheDir;

@end

@implementation DGCSVGAVideoEntity

static NSCache *videoCache;
static NSMapTable * weakCache;
static dispatch_semaphore_t videoSemaphore;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoCache = [[NSCache alloc] init];
        weakCache = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
        valueOptions:NSPointerFunctionsWeakMemory
            capacity:64];
        videoSemaphore = dispatch_semaphore_create(1);
    });
}

- (instancetype)initWithJSONObject:(NSDictionary *)JSONObject cacheDir:(NSString *)cacheDir {
    self = [super init];
    if (self) {
        _videoSize = CGSizeMake(100, 100);
        _FPS = 20;
        _images = @{};
        _cacheDir = cacheDir;
        [self resetMovieWithJSONObject:JSONObject];
    }
    return self;
}

- (void)resetMovieWithJSONObject:(NSDictionary *)JSONObject {
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *movieObject = JSONObject[@"movie"];
        if ([movieObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *viewBox = movieObject[@"viewBox"];
            if ([viewBox isKindOfClass:[NSDictionary class]]) {
                NSNumber *width = viewBox[@"width"];
                NSNumber *height = viewBox[@"height"];
                if ([width isKindOfClass:[NSNumber class]] && [height isKindOfClass:[NSNumber class]]) {
                    _videoSize = CGSizeMake(width.floatValue, height.floatValue);
                }
            }
            NSNumber *FPS = movieObject[@"fps"];
            if ([FPS isKindOfClass:[NSNumber class]]) {
                _FPS = [FPS intValue];
            }
            NSNumber *frames = movieObject[@"frames"];
            if ([frames isKindOfClass:[NSNumber class]]) {
                _frames = [frames intValue];
            }
        }
    }
}

- (void)resetImagesWithJSONObject:(NSDictionary *)JSONObject {
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary<NSString *, UIImage *> *images = [[NSMutableDictionary alloc] init];
        NSDictionary<NSString *, NSString *> *JSONImages = JSONObject[@"images"];
        if ([JSONImages isKindOfClass:[NSDictionary class]]) {
            [JSONImages enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *filePath = [self.cacheDir stringByAppendingFormat:@"/%@.png", obj];
//                    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                    NSData *imageData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
                    if (imageData != nil) {
                        UIImage *image = [[UIImage alloc] initWithData:imageData scale:2.0];
                        if (image != nil) {
                            [images setObject:image forKey:[key stringByDeletingPathExtension]];
                        }
                    }
                }
            }];
        }
        self.images = images;
    }
}

- (void)resetSpritesWithJSONObject:(NSDictionary *)JSONObject {
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableArray<DGCSVGAVideoSpriteEntity *> *sprites = [[NSMutableArray alloc] init];
        NSArray<NSDictionary *> *JSONSprites = JSONObject[@"sprites"];
        if ([JSONSprites isKindOfClass:[NSArray class]]) {
            [JSONSprites enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    DGCSVGAVideoSpriteEntity *spriteItem = [[DGCSVGAVideoSpriteEntity alloc] initWithJSONObject:obj];
                    [sprites addObject:spriteItem];
                }
            }];
        }
        self.sprites = sprites;
    }
}

- (instancetype)initWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject cacheDir:(NSString *)cacheDir {
    self = [super init];
    if (self) {
        _videoSize = CGSizeMake(100, 100);
        _FPS = 20;
        _images = @{};
        _cacheDir = cacheDir;
        [self resetMovieWithProtoObject:protoObject];
    }
    return self;
}

- (void)resetMovieWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject {
    if (protoObject.hasParams) {
        self.videoSize = CGSizeMake((CGFloat)protoObject.params.viewBoxWidth, (CGFloat)protoObject.params.viewBoxHeight);
        self.FPS = (int)protoObject.params.fps;
        self.frames = (int)protoObject.params.frames;
    }
}

+ (BOOL)isMP3Data:(NSData *)data {
    BOOL result = NO;
    if (!strncmp([data bytes], MP3_MAGIC_NUMBER, strlen(MP3_MAGIC_NUMBER))) {
        result = YES;
    }
    return result;
}

- (void)resetImagesWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject {
    NSMutableDictionary<NSString *, UIImage *> *images = [[NSMutableDictionary alloc] init];
    NSMutableDictionary<NSString *, NSData *> *audiosData = [[NSMutableDictionary alloc] init];
    NSDictionary *protoImages = [protoObject.images copy];
    for (NSString *key in protoImages) {
        NSString *fileName = [[NSString alloc] initWithData:protoImages[key] encoding:NSUTF8StringEncoding];
        if (fileName != nil) {
            NSString *filePath = [self.cacheDir stringByAppendingFormat:@"/%@.png", fileName];
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                filePath = [self.cacheDir stringByAppendingFormat:@"/%@", fileName];
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//                NSData *imageData = [NSData dataWithContentsOfFile:filePath];
                NSData *imageData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
                if (imageData != nil) {
                    UIImage *image = [[UIImage alloc] initWithData:imageData scale:2.0];
                    if (image != nil) {
                        [images setObject:image forKey:key];
                    }
                }
            }
        }
        else if ([protoImages[key] isKindOfClass:[NSData class]]) {
            if ([DGCSVGAVideoEntity isMP3Data:protoImages[key]]) {
                // mp3
                [audiosData setObject:protoImages[key] forKey:key];
            } else {
                UIImage *image = [[UIImage alloc] initWithData:protoImages[key] scale:2.0];
                if (image != nil) {
//                    image = [image imageByResizeToSize:image.size];
                    [images setObject:image forKey:key];
                }
            }
        }
    }
    self.images = images;
    self.audiosData = audiosData;
}



- (void)resetSpritesWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject {
    NSMutableArray<DGCSVGAVideoSpriteEntity *> *sprites = [[NSMutableArray alloc] init];
    NSArray *protoSprites = [protoObject.spritesArray copy];
    [protoSprites enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DGCSVGAProtoSpriteEntity class]]) {
            DGCSVGAVideoSpriteEntity *spriteItem = [[DGCSVGAVideoSpriteEntity alloc] initWithProtoObject:obj];
            [sprites addObject:spriteItem];
        }
    }];
    self.sprites = sprites;
}

- (void)resetAudiosWithProtoObject:(DGCSVGAProtoMovieEntity *)protoObject {
    NSMutableArray<DGCSVGAAudioEntity *> *audios = [[NSMutableArray alloc] init];
    NSArray *protoAudios = [protoObject.audiosArray copy];
    [protoAudios enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[DGCSVGAProtoAudioEntity class]]) {
            DGCSVGAAudioEntity *audioItem = [[DGCSVGAAudioEntity alloc] initWithProtoObject:obj];
            [audios addObject:audioItem];
        }
    }];
    self.audios = audios;
}

+ (DGCSVGAVideoEntity *)readCache:(NSString *)cacheKey {
    dispatch_semaphore_wait(videoSemaphore, DISPATCH_TIME_FOREVER);
    DGCSVGAVideoEntity * object = [videoCache objectForKey:cacheKey];
    if (!object) {
        object = [weakCache objectForKey:cacheKey];
    }
    dispatch_semaphore_signal(videoSemaphore);

    return  object;
}

- (void)saveCache:(NSString *)cacheKey {
    dispatch_semaphore_wait(videoSemaphore, DISPATCH_TIME_FOREVER);
    [videoCache setObject:self forKey:cacheKey];
    dispatch_semaphore_signal(videoSemaphore);
}

- (void)saveWeakCache:(NSString *)cacheKey {
    dispatch_semaphore_wait(videoSemaphore, DISPATCH_TIME_FOREVER);
    [weakCache setObject:self forKey:cacheKey];
    dispatch_semaphore_signal(videoSemaphore);
}

@end

@interface DGCSVGAVideoSpriteEntity()

@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, copy) NSArray<DGCSVGAVideoSpriteFrameEntity *> *frames;
@property (nonatomic, copy) NSString *matteKey;

@end

