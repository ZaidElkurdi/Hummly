#import <UIKit/UIKit.h>
#import "EZAudio.h"
#import <AVFoundation/AVFoundation.h>
#import "Rdio/Rdio.h"
#define kAudioFilePath @"LAHacks.mp3"

@interface RecordViewController : UIViewController <AVAudioPlayerDelegate,AVAudioRecorderDelegate,RdioDelegate,RDPlayerDelegate, EZMicrophoneDelegate>
{
    IBOutlet UIButton *recordButton;
    IBOutlet UIButton *listenButton;
    IBOutlet UIImageView *albumArtwork;
    IBOutlet UILabel *artistName;
    IBOutlet UILabel *titleName;
    AVAudioRecorder *audioRecorder;
    
}
-(void)stopRecording;
-(void)stopListening;
-(IBAction)startRecording:(id)sender;
-(IBAction)startListening:(id)sender;
@property (retain) RDPlayer *player;
@property (nonatomic,weak) IBOutlet EZAudioPlot *audioPlot;
@property (nonatomic,strong) EZMicrophone *microphone;
@property (nonatomic,strong) EZRecorder *recorder;
@property (nonatomic,assign) BOOL isRecording;
@property (nonatomic,assign) NSInteger numPeople;
@property (nonatomic,assign) NSInteger numComments;

#pragma mark - Actions
-(IBAction)toggleRecording;
-(IBAction)upload;

@end
