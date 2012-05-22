//
//  ConnectionManager.m
//  BluetoothTest
//
//  Created by 敦史 掛川 on 12/05/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager () {
    GKSession *currentSession;
}

@end

@implementation ConnectionManager

@synthesize delegate;
@synthesize isConnecting = _isConnecting;

#pragma mark - GKPeerPickerControllerDelegate methods

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker 
           sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    GKSession *session = [[GKSession alloc] initWithSessionID:@"BluetoothTestID" 
                                                  displayName:@"BluetoothTest" 
                                                  sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker 
              didConnectPeer:(NSString *)peerID 
                   toSession:(GKSession *)session
{
    currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    
    picker.delegate = nil;
    [picker dismiss];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    picker.delegate = nil;
}

#pragma mark - GKSession methods

- (void)session:(GKSession *)session 
           peer:(NSString *)peerID 
 didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateAvailable:
            NSLog(@"%@", @"Peer state changed - available");
            break;
            
        case GKPeerStateConnecting:
            NSLog(@"%@", @"Peer state changed - connecting");
            break;
            
        case GKPeerStateConnected:
            NSLog(@"%@", @"Peer state changed - connected");
            self.isConnecting = YES;
            [self.delegate connected];
            break;
            
        case GKPeerStateDisconnected:
            NSLog(@"%@", @"Peer state changed - disconnected");
            currentSession = nil;
            self.isConnecting = NO;
            [self.delegate disconnected];
            break;
            
        case GKPeerStateUnavailable:
            NSLog(@"%@", @"Peer state changed - unavailable");
            break;
            
        default:
            break;
    }
}

- (void)receiveData:(NSData *)data
           fromPeer:(NSString *)peer
          inSession:(GKSession *)session
            context:(void *)context
{
    [self.delegate receiveData:data fromPeer:peer];
}

#pragma mark - Public methods

- (void)connect
{
    GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
    picker.delegate = self;
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    [picker show];
}

- (void)disconnect
{
    if (currentSession) {
        [currentSession disconnectFromAllPeers];
        currentSession = nil;
    }
    self.isConnecting = NO;
    [self.delegate disconnected];
}

- (void)sendDataToAllPeers:(NSData *)data
{
    if (currentSession) {
        NSError *error = nil;
        [currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

@end
