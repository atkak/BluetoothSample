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

@required

@optional
- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer;
- (void)connected;
- (void)disconnected;

@end

@interface ConnectionManager : NSObject <GKPeerPickerControllerDelegate, GKSessionDelegate>

@property (nonatomic, strong) id<ConnectionManagerDelegate> delegate;
@property (nonatomic) BOOL isConnecting;

- (void)connect;
- (void)disconnect;
- (void)sendDataToAllPeers:(NSData *)data;

@end
