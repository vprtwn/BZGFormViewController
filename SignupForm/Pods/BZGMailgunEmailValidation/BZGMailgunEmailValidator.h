#import <Foundation/Foundation.h>

@interface BZGMailgunEmailValidator : NSObject

/**
 Returns a validator instance initialized with the given public key and operation queue.
 */
+ (BZGMailgunEmailValidator *)validatorWithPublicKey:(NSString *)publicKey operationQueue:(NSOperationQueue *)operationQueue;

/**
 Loads a validation request given an email address and a Mailgun public API key.
 Executes the success block if the request succeeds and the failure block if the request fails.
 */
- (void)validateEmailAddress:(NSString *)address
                     success:(void (^)(BOOL isValid, NSString *didYouMean))success
                     failure:(void (^)(NSError *error))failure;

@end
