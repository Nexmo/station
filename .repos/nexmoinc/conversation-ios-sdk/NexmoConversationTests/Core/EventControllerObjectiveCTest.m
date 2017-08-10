//
//  EventControllerObjectiveCTest.m
//  NexmoConversation
//
//  Created by Shams Ahmed on 01/02/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NexmoConversationTests-Swift.h"

@import Quick;
@import Nimble;
@import NexmoConversation;

#define QUICK_DISABLE_SHORT_SYNTAX 1

QuickSpecBegin(EventControllerObjectiveCTest)

it(@"fetches all events for a conversation", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor retrieveWith:self forConversation:@"con-123" start:0 end:20];
    
    __block BOOL result = false;
    
    [client.eventController retrieveFromConversation:@"con-123" start:0 end:20 :^(NSArray<NXMEvent * > * _Nonnull events) {
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).toEventually(beTrue());
});

it(@"fails to fetch all events for a conversation", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor retrieveErrorWith:self forConversation:@"con-123" start:0 end:20];
    
    __block NSError *error;
    
    [client.eventController retrieveFromConversation:@"con-123" start:0 end:20 :^(NSArray<NXMEvent * > * _Nonnull events) {
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error.code).toEventually(equal(3));
});

QuickSpecEnd
