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
    
    NSMutableArray *albumArray;
    NSMutableArray *bandArray;
    NSMutableArray *titleArray;
    NSMutableArray* keys;
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
    
  keys = [[NSMutableArray alloc] init];
  bandArray = [[NSMutableArray alloc] init];
  albumArray = [[NSMutableArray alloc] init];
  titleArray = [[NSMutableArray alloc] init];
    
  self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
  self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  self.audioPlot.plotType        = EZPlotTypeRolling;
  self.audioPlot.shouldFill      = YES;
  self.audioPlot.shouldMirror    = YES;
  [self.microphone startFetchingAudio];
  
  //NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
  [self.view addSubview:_playButton];
  [self loadResults:@"Daylight"];
}
-(IBAction)upload
{
    NSString *songName = [[NSString alloc] initWithFormat:@"%@",[titleArray objectAtIndex:0]];
    songName=[songName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self upload:songName comment:@"Cool!"];
}
-(void)upload:(NSString *)song comment:(NSString *)comment
{
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSString * post = [[NSString alloc] initWithFormat:@"%@?comment=%@&time%@",song, comment,resultString];
    NSLog(@"%@",post);
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.193.94/comment/%@",post]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"%@",conn);
    
    if (conn) NSLog(@"Connection Successful");
    
    
}
- (void)playClicked
{
    //NSLog(@"Here");
    if (!_playing) {
        [[self getPlayer] playSource:[keys objectAtIndex:0]];
        [[self getPlayer] playSources:keys];
    } else {
        [[self getPlayer] togglePause];
    }

}

-(void)grabImage
{
    //NSLog(@"First Element : %@", [albumArray objectAtIndex:0]);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://developer.echonest.com/api/v4/artist/images?api_key=ZAIMFQ6WMS5EZUABI&id=%@&format=json&results=1&start=0&license=unknown",[albumArray objectAtIndex:0]]]];
   
    //NSLog(@"%@",request);
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:& error];
    
    
    
    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    //NSLog(@"Grab Image: %@",rawData);
     
    NSDictionary *postData = [rawData objectForKey:@"response"];
    
    NSArray *postDict = [postData objectForKey:@"images"];
  
    
    //NSLog(@"Post Data: %@", postDict);
    //NSLog(@"URL: %@",[[postDict objectAtIndex:0] objectForKey:@"url"]);
    
    NSURL * imageURL = [NSURL URLWithString:[[postDict objectAtIndex:0] objectForKey:@"url"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    
    
    [albumArtwork setImage:[UIImage imageWithData:imageData]];
    
    
}
/*
 * Make sure to sort by most popular
 * Double listings
 */
-(void)loadResults:(NSString *)songName
{
    songName = [songName stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://developer.echonest.com/api/v4/song/search?api_key=ZAIMFQ6WMS5EZUABI&format=json&results=10&title=%@&bucket=id:rdio-US&bucket=tracks&limit=true",songName]]];
    

    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:& error];

    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    
    //NSLog(@"raw: %@",rawData);

    
    NSDictionary *postData = [rawData objectForKey:@"response"];
    NSArray *postDict = [postData objectForKey:@"songs"];
    
    //NSLog(@"raw: %@",postDict);
    if([postDict count]>1)
    {
        NSDictionary *postDict2 = [postDict objectAtIndex:0];

        for(id post in postDict)
        {
            NSLog(@"%@",[post objectForKey:@"artist_id"]);
            [bandArray addObject:[post objectForKey:@"artist_name"]];
            [albumArray addObject:[post objectForKey:@"artist_id"]];
            [titleArray addObject:[post objectForKey:@"title"]];
            
        }
        
        [self grabImage];
        
        //Change to mutable array
        NSString *finalArtists = [postDict2 objectForKey:@"artist_id"];
        
        NSArray *finalTracks = [postDict2 objectForKey:@"tracks"];
      
        NSMutableArray *tracks = [[NSMutableArray alloc] init];

        for( int x=0; x < finalTracks.count; x++)
        {
            NSString * strTracks = [[finalTracks objectAtIndex:x] objectForKey:@"foreign_id"];
            strTracks = [strTracks stringByReplacingOccurrencesOfString:@"rdio-US:track:" withString: @""];
            [keys addObject:strTracks];
        }
     
      
        [artistName setText:[bandArray objectAtIndex:0]];
        [titleName setText:[titleArray objectAtIndex:0]];
        dispatch_async(dispatch_get_main_queue(),^{
            [self playClicked];
        });
        
    }
    
    else
    {
        NSLog(@"There were no results!");
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
        //NSLog(@"here");
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
