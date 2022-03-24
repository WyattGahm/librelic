#import <Foundation/Foundation.h>

@class NSDate, NSDictionary, NSNumber, NSString, SCChatMessageParticipantIdentifier;

@protocol SCChatMessage <NSObject>
- (_Bool)isForwardable;
- (_Bool)isUnreadByRecipients;
- (NSDate *)messageTimestampForOrdering;
- (_Bool)canBeSaved;
- (_Bool)canDelete;
- (_Bool)shouldRetryMediaSendTask;
- (NSString *)mediaSendTaskId;
- (long long)messageType;
- (_Bool)sending;
- (_Bool)failedToSend;
- (_Bool)isSendingOrHasFailed;
- (_Bool)isSavedByParticipant:(SCChatMessageParticipantIdentifier *)arg1;
- (_Bool)isSaved;
- (_Bool)isReleasedBy:(NSString *)arg1;
- (_Bool)isReleased;
- (NSNumber *)sequenceNumber;
- (NSDate *)sentTimestamp;
- (NSDate *)messageTimestamp;
- (NSString *)conversationId;
- (NSString *)messageSender;
- (NSString *)consistentId;

@optional
- (_Bool)isActionable;
- (_Bool)shouldDisplayBelowFoldInChat;
- (NSDictionary *)clearedDictionary;
- (NSDate *)feedSortTimestamp;
- (NSDate *)feedDisplayTimestamp;
- (void)setFailed;
- (_Bool)isSent;
@end

