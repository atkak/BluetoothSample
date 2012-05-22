//
//  ViewController.h
//  BluetoothSample
//
//  Created by 敦史 掛川 on 12/05/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface ViewController : UIViewController <ConnectionManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *connectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)connectButonTouched:(id)sender;

@end
