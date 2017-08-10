//
//  AccountControllerObjectiveCTest.m
//  NexmoConversation
//
//  Created by Shams Ahmed on 06/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NexmoConversationTests-Swift.h"

@import Quick;
@import Nimble;
@import NexmoConversation;

#define QUICK_DISABLE_SHORT_SYNTAX 1

QuickSpecBegin(AccountControllerObjectiveCTest)

beforeSuite(^{
    [[NXMConversationClient instance] addAuthorizationWith:@"token"];
});

afterSuite(^{
    
});

it(@"fetch the user model", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor userWith:self forId:@"usr-123"];
    
    __block BOOL result = false;
    
    [client.account userWith:@"usr-123" :^(UserModel * _Nonnull user) {
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).withTimeout(5).toEventually(beTrue());
});

it(@"fails to fetch fetch the user model", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor userErrorWith:self forId:@"usr-123"];
    
    __block NSError *error;
    
    [client.account userWith:@"usr-123" :^(UserModel * _Nonnull user) {
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error.code).toEventually(equal(3));
});

QuickSpecEnd
