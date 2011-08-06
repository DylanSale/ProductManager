//
//  ProductPurchaseDelegate.h
//  inCline
//
//  Created by Dylan Sale on 27/05/10.
//  Copyright 2010 Two Lives Left. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "Product.h"

@protocol ProductPurchaseDelegate

@required

/*
 * Called when a purchase is sent off to the server
 */
- (void) willPurchaseProduct:(Product*)product;

/*
 * Called when a purchase was successful, after the product's callback.
 * Transaction can be nil
 */
- (void) product:(Product*)product didPurchaseWith:(SKPaymentTransaction *)transaction;

/* 
 * Called if a product purchase failed for whatever reason. 
 * Transaction can be nil.
 */
- (void) product:(Product*)product purchaseFailedWith:(SKPaymentTransaction *)transaction;

@optional

/*
 * Called when product descriptions have finished downloading.
 */
- (void) productDescriptionsAvailable;

@end
