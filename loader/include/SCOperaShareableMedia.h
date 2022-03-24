#import <objc/NSObject.h>

@class AVAsset, NSURL, UIImage;

@interface SCOperaShareableMedia : NSObject{
    long long _mediaType;
    UIImage *_image;
    AVAsset *_videoAsset;
    NSURL *_videoURL;
    NSURL *_remoteURL;
    unsigned long long _transformManipulatorFormat;
}

@property(readonly, nonatomic) unsigned long long transformManipulatorFormat;
@property(readonly, nonatomic) NSURL *remoteURL;
@property(readonly, nonatomic) NSURL *videoURL;
@property(readonly, nonatomic) AVAsset *videoAsset;
@property(readonly, nonatomic) UIImage *image;
@property(readonly, nonatomic) long long mediaType;
- (id)description;
- (id)initWithVideoURL:(id)arg1;
- (id)initWithVideoURL:(id)arg1 manipulatorFormat:(unsigned long long)arg2;
- (id)initWithVideoAsset:(id)arg1;
- (id)initWithVideoAsset:(id)arg1 manipulatorFormat:(unsigned long long)arg2;
- (id)initWithShareableImage:(id)arg1 remoteUrl:(id)arg2;
- (id)initWithShareableImage:(id)arg1 manipulatorFormat:(unsigned long long)arg2;
- (id)initWithShareableImage:(id)arg1;

@end

