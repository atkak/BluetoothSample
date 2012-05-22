//
//  ViewController.m
//  BluetoothSample
//
//  Created by 敦史 掛川 on 12/05/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DrawData.h"

@interface ViewController () {
    ConnectionManager *connectionManager;
    CGPoint lastPoint;
}

@end

@implementation ViewController
@synthesize connectButton;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    connectButton.title = @"接続";
    
	connectionManager = [[ConnectionManager alloc] init];
    connectionManager.delegate = self;
}

- (void)viewDidUnload
{
    connectionManager.delegate = nil;
    connectionManager = nil;
    [self setImageView:nil];
    [self setConnectButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - ConnectionManagerDelegate methods

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
{
    DrawData *drawData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self drawBetweenStartPoint:drawData.startPoint endPoint:drawData.destinationPoint];
}

- (void)connected
{
    connectButton.title = @"切断";
}

- (void)disconnected
{
    connectButton.title = @"接続";
}

#pragma mark - Private methods

- (void)drawBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

#pragma mark - Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", @"touchesBegan");
    
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:imageView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", @"touchesMoved");
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:imageView];
    
    [self drawBetweenStartPoint:lastPoint endPoint:currentPoint];
    
    NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:[[DrawData alloc] initWithStartPoint:lastPoint destinationPoint:currentPoint]];
    [connectionManager sendDataToAllPeers:sendData];
    
    lastPoint = currentPoint;
}

- (IBAction)connectButonTouched:(id)sender 
{
    if (connectionManager.isConnecting) {
        [connectionManager disconnect];
    } else {
        [connectionManager connect];
    }
}

@end
