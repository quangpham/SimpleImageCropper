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
@property (nonatomic, weak) CALayer *layer;
@property (assign, readwrite) BOOL clipped;
@property (nonatomic, assign) BOOL drawnLines;
@end

@implementation LayerDrawer

- (instancetype)init{
  if(self = [super init]){
    _imageObject = [[ICImageObject alloc] init];
  }
  return self;
}

- (id)initWithLayer:(CALayer *)layer{
	if(self = [self init]){
		_layer = layer;
    [_layer setDelegate:self];
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


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
  
  UIGraphicsPushContext(ctx);
  UIImage *image;
 
  
  UIBezierPath *path = [UIBezierPath bezierPath];
  [[UIColor blackColor] setStroke];
  
	_drawnLines = [self.imageObject makeLinesThroughPointsInPath:path];
  [path setLineWidth:10.0];
  if(_clipped && _drawnLines)
    [path addClip];
  
  
  if(( image = [self.imageObject image])){
  	[image drawInRect:[layer bounds]];
  }
  if(!_clipped)
  [path stroke];
  
  UIGraphicsPopContext();
}

- (void)drawImage:(UIImage *)image{
  if(image){
    [self.imageObject setImage:image];
  }
  [self.layer setNeedsDisplay];
}

- (void)unclipImage{
  self.clipped = NO;
  [self.layer setNeedsDisplay];
}


@end
