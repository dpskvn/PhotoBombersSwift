//
//  ACAccountStore+SimpleAuth.m
//  SimpleAuth
//
//  Created by Caleb Davenport on 1/25/14.
//  Copyright (c) 2014 Seesaw Decisions Corporation. All rights reserved.
//

#import "ACAccountStore+SimpleAuth.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation ACAccountStore (SimpleAuth)

+ (instancetype)SimpleAuth_sharedAccountStore {
    static dispatch_once_t token;
    static ACAccountStore *store;
    dispatch_once(&token, ^{
        store = [ACAccountStore new];
    });
    return store;
}


+ (RACSignal *)SimpleAuth_accountsWithTypeIdentifier:(NSString *)typeIdentifier options:(NSDictionary *)options {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        ACAccountStore *store = [self SimpleAuth_sharedAccountStore];
        ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:typeIdentifier];
        [store requestAccessToAccountsWithType:type options:options completion:^(BOOL granted, NSError *error) {
            if (granted) {
                NSArray *accounts = [store accountsWithAccountType:type];
                NSUInteger numberOfAccounts = [accounts count];
                if (numberOfAccounts == 0) {
                    [subscriber sendError:(error ?: [[NSError alloc] initWithDomain:ACErrorDomain code:ACErrorAccountNotFound userInfo:nil])];
                }
                else {
                    [subscriber sendNext:accounts];
                    [subscriber sendCompleted];
                }
            }
            else {
                [subscriber sendError:(error ?: [[NSError alloc] initWithDomain:ACErrorDomain code:ACErrorPermissionDenied userInfo:nil])];
            }
        }];
        return nil;
    }];
}

@end
