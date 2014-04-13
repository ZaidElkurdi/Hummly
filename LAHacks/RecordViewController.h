#import <UIKit/UIKit.h>
#import "EZAudio.h"
#import <AVFoundation/AVFoundation.h>
#import "Rdio/Rdio.h"
#define kAudioFilePath @"LAHacks.mp3"

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate,AVAudioRecorderDelegate,RdioDelegate,RDPlayerDelegate, EZMicrophoneDelegate>
{
    IBOutlet UIButton *stopRecording;
    IBOutlet UIImageView *albumArtwork;
    IBOutlet UILabel *artistName;
    IBOutlet UILabel *titleName;
    AVAudioRecorder *audioRecorder;
    
}
-(IBAction)stop:(id)sender;
-(IBAction)stop:(id)sender;
@property (retain) RDPlayer *player;
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) EZRecorder *recorder;
@property (nonatomic,assign) BOOL isRecording;

#pragma mark - Actions
-(IBAction)toggleRecording;

@end
