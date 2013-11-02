//
//  ICImageObject.h
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICImageObject : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) NSArray *allPoints;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (void)addPoint:(CGPoint)point;
- (void)clearAllPoints;
- (BOOL)makeLinesThroughPointsInPath:(UIBezierPath*)path;

@end
