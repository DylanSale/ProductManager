README
------

ProductManager manages iOS StoreKit products at a higher level than StoreKit.
You create Product subclasses, and give it params in an NSDictionary (loaded from a plist probably), then implement the unlock method.
The products are registered with the ProductManager, which then starts observing for transactions, and can notify other code of unlocks using its delegate.

The code is fairly simple. There is an example project with example code in the App Delegate.

The base Product isnt very useful. However, there is a CurrencyProduct which is for things like in-game coins.