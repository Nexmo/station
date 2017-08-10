//
//  ConversationClientObjcTest.m
//  NexmoConversation
//
//  Created by Shams Ahmed on 25/05/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NexmoConversationTests-Swift.h"

@import NexmoConversation;
@import Nimble;
@import Quick;

@interface ConversationClientObjcTest: XCTestCase

@end

@implementation ConversationClientObjcTest

#pragma mark -
#pragma mark - Setup

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark -
#pragma mark - Test

- (void)testClientloggedInFails {
    NXMConversationClient *client = [NXMConversationClient instance];
    
    __block BOOL loginSuccess;
    
    [client loginWith:@"token" :^(enum NXMLoginResult result) {
        if (result == NXMLoginResultSuccess) {
            loginSuccess = true;
        } else {
            loginSuccess = false;
        }
    }];
    
    expect(loginSuccess).toEventually(beFalse());
}

- (void)testClientStateIsDisconnected {
    NXMConversationClient *client = [NXMConversationClient instance];
    
    __block BOOL isDisconnectState;
    
    [client stateObjc:^(enum NXMStateObjc state) {
        if (state == NXMStateObjcDisconnected) {
            isDisconnectState = true;
        } else {
            isDisconnectState = false;
        }
    }];
    
    [client disconnect];
    
    expect(isDisconnectState).withTimeout(5).toEventually(beTrue());
}

@end
