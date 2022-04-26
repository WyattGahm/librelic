@interface SCManagedRecordedVideo : NSObject
@property(readonly, nonatomic) long long codecType; // @synthesize codecType=_codecType;
@property(readonly, nonatomic) _Bool isFrontFacingCamera; // @synthesize isFrontFacingCamera=_isFrontFacingCamera;
@property(readonly, copy, nonatomic) UIImage *placeholderImage; // @synthesize placeholderImage=_placeholderImage;
@property(readonly, nonatomic) double videoDuration; // @synthesize videoDuration=_videoDuration;
@property(readonly, copy, nonatomic) NSURL *rawVideoDataFileURL; // @synthesize rawVideoDataFileURL=_rawVideoDataFileURL;
@property(readonly, copy, nonatomic) NSURL *videoURL; // @synthesize videoURL=_videoURL;
- (_Bool)isEqual:(id)arg1;    // IMP=0x00000001071f15e4
- (unsigned long long)hash;    // IMP=0x00000001071f1518
- (id)copyWithZone:(struct _NSZone *)arg1;    // IMP=0x00000001071f1514
- (id)initWithVideoURL:(id)arg1 rawVideoDataFileURL:(id)arg2 videoDuration:(double)arg3 placeholderImage:(id)arg4 isFrontFacingCamera:(_Bool)arg5 codecType:(long long)arg6;    // IMP=0x00000001071f13f0
@end
