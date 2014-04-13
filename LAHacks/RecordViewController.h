#import <UIKit/UIKit.h>
#import "EZAudio.h"
#import <AVFoundation/AVFoundation.h>
#import "Rdio/Rdio.h"
#define kAudioFilePath @"LAHacks.mp3"

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate,EZMicrophoneDelegate,RdioDelegate,RDPlayerDelegate>
{
    IBOutlet UIButton *stopRecording;
    IBOutlet UIButton *upload;
    IBOutlet UIImageView *albumArtwork;
    IBOutlet UILabel *artistName;
    IBOutlet UILabel *titleName;
}

@property (retain) RDPlayer *player;
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic,assign) BOOL isRecording;
@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) EZRecorder *recorder;
@property (nonatomic,strong) NSString *songName;

#pragma mark - Actions
-(IBAction)toggleRecording;
-(IBAction)upload;

@end
