//
//  Product.h
//  inCline
//
//  Created by Dylan Sale on 6/04/10.
//  Copyright 2010 Two Lives Left. All rights reserved.
//

#include <StoreKit/StoreKit.h>

@interface Product : NSObject
{
	int sortOrder;
	
	NSString *productID;
	NSString *productName;
    
    NSDictionary* displayProperties;
}

@property (nonatomic, assign) int sortOrder;
@property (nonatomic, readonly) NSString *productID;
@property (nonatomic, readonly) NSString *productName;

/*
 * This is a user defined dictionary, read out of the params 
 * "DisplayProperties" key.
 * The idea is to store things like icon etc here for the store UI
 */
@property (nonatomic, readonly) NSDictionary* displayProperties;

/*
 * Useful for passing in a JSON dictionary or plist or something
 */
- (id) initWithParams:(NSDictionary*)params; 

/*
 * You can implement this if you want to do something fancy when purchase
 * starts, otherwise you can just pass the id into 
 * ProductManager's purchaseProduct method
 * Returns: whether the purchase can start or not
 */
- (bool) willStartPurchase;

/*
 * This is called when the purchase goes through, or if the product is 
 * unlocked without purchase through the ProductManager
 * Transaction is either the transaction that purchased it, or nil if it was 
 * unlocked without purchase.
 */
- (void) purchasedWith:(SKPaymentTransaction *)transaction;

/*
 * Same as above but when it fails.
 */
- (void) purchaseFailed:(SKPaymentTransaction *)transaction;

/*
 * Create a Product (or subclass) using the dictionary
 * Reads the "Type" key from the dictionary for the class to use.
 */
+ (Product*) productWithDict:(NSDictionary*)dict;

/*
 * Load a PLIST file and create a Product (or subclass) using it.
 * Uses productWithDict to create the product.
 */
+ (Product*) productWithPlist:(NSString*)file;


@end
