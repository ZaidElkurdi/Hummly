//
//  CoreGraphicsWaveformViewController.m
//  EZAudioCoreGraphicsWaveformExample
//
//  Created by Syed Haris Ali on 12/15/13.
//  Copyright (c) 2013 Syed Haris Ali. All rights reserved.
//

#import "CoreGraphicsWaveformViewController.h"

@interface CoreGraphicsWaveformViewController (){
  float scale;
}
#pragma mark - UI Extras
@property (nonatomic,weak) IBOutlet UILabel *microphoneTextLabel;
@end

@implementation CoreGraphicsWaveformViewController
@synthesize audioPlot;
@synthesize microphone;

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

#pragma mark - Initialize View Controller Here
-(void)initializeViewController {
  // Create an instance of the microphone and tell it to use this view controller instance as the delegate
  self.microphone = [EZMicrophone microphoneWithDelegate:self];
}

#pragma mark - Customize the Audio Plot
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /*
   Customizing the audio plot's look
   */
  // Waveform color
  self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  // Plot type
  self.audioPlot.plotType        = EZPlotTypeRolling;
  
  [self.microphone startFetchingAudio];
   
   self.audioPlot.plotType = EZPlotTypeRolling;
  
}

-(void)pinch:(UIPinchGestureRecognizer*)pinch {
  
}

-(void)viewDidAppear:(BOOL)animated
{
    self.audioPlot.plotType = EZPlotTypeRolling;
}

#pragma mark - Actions
-(void)changePlotType:(id)sender {
    
  NSInteger selectedSegment = [sender selectedSegmentIndex];
  switch(selectedSegment){
    case 0:
      [self drawRollingPlot];
      break;
    case 1:
      [self drawRollingPlot];
      break;
    default:
      break;
  }
}
/*
 Give the classic mirrored, rolling waveform look
 */
-(void)drawRollingPlot {
  self.audioPlot.plotType = EZPlotTypeRolling;
  self.audioPlot.shouldFill = YES;
  self.audioPlot.shouldMirror = YES;
}

#pragma mark - EZMicrophoneDelegate
#warning Thread Safety
// Note that any callback that provides streamed audio data (like streaming microphone input) happens on a separate audio thread that should not be blocked. When we feed audio data into any of the UI components we need to explicity create a GCD block on the main thread to properly get the UI to work.
-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  // Getting audio data as an array of float buffer arrays. What does that mean? Because the audio is coming in as a stereo signal the data is split into a left and right channel. So buffer[0] corresponds to the float* data for the left channel while buffer[1] corresponds to the float* data for the right channel.
  
  // See the Thread Safety warning above, but in a nutshell these callbacks happen on a separate audio thread. We wrap any UI updating in a GCD block on the main thread to avoid blocking that audio flow.
  dispatch_async(dispatch_get_main_queue(),^{
    // All the audio plot needs is the buffer data (float*) and the size. Internally the audio plot will handle all the drawing related code, history management, and freeing its own resources. Hence, one badass line of code gets you a pretty plot :)
    [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
  });
}

-(void)microphone:(EZMicrophone *)microphone hasAudioStreamBasicDescription:(AudioStreamBasicDescription)audioStreamBasicDescription {
  // The AudioStreamBasicDescription of the microphone stream. This is useful when configuring the EZRecorder or telling another component what audio format type to expect.
  // Here's a print function to allow you to inspect it a little easier
  [EZAudio printASBD:audioStreamBasicDescription];
}

-(void)microphone:(EZMicrophone *)microphone
    hasBufferList:(AudioBufferList *)bufferList
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
  // Getting audio data as a buffer list that can be directly fed into the EZRecorder or EZOutput. Say whattt...
}

@end
