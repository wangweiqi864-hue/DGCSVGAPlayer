//
//  DGCSVGAExporter.h
//  DGCSVGAPlayer
//
//  Created by 崔明辉 on 2017/3/7.
//  Copyright © 2017年 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DGCSVGAVideoEntity;

@interface DGCSVGAExporter : NSObject

@property (nonatomic, strong) DGCSVGAVideoEntity *videoItem;

- (NSArray<UIImage *> *)toImages;

- (void)saveImages:(NSString *)toPath filePrefix:(NSString *)filePrefix;

@end
