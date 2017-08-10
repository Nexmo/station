//
//  MembershipControllerObjectiveCTest.m
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

QuickSpecBegin(MembershipControllerObjectiveCTest)

it(@"invites a user to a conversation", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor inviteWith:self forId:@"usr-123" inConversation:@"con-123"];
    
    __block BOOL result = false;
    
    [client.membershipController inviteWithUser:@"con-123" toConversation:@"con-123" :^{
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).toEventually(beTrue());
});

it(@"fails to invite a user", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor inviteErrorWith:self forId:@"usr-123" inConversation:@"con-123"];
    
    __block NSError *error;
    
    [client.membershipController inviteWithUser:@"con-123" toConversation:@"con-123" :^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error.code).toEventually(equal(3));
});

it(@"kicks a user to a conversation", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor kickWith:self forId:@"mem-123" fromConversation:@"con-123"];
    
    __block BOOL result = false;
    
    [client.membershipController kickWithMember:@"mem-123" fromConversation:@"con-123" :^(BOOL userRequest) {
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).toEventually(beTrue());
});

it(@"fails to kick a user", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [HTTPStubbingFactor kickErrorWith:self forId:@"mem-123" fromConversation:@"con-123"];
    
    __block NSError *error;
    
    [client.membershipController kickWithMember:@"mme-123" fromConversation:@"con-123" :^(BOOL result) {
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error.domain).withTimeout(15).toEventually(equal(@"NexmoConversation.NetworkError"));
});

QuickSpecEnd
