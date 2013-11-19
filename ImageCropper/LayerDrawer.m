//
//  LayerDrawer.m
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import "LayerDrawer.h"
#import "ICImageObject.h"
@interface LayerDrawer()
@property (nonatomic, strong) ICImageObject *imageObject;
@property (nonatomic, weak) SelectionLayer *layer;
@property (assign, readwrite) BOOL clipped;
@property (nonatomic, strong)   UIBezierPath *path;

@property (nonatomic, assign) BOOL drawnLines;
@end

@implementation LayerDrawer

- (instancetype)init{
  if(self = [super init]){
    _imageObject = [[ICImageObject alloc] init];
  }
  return self;
}

- (id)initWithLayer:(SelectionLayer *)layer{
	if(self = [self init]){
		_layer = layer;
    [_layer setDelegate:self];
	}
	return self;
}

- (id)initWithLayer:(SelectionLayer *)layer andDelegate:(NSObject<LayerDrawerDelegate> *)aDelegate{
  if(self = [self initWithLayer:layer]){
    _delegate = aDelegate;
  }
  return self;
}

- (void)addPoint:(CGPoint)point{
  [[self imageObject] addPoint:point];
  [self.layer setNeedsDisplay];
}

- (void)clipImage{
  [self.layer setNeedsDisplay];
  if(_drawnLines)
  	self.clipped = YES;
  else
    self.clipped = NO;

}

- (void)resetClip{
  [self clearAllPoints];
}

- (void)clearAllPoints{
  [[self imageObject] clearAllPoints];
  self.clipped  = NO;
  [self.layer setNeedsDisplay];
}


- (void)drawLayer:(SelectionLayer *)layer inContext:(CGContextRef)ctx{
  
  UIGraphicsPushContext(ctx);
  UIImage *image;
 
  NSLog(@"val %f", layer.marching);
  self.path = [UIBezierPath bezierPath];
  [[UIColor blackColor] setStroke];
  
	_drawnLines = [self.imageObject makeLinesThroughPointsInPath:self.path];
  [self.path setLineWidth:10.0];
  if(_clipped && _drawnLines){
    [self.path addClip];
//    float dashPattern[] = {2,6,4,2, 3, 5, 2, 4, 6};
//    [self.path setLineDash:dashPattern count:4 phase:3];
//    [self.path setLineWidth:2];
  }
  
  
  if(( image = [self.imageObject image])){
  	[image drawInRect:[layer bounds]];
  }
  if(!_clipped )
  [self.path stroke];
  
  
  UIGraphicsPopContext();
}

- (void)drawImage:(UIImage *)image{
  if(image){
    [self.imageObject setImage:image];
  }
  [self.layer setNeedsDisplay];
}


-	(UIImage*)screenshotLayer{
  CGRect boundingBox =  CGPathGetBoundingBox([self.path CGPath]);
  [self.delegate layerDrawer:self didCropAndResizeToBoundingBox:boundingBox];
	UIGraphicsBeginImageContextWithOptions(self.layer.bounds.size, NO, [[UIScreen mainScreen] scale]);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  [self.layer renderInContext:context];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return image;
}

- (void)unclipImage{
  self.clipped = NO;
  [self.layer setNeedsDisplay];
}


- (void)drawMarchingAnts{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"marching"];
 	[animation setFromValue:@(0)];
  [animation setToValue:@(3)];
  [animation setDuration:1];
  [animation setRepeatCount:NSIntegerMax];
  [self.layer addAnimation:animation forKey:@"animation"];
}




- (void)removeMarchingAnts{
  [self.layer removeAnimationForKey:@"animation"];
}
@end
