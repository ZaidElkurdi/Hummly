//
//  RecordViewController.m
//  EZAudioRecordExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2013 Syed Haris Ali. All rights reserved.
//

#import "RecordViewController.h"
#import "Rdio/Rdio.h"
#import "AppDelegate.h"
@interface RecordViewController ()
{
    UIButton *_playButton;
    UIButton *_loginButton;
    RDPlayer* _player;
    BOOL _playing;
}
// Using AVPlayer for example
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,weak) IBOutlet UISwitch *microphoneSwitch;
@property (nonatomic,weak) IBOutlet UILabel *microphoneTextField;
@property (nonatomic,weak) IBOutlet UIButton *playButton;
@property (nonatomic,weak) IBOutlet UILabel *playingTextField;
@property (nonatomic,weak) IBOutlet UISwitch *recordSwitch;
@property (nonatomic,weak) IBOutlet UILabel *recordingTextField;
@end

@implementation RecordViewController
@synthesize player;
@synthesize audioPlot;
@synthesize microphone;
@synthesize microphoneSwitch;
@synthesize microphoneTextField;
@synthesize playButton;
@synthesize playingTextField;
@synthesize recorder;
@synthesize recordSwitch;
@synthesize recordingTextField;

bool alreadyStopped = NO;


#pragma mark - Initialization
-(id)init {
  self = [super init];
  if(self){
    [self initializeViewController];
  }
  return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self){
    [self initializeViewController];
  }
  return self;
}

#pragma mark - Rdio Helper

- (RDPlayer*)getPlayer
{
    if (_player == nil) {
        _player = [AppDelegate rdioInstance].player;
    }
    return _player;
}

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
  self.microphone = [EZMicrophone microphoneWithDelegate:self];
}

#pragma mark - Customize the Audio Plot
-(void)viewDidLoad {
  
  [super viewDidLoad];
  [self playClicked];
    
  self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
  self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  self.audioPlot.plotType        = EZPlotTypeRolling;
  self.audioPlot.shouldFill      = YES;
  self.audioPlot.shouldMirror    = YES;
  [self.microphone startFetchingAudio];
  
  NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
  [self.view addSubview:_playButton];
}
- (void)playClicked
{
    if (!_playing) {
        NSArray* keys = [@"t2742133,t1992210,t7418766,t8816323" componentsSeparatedByString:@","];
        [[self getPlayer] playSources:keys];
    } else {
        [[self getPlayer] togglePause];
    }
}

-(void)toggleRecording {
    
    if(!alreadyStopped)
    {
        [self.microphone stopFetchingAudio];
        [self.audioPlayer stop];
        [[self getPlayer] togglePause];
        [stopRecording setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        alreadyStopped = YES;
    }
    else
    {
        NSLog(@"here");
        [self.microphone startFetchingAudio];
        self.isRecording = YES;
        [[self getPlayer] togglePause];
        [stopRecording setImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        alreadyStopped = NO;
    }
}


#pragma mark - EZMicrophoneDelegate
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
  });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
 
  [EZAudio printASBD:audioStreamBasicDescription];
  
  self.recorder = [EZRecorder recorderWithDestinationURL:[self testFilePathURL]
                                         andSourceFormat:audioStreamBasicDescription];
  
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  
    if( self.isRecording ){
    [self.recorder appendDataFromBufferList:bufferList
                             withBufferSize:bufferSize];
  }
  
}

#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  self.audioPlayer = nil;
  self.playingTextField.text = @"Finished Playing";
  
  [self.microphone startFetchingAudio];
  self.microphoneSwitch.on = YES;
  self.microphoneTextField.text = @"Microphone On";
}

#pragma mark - Utility
-(NSArray*)applicationDocuments {
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

-(NSString*)applicationDocumentsDirectory
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  return basePath;
}

-(NSURL*)testFilePathURL {
  return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],kAudioFilePath]];
}

@end
