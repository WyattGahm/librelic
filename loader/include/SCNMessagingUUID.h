#include <Foundation/Foundation.h>

@class NSData;

@interface SCNMessagingUUID : NSObject <NSCopying>
{
    NSData *_id;
}

+ (id)RandomUUID;	// IMP=0x0000000107731c1c
+ (id)UUIDWithString:(id)arg1;	// IMP=0x0000000100141118
	// IMP=0x00000001003f043c
@property(readonly, nonatomic) NSData *id; // @synthesize id=_id;
- (unsigned long long)hash;	// IMP=0x000000010049dbdc
- (_Bool)isEqual:(id)arg1;	// IMP=0x000000010049dc94
- (id)initWithId:(id)arg1;	// IMP=0x0000000100141220
- (id)copyWithZone:(id)arg1;	// IMP=0x000000010042c098
- (long long)version;	// IMP=0x0000000107731cfc
- (id)toString;	// IMP=0x00000001003cea98

@end
