@interface SCFuture : NSObject
+ (id)immediateFutureWithError:(id)arg1;    // IMP=0x00000001075d1f60
+ (id)immediateFutureWithValue:(id)arg1;    // IMP=0x00000001002f13d8
+ (id)_generateNilResultError;    // IMP=0x0000000107526ee0
+ (id)_generateInvalidParameterError;    // IMP=0x0000000107526ebc
+ (id)all:(id)arg1;    // IMP=0x00000001075d208c
- (void)valueWithCompletion:(id)arg1 performer:(id)arg2 preferSynchronous:(_Bool)arg3;    // IMP=0x000000010013ed84
- (void)valueWithCompletion:(id)arg1 performer:(id)arg2;    // IMP=0x000000010013ed74
- (void)_failIfIncomplete;    // IMP=0x00000001000edbe8
- (void)_completeWithError:(id)arg1;    // IMP=0x00000001075d1f4c
- (void)_completeWithValue:(id)arg1;    // IMP=0x00000001000ed9dc
- (void)_completeWithItem:(id)arg1 tag:(unsigned char)arg2 assertIfAlreadyCompleted:(_Bool)arg3;    // IMP=0x00000001000ed9f0
- (id)_init;    // IMP=0x00000001000d4b60
- (id)_performChainedBlock:(id)arg1 performer:(id)arg2;    // IMP=0x0000000107526c18
- (id)flatMap:(id)arg1 performer:(id)arg2;    // IMP=0x0000000107526998
- (id)map:(id)arg1 performer:(id)arg2;    // IMP=0x0000000107526860

@end
