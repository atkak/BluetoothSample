//
//  ConnectionManager.h
//  BluetoothTest
//
//  Created by 敦史 掛川 on 12/05/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol ConnectionManagerDelegate <NSObject>

@optional
// データ受信時に呼び出される
- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer;
// P2P接続完了時に呼び出される
- (void)connected;
// P2P接続切断時に呼び出される
- (void)disconnected;

@end

@interface ConnectionManager : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate>

@property (nonatomic, strong) id<ConnectionManagerDelegate> delegate;
@property (nonatomic) BOOL isConnecting;

- (void)connect;
- (void)disconnect;
- (void)sendDataToAllPeers:(NSData *)data;

@end
