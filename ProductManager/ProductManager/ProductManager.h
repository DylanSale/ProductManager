//
//  ProductManager.h
//  inCline
//
//  Created by Dylan Sale on 6/04/10.
//  Copyright 2010 Two Lives Left. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "Product.h"
#import "ProductPurchaseDelegate.h"

@interface ProductManager : NSObject<SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
@private
	NSMutableDictionary* products;
		
	SKProductsResponse* productDescriptions;
	
	bool observing;
	
	NSObject<ProductPurchaseDelegate>* purchaseDelegate;
}

/*
 * Set the purchase delegate whenever you want to be able to respond to
 * a product being unlocked (this can happen at any time).
 */
@property(nonatomic,assign) NSObject<ProductPurchaseDelegate>* purchaseDelegate;

+ (ProductManager*)sharedInstance;

/*
 * Returns the Product registered for a given Store ID
 */
- (Product*) productForID:(NSString*)ID;

/*
 * Adds the product to be registered. Can only be called before we
 * start observing because the product may be processed immediately
 * upon starting observing (and if it isnt registered, we will miss
 * the purchase).
 */
- (void) registerProduct:(Product*)product;

/* 
 * Start waiting for transactions to respond, 
 * Should be done at the start of the app so that we dont miss any.
 * Should only do this once all products have been added
 */
- (void) startObserving; 

/* 
 * Is false if the user has turned off in app purchase on their device
 */
- (bool) storeEnabled;

/*
 * Start the purchase procedure on a product.
 * Make sure it has been registered, and we are observing before starting.
 */
- (void) purchaseProduct:(NSString*)productID;

/*
 * Just unlock a product outright, bypassing the apple store.
 */
- (void) unlockProduct:(NSString*)productID; 

/*
 * Download all the product descriptions.
 * Will callback to the delegate's productDescriptionsAvailable method
 * when finished downloading
 */
- (void) requestProductDescriptions;
- (bool) hasProductDescriptions;


/*
 * Get the info for a product from the server, including price, name, etc
 * All localised to the current locale.
 */
- (SKProduct*) getDescriptionForProductID:(NSString*)productID;
- (SKProduct*) getDescriptionForProduct:(Product*)product;

- (NSArray*) getSortedDescriptions;

/* 
 * Shutdown the singleton
 */
- (void) Finalize;

@end
