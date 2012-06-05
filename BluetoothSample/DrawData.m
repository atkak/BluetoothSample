//
//  DrawData.m
//  BluetoothTest
//
//  Created by 敦史 掛川 on 12/05/18.
//  Copyright (c) 2012年 Classmethod Inc.. All rights reserved.
//

#import "DrawData.h"

@implementation DrawData

@synthesize startPoint = _startPoint;
@synthesize endPoint = _destinationPoint;

- (id)initWithStartPoint:(CGPoint)startPoint destinationPoint:(CGPoint)destinationPoint
{
    self = [super init];
    if (self) {
        _startPoint = startPoint;
        _destinationPoint = destinationPoint;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSValue valueWithCGPoint:_startPoint] forKey:@"startPoint"];
    [coder encodeObject:[NSValue valueWithCGPoint:_destinationPoint] forKey:@"destinationPoint"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _startPoint = [[coder decodeObjectForKey:@"startPoint"] CGPointValue];
        _destinationPoint = [[coder decodeObjectForKey:@"destinationPoint"] CGPointValue];
    }
    return self;
}

@end
