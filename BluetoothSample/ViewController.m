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
}

@end

@implementation ViewController
@synthesize connectButton;
@synthesize imageView;

#pragma mark - View lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor whiteColor];
    connectButton.title = @"接続";
    // P2P接続のマネージャーを生成
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ConnectionManagerDelegate methods

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
{
    // 他のピアから受信したデータをデコード
    DrawData *drawData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    // 他のピアで描かれた線を描画
    [self drawLineBetweenStartPoint:drawData.startPoint endPoint:drawData.endPoint];
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

// 二点間に直線を描画する
- (void)drawLineBetweenStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
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

// touchesMovedイベントハンドラ
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // 現在タッチ中のポイント
    CGPoint currentPoint = [touch locationInView:imageView];
    // 前回タッチしていたポイント
    CGPoint previousPoint = [touch previousLocationInView:imageView];
    // 前回タッチしていたポイントと現在タッチ中のポイントの間に線を描画
    [self drawLineBetweenStartPoint:previousPoint endPoint:currentPoint];
    
    // 描画ポイント情報を送信用にエンコード
    NSData *sendData = [NSKeyedArchiver archivedDataWithRootObject:[[DrawData alloc] initWithStartPoint:previousPoint destinationPoint:currentPoint]];
    // 描画ポイント情報を他のピアに送信
    [connectionManager sendDataToAllPeers:sendData];
}

// 接続・切断ボタンタップイベント
- (IBAction)connectButonTouched:(id)sender 
{
    if (connectionManager.isConnecting)
    {
        [connectionManager disconnect];
    }
    else
    {
        [connectionManager connect];
    }
}

@end
