//
//  LayerDrawer.h
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ICImageObject;

@interface LayerDrawer : NSObject

@property (nonatomic, readonly) BOOL clipped;


- (void)addPoint:(CGPoint)point;
- (void)clearAllPoints;

- (void)drawImage:(UIImage*)image;
- (id)initWithLayer:(CALayer*)layer;
- (void)clipImage;
- (void)unclipImage;
- (void)resetClip;

@end
