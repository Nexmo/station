//
//  MemberObjectiveCTest.m
//  NexmoConversation
//
//  Created by shams ahmed on 05/07/2017.
//  Copyright © 2017 Nexmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NexmoConversationTests-Swift.h"

@import Quick;
@import Nimble;
@import NexmoConversation;

#define QUICK_DISABLE_SHORT_SYNTAX 1

QuickSpecBegin(MemberObjectiveCTest)

it(@"kicks myself out of a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [DatabaseFactory saveConversationWith:client];
    
    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;
    
    [HTTPStubbingFactor kickWith:self inConversation:@"con-1" forMember: @"mem-1"];
    
    __block BOOL result = false;
    
    [conversation.membersObjc.firstObject kickOnSuccess:^{
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).withTimeout(5).toEventually(beTrue());
});

it(@"fails to kick myself out of a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [DatabaseFactory saveConversationWith:client];
    
    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;
    
    [HTTPStubbingFactor leaveErrorWith:self inConversation:@"con-1" forMember: @"mem-1"];
    
    __block NSError *error;
    
    [conversation.membersObjc.firstObject kickOnSuccess:^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error).withTimeout(5).toEventuallyNot(beNil());
});

QuickSpecEnd
