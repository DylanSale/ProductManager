//
//  ProductManager.mm
//  inCline
//
//  Created by Dylan Sale on 6/04/10.
//  Copyright 2010 Two Lives Left. All rights reserved.
//

#import "ProductManager.h"
//#import <CommonCrypto/CommonDigest.h>
//#import "cocos2d.h" //use this to get CCLOG
#define CCLOG(...)

static ProductManager *sharedInstance = nil;

@implementation ProductManager

#pragma mark -
#pragma mark class instance methods

- (Product*) productForID:(NSString*)ID
{
	return [products objectForKey:ID];
}

- (void) registerProduct:(Product*)product
{
	assert(!observing);
	
	[products setObject:product forKey:product.productID];
}

/*
- (NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
	
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
*/

- (void) purchaseProduct:(NSString*)productID
{
/*	NSString* code = [[NSUserDefaults standardUserDefaults] stringForKey:@"UnlockCode"];
	if (code != nil && ![code isEqual:@""]) 
	{
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twolivesleft.com/unlock_code.php?code=%@",code]];
		NSString* hash = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
		if (hash) 
		{
			NSString* data = [NSString stringWithFormat:@"%@%@",code,@"WpanXZHKq"]; //this salt is on the server as well
			NSString* dataHash = [self md5HexDigest:data];
			CCLOG(@"serverHash = %@, hash = %@",hash,dataHash);
			
			if ([dataHash isEqual:hash]) 
			{
				Product* product = [self productForID:productID];
				[product purchasedWith:nil];
				[purchaseDelegate product:product purchasedWith:nil];
				return;
			}
		}
		
	} 
*/	
	if ([self storeEnabled])
	{
		assert(observing);
        Product* product = [self productForID:productID];
        bool canPurchase = [product willStartPurchase];
		if (canPurchase) 
        {
            [self.purchaseDelegate willPurchaseProduct:product];
            SKPayment *payment = [SKPayment paymentWithProductIdentifier:productID];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            [product purchaseFailed:nil];
            [self.purchaseDelegate product:product purchaseFailedWith:nil];
        }
	}
}


- (bool) storeEnabled
{
	return [SKPaymentQueue canMakePayments];
}

- (void) startObserving
{
	if ([self storeEnabled]) 
	{
		assert(!observing);
		if (!observing) 
		{
            observing = true;
			[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
		}
	}
}

- (id) init
{
	if (self = [super init]) 
	{
		observing = false;
		products = [[NSMutableDictionary alloc] init];
		productDescriptions = nil;
		self.purchaseDelegate = nil;
	}
	return self;
}

- (void) setPurchaseDelegate:(NSObject<ProductPurchaseDelegate>*)delegate
{
    //cannot override a previous delegate without first unsetting it
    assert((purchaseDelegate != nil && delegate == nil) ||
           purchaseDelegate == nil);
    //assert(purchaseDelegate == nil && delegate == nil);
    
    [purchaseDelegate release];
    purchaseDelegate = [delegate retain];
}

- (NSObject<ProductPurchaseDelegate>*) purchaseDelegate
{
    return purchaseDelegate;
}

- (void) unlockProduct:(NSString*)productID
{
	Product* product = (Product*)[products objectForKey:productID];	
   [product purchasedWith:nil];
    [self.purchaseDelegate product:product didPurchaseWith:nil];
	
}

- (bool) processTransaction:(SKPaymentTransaction*) transaction
{
	NSObject* object = [products objectForKey:transaction.payment.productIdentifier];	
	assert(object); //this is very bad, means they bought something but we cant do anything to unlock it because its not registered
	if (object) 
	{
		Product *product = (Product*)object;
        
	    [product purchasedWith:transaction];
		[self.purchaseDelegate product:product didPurchaseWith:transaction];
		
		return true;
	}
	return false;
}

- (void) completeTransaction:(SKPaymentTransaction*) transaction
{
	CCLOG(@"Complete Transaction!");

	if ([self processTransaction:transaction]) 
	{
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction];		
	}
}

- (void) restoreTransaction:(SKPaymentTransaction*) transaction
{
	CCLOG(@"Restore Transaction!");

	if ([self processTransaction:transaction.originalTransaction]) 
	{
		[[SKPaymentQueue defaultQueue] finishTransaction: transaction];		
	}
}

- (void) failedTransaction:(SKPaymentTransaction*) transaction
{

	NSObject* object = [products objectForKey:transaction.payment.productIdentifier];	
	if (object) 
	{
		Product * product = (Product*)object;

		if([product respondsToSelector:@selector(purchaseFailed:)])
		{
			[product purchaseFailed:transaction];
		}

		[self.purchaseDelegate product:product purchaseFailedWith:transaction];
	}
	else
	{
		[self.purchaseDelegate product:nil purchaseFailedWith:transaction];		
	}
	

	CCLOG(@"Failed Transaction! %d",transaction.error.code);
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions 
{
	for (SKPaymentTransaction *transaction in transactions)
    {
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:					
				[self completeTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
				
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
				break;
				
			default:
				break;
		}
    }
}

#pragma mark Product Description Request Methods
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	productDescriptions = [response retain];
	 
	[request autorelease];
	
	if( [self hasProductDescriptions] && [(NSObject*)self.purchaseDelegate respondsToSelector:@selector(productDescriptionsAvailable)] )
	{
		[self.purchaseDelegate productDescriptionsAvailable];
	}
	
#ifdef DEBUG
	for(SKProduct* p in response.products)
	{
		CCLOG(@"\nid:%@\ntitle:%@\ndesc:%@\nprice:%f",
			  p.productIdentifier,p.localizedTitle,p.localizedDescription,(float)[p.price doubleValue]);
	}
#endif
	
}

- (void)requestDidFinish:(SKRequest *)request 
{

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error 
{
	CCLOG(@"Product request failed with error %@", error);
}

- (bool) hasProductDescriptions
{
	return productDescriptions != nil;
}

- (void) requestProductDescriptions
{
	if ([self storeEnabled] && [products count] > 0) 
	{
		CCLOG(@"Requesting product descriptions");
		NSSet* pids = [NSSet setWithArray:[products allKeys]];
		SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:pids];
		request.delegate = self;
		[request start];
	}
}

- (SKProduct*) getDescriptionForProduct:(Product*)product
{
	return [self getDescriptionForProductID:product.productID];
}

- (SKProduct*) getDescriptionForProductID:(NSString*)productID
{
	assert(productDescriptions != nil);
	for (SKProduct* description in productDescriptions.products)
	{
		if ([description.productIdentifier compare: productID] == NSOrderedSame ) 
		{
			return description;
		}
	}
	
	return nil;
}

- (NSArray*) getSortedDescriptions
{
    assert([self hasProductDescriptions]);
    if(![self hasProductDescriptions])
        return nil;
    
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:[products count]];
    
    for (NSString* key in products) 
    {
        [arr addObject:[products objectForKey:key]];
    }
    
    [arr sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES]]];
    
    NSMutableArray* descArr = [NSMutableArray arrayWithCapacity:[products count]];
    for (Product* product in arr) 
    {
        [descArr addObject:[self getDescriptionForProduct:product]];
    }
    return descArr;

}

#pragma mark Housekeeping methods
- (void) Finalize
{
	[products release];
	products = nil;
	[productDescriptions release];
	productDescriptions = nil;
    self.purchaseDelegate = nil;
}

- (void) dealloc
{
	[self Finalize];
	[super dealloc];
}


#pragma mark -
#pragma mark Singleton methods

+ (ProductManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[ProductManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end

