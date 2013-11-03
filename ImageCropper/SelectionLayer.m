//
//  SelectionLayer.m
//  ImageCropper
//
//  Created by Sandeep on 03/11/13.
//  Copyright (c) 2013 com. All rights reserved.
//

#import "SelectionLayer.h"

@implementation SelectionLayer
@dynamic marching;

+ (BOOL)needsDisplayForKey:(NSString *)key{
  if([key isEqualToString:@"marching"])
    return YES;
  return [super needsDisplayForKey:key];
}


@end
