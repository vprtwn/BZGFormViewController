#import "NSError+BZGFormViewController.h"

@implementation NSError (BZGFormViewController)

+ (NSError *)bzg_errorWithDescription:(NSString *)description
{
    NSError *error = [NSError errorWithDomain:@"BZGFormViewController" code:1337 userInfo:@{NSLocalizedDescriptionKey: description ?: @""}];
    return error;
}

@end
