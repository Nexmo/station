//
//  ConversationObjectiveCTest.m
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

QuickSpecBegin(ConversationObjectiveCTest)

it(@"fails to leave with no members in conversation", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [DatabaseFactory saveConversationWith:client];
    
    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;
    
    [DatabaseFactory clear:client];
    
    __block NSError *error;
    
    [conversation leaveOnSuccess:^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error).withTimeout(5).toEventuallyNot(beNil());
});

it(@"leaves a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [DatabaseFactory saveConversationWith:client];
    
    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;
    
    [HTTPStubbingFactor leaveWith:self inConversation:@"con-1" forMember: @"mem-123"];
    
    __block BOOL result = false;
    
    [conversation leaveOnSuccess:^{
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];
    
    expect(result).withTimeout(5).toEventually(beTrue());
});

it(@"fail to leaves a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];
    
    [DatabaseFactory saveConversationWith:client];
    
    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;
    
    [HTTPStubbingFactor leaveErrorWith:self inConversation:@"con-1" forMember: @"mem-123"];
    
    __block NSError *error;
    
    [conversation leaveOnSuccess:^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error).withTimeout(5).toEventuallyNot(beNil());
});

it(@"joins a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];

    [DatabaseFactory saveConversationWith:client];

    [ConversationClientInterop setAsLoggedInWith:client];

    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;

    [HTTPStubbingFactor joinWith:self
                 forConversation:@"con-1"
                          userId:@"USR-13c9bd1d-cae0-410b-a552-614029377f25"
                        memberId:@"MEM-48495986-45aa-45fe-ad92-e546fba87b87"
    ];

    __block BOOL result = false;

    [conversation joinOnSuccess:^{
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];

    expect(result).withTimeout(5).toEventually(beTrue());
});

it(@"fail to join a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];

    [DatabaseFactory saveConversationWith:client];

    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;

    [HTTPStubbingFactor joinErrorWith:self
                 forConversation:@"CON-19da5cd2-388d-40f4-909d-431f23572cfa"
                          userId:@"USR-13c9bd1d-cae0-410b-a552-614029377f25"
                        memberId:@"MEM-48495986-45aa-45fe-ad92-e546fba87b87"
    ];

    __block NSError *error;

    [conversation joinOnSuccess:^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];

    expect(error).withTimeout(5).toEventuallyNot(beNil());
});


it(@"invite user to a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];

    [DatabaseFactory saveConversationWith:client];

    [ConversationClientInterop setAsLoggedInWith:client];

    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;

    [HTTPStubbingFactor inviteWith:self
                             forId:@"xx"
                          inConversation:@"con-1"
    ];

    __block BOOL result = false;

    [conversation inviteWithUsername: @"demo1@nexmo.com" onSuccess:^{
        result = true;
    } onFailure:^(NSError * _Nonnull error) {
        XCTFail(@"");
    }];

    expect(result).withTimeout(5).toEventually(beTrue());
});

it(@"fail to invite a user to a conversation in objectivec", ^{
    NXMConversationClient *client = [NXMConversationClient instance];

    [DatabaseFactory saveConversationWith:client];

    NXMConversation *conversation = client.conversation.conversationsObjc.firstObject;

    [HTTPStubbingFactor inviteErrorWith:self
                                  forId:@"xx"
                               inConversation:@"con-1"
    ];

    __block NSError *error;

    [conversation inviteWithUsername: @"demo1@nexmo.com" onSuccess:^{
        XCTFail(@"");
    } onFailure:^(NSError * _Nonnull newError) {
        error = newError;
    }];
    
    expect(error).withTimeout(5).toEventuallyNot(beNil());
});

QuickSpecEnd
