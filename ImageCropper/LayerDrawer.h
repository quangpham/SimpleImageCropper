//
//  LayerDrawer.h
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SelectionLayer.h"

@class ICImageObject;


@protocol LayerDrawerDelegate;
@interface LayerDrawer : NSObject

@property (nonatomic, weak) NSObject<LayerDrawerDelegate> * delegate;
@property (nonatomic, readonly) BOOL clipped;

- (id)initWithLayer:(SelectionLayer*)layer andDelegate:(NSObject<LayerDrawerDelegate>*)aDelegate;


- (UIImage*)screenshotLayer;

- (void)addPoint:(CGPoint)point;
- (void)clearAllPoints;

- (void)drawImage:(UIImage*)image;
- (void)clipImage;
- (void)unclipImage;
- (void)resetClip;


- (void)drawMarchingAnts;

- (void)removeMarchingAnts;


@end

@protocol LayerDrawerDelegate <NSObject>

- (void)layerDrawer:(LayerDrawer*)drawer didCropAndResizeToBoundingBox:(CGRect)rect;

@end
