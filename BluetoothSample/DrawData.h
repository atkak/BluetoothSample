//
//  DrawData.h
//  BluetoothTest
//
//  Created by 敦史 掛川 on 12/05/18.
//  Copyright (c) 2012年 Classmethod Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawData : NSObject <NSCoding>

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (id)initWithStartPoint:(CGPoint)startPoint destinationPoint:(CGPoint)destinationPoint;

@end
