//
//  AeSdkIOS.h
//  ShoppingCartExample
//
//  Created by adelement on 7/18/14.
//  Copyright (c) 2014 Jose Gustavo Rodriguez Baldera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <AdSupport/AdSupport.h>
@interface AeSdkIOS : NSObject


-(void) aesdkios:(NSData *)msg;
@property(nonatomic,readonly) NSUUID *advertisingIdentifier;

@end


