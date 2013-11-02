//
//  ICImageObject.m
//  ImageCropper
//
//  Created by Sandeep on 02/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import "ICImageObject.h"

@interface ICImageObject ()
	@property (nonatomic, strong, readwrite) NSMutableArray *points;
@end

@implementation ICImageObject

- (id)init{
  if(!(self = [super init])) return nil;
  
  _points = [[NSMutableArray alloc] init];
  
  return self;
}
- (NSArray*)allPoints{
  return [_points copy];
}


- (id)objectAtIndexedSubscript:(NSUInteger)index{
  return [_points objectAtIndex:index];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
  [_points insertObject:obj atIndex:idx];
}


- (void)clearAllPoints{
  _points = [NSMutableArray array];
}

- (void)addPoint:(CGPoint)point{
  [self.points addObject:[NSValue valueWithCGPoint:point]];
}

- (BOOL)makeLinesThroughPointsInPath:(UIBezierPath *)path{
  if([self.allPoints count] > 1){
    NSValue *firstObject =  [self.allPoints firstObject];
    CGPoint point = [firstObject CGPointValue];
    [path moveToPoint:point];
    NSArray *tempPoints  = [self.allPoints subarrayWithRange:NSMakeRange(1, [self.allPoints count] - 1)];
    for(NSValue *aValue  in tempPoints){
      CGPoint point = [aValue CGPointValue];
      [path addLineToPoint:point];
      
    }
    return YES;
  }else return NO;
}

@end
