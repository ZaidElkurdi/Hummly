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
#import "SBJson4.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController ()
{
    UIButton *_playButton;
    UIButton *_loginButton;
    RDPlayer* _player;
    BOOL _playing;
    
    BOOL isPlaying;
    BOOL isRecording;
    
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
@synthesize audioPlayer;
@synthesize microphoneSwitch;
@synthesize microphoneTextField;
@synthesize playButton;
@synthesize playingTextField;
@synthesize recordSwitch;
@synthesize recordingTextField;
@synthesize songChosen;
bool alreadyStopped = NO;



#pragma mark - Rdio Helper

- (RDPlayer*)getPlayer
{
    if (_player == nil) {
        _player = [AppDelegate rdioInstance].player;
    }
    return _player;
}
-(void)accessLyric
{

    NSURL *idURL = [NSURL URLWithString:@"http://api.musixmatch.com/ws/1.1/track.search?apikey=87600b0ccf64e49602b54a6a5315c51b&s_track_rating=DESC&&q_track=lights&format=json&page_size=1&page=1&f_has_lyrics=1"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:idURL];    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* json_string = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions 
                          error:nil];
    
    NSDictionary* valid = [[[json_string objectForKey:@"message"] objectForKey:@"header"] objectForKey:@"available"];
    if (![[NSString stringWithFormat:@"%@",valid] isEqualToString:@"0"])
	{
        //NSLog(@"Song Found in Database");
        NSDictionary* results1 = [json_string objectForKey:@"message"];
        NSDictionary* results2 = [results1 objectForKey:@"body"];
        NSArray* results3 = [results2 objectForKey:@"track_list"];
        NSDictionary* results4 = [results3 objectAtIndex:0];
        NSDictionary* results5 = [results4 objectForKey:@"track"];
        //NSLog(@"Track id: %@",[results5 objectForKey:@"track_id"]);
        [self displayLyrics:[results5 objectForKey:@"track_id"]];

        
    }
    
    
}
-(void)displayLyrics:(NSString *)trackS
{
    NSURL *idURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=%@&apikey=87600b0ccf64e49602b54a6a5315c51b",trackS]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:idURL];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* json_string = [NSJSONSerialization
                                 JSONObjectWithData:response
                                 options:kNilOptions
                                 error:nil];
    
    //NSLog(@"JSon: %@",json_string);
    
    
    NSDictionary* valid = [[[json_string objectForKey:@"message"] objectForKey:@"header"] objectForKey:@"available"];
    if (![[NSString stringWithFormat:@"%@",valid] isEqualToString:@"0"])
	{
        //NSLog(@"Song Found in Database");
        
        NSDictionary* results1 = [json_string objectForKey:@"message"];
        NSDictionary* results2 = [results1 objectForKey:@"body"];
        NSDictionary* results3 = [results2 objectForKey:@"lyrics"];
        NSString* lyrics = [results3 objectForKey:@"lyrics_body"];
        
        NSRange end = [lyrics rangeOfString:@"*"];
        lyrics = [lyrics substringWithRange:NSMakeRange(0, end.location)];
        [lyricsDisplay setText:lyrics];
        
    }

}
-(void)checkTennysonFirst
{
    NSString *myString = @"http://foo.bar/?key[]=value[]<>";
    NSURL *myUrl = [NSURL URLWithString:[myString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

-(void)uploadAudio
{
    
    NSLog(@"Uploading audio");
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"LAHacks.mp3"];
    

    
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:soundFilePath error: NULL];
    
    //NSLog(@"%@",fileAttributes);
    if (fileAttributes != nil) {
        
        NSNumber *fileSize;
        fileSize = [fileAttributes objectForKey:NSFileSize];
        //NSLog(@"%@",fileSize);
        
        NSData *audioData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LAHacks" ofType:@".mp3"]];
        
        NSString *urlString = [NSString stringWithFormat:@"http://107.170.193.94/song/%@?genre=%@",songChosen, @"Rock"];
        
        
        NSLog(@"Audio Data: %@",audioData);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"audio\"; filename=\".mp3\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:audioData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString* returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"Return: %@",returnString);
        
    }
    
}

-(IBAction)didTapListen:(id)sender
{{
    if(isPlaying==false)
    {
        [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
        ^{
         CGRect newFrame = rightView.frame;
         CGRect newViewFrame = recordButton.frame;
         
         newFrame.origin.x += 160;
         newViewFrame.origin.x += 95;
         
         CGRect newLeftFrame = leftView.frame;
         CGRect newLeftViewFrame = playButton.frame;
         
         newLeftFrame.size.width += 160;
         newLeftViewFrame.origin.x += 80;

         
         rightView.frame=newFrame;
         recordButton.frame = newViewFrame;
         leftView.frame=newLeftFrame;
         playButton.frame=newLeftViewFrame;
         
        NSLog(@"Begin recording");
         
        [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:nil];
        [[self getPlayer] playSource:[keys objectAtIndex:0]];
        [[self getPlayer] playSources:keys];
        isPlaying = true;
        [playButton setImage:[UIImage imageNamed:@"stopIcon.png"] forState:UIControlStateNormal];
        }
     
                     completion:nil];
    }
    
    else
    {
        //NSLog(@"Was already playing");
        [[self getPlayer] togglePause];
        isPlaying=false;
        
        [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
     ^{
         CGRect newFrame = rightView.frame;
         CGRect newViewFrame = recordButton.frame;
         
         newFrame.origin.x -= 160;
         newViewFrame.origin.x -= 95;
         
         CGRect newLeftFrame = leftView.frame;
         CGRect newLeftViewFrame = playButton.frame;
         
         newLeftFrame.size.width -= 160;
         newLeftViewFrame.origin.x -= 80;

         
         rightView.frame=newFrame;
         recordButton.frame = newViewFrame;
         leftView.frame=newLeftFrame;
         playButton.frame=newLeftViewFrame;
         
        [playButton setImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
     }
     
                     completion:nil];
    }
    }
}

- (IBAction)didTapRecord:(id)sender
{
    if(isRecording==false)
    {
        [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
        ^{
         CGRect newFrame = rightView.frame;
         CGRect newViewFrame = recordButton.frame;
         
         newFrame.size.width += 320;
         newFrame.origin.x -= 160;
         newViewFrame.origin.x -= 80;
         
         CGRect newLeftFrame = leftView.frame;
         CGRect newLeftViewFrame = playButton.frame;
         
         newLeftFrame.origin.x -= 160;
         newLeftViewFrame.origin.x -= 160;

         
         rightView.frame=newFrame;
         recordButton.frame = newViewFrame;
         leftView.frame=newLeftFrame;
         playButton.frame=newLeftViewFrame;
         
        //NSLog(@"Begin recording");
          
        [self performSelector:@selector(downloadContent) withObject:nil];
            
        
        [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:nil];
        [audioRecorder record];
        isRecording=true;
        [[self getPlayer] playSource:[keys objectAtIndex:0]];
        [[self getPlayer] playSources:keys];
        [recordButton setImage:[UIImage imageNamed:@"stopIcon.png"] forState:UIControlStateNormal];
         
         
            
        }
     
                     completion:nil];
    }
    
    else
    {
        //NSLog(@"Was already recording");
        [audioRecorder stop];
        isRecording=false;
        [[self getPlayer] togglePause];
        
        [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
     ^{
         CGRect newFrame = rightView.frame;
         CGRect newViewFrame = recordButton.frame;
         
         newFrame.size.width -= 320;
         newFrame.origin.x += 160;
         newViewFrame.origin.x += 80;
         
         CGRect newLeftFrame = leftView.frame;
         CGRect newLeftViewFrame = playButton.frame;
         
         newLeftFrame.origin.x += 160;
         newLeftViewFrame.origin.x += 160;

         
         rightView.frame=newFrame;
         recordButton.frame = newViewFrame;
         leftView.frame=newLeftFrame;
         playButton.frame=newLeftViewFrame;
         
        [recordButton setImage:[UIImage imageNamed:@"recordButton.png"] forState:UIControlStateNormal];
     }
     
                     completion:nil];
    }
    
    [self uploadAudio];
}

-(void)grabImage
{
    ////NSLog(@"First Element : %@", [albumArray objectAtIndex:0]);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://developer.echonest.com/api/v4/artist/images?api_key=ZAIMFQ6WMS5EZUABI&id=%@&format=json&results=1&start=0&license=unknown",[albumArray objectAtIndex:0]]]];
   
    ////NSLog(@"%@",request);
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:& error];
    
    
    
    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    ////NSLog(@"Grab Image: %@",rawData);
     
    NSDictionary *postData = [rawData objectForKey:@"response"];
    
    NSArray *postDict = [postData objectForKey:@"images"];
  
    
    ////NSLog(@"Post Data: %@", postDict);
    ////NSLog(@"URL: %@",[[postDict objectAtIndex:0] objectForKey:@"url"]);
    
    NSURL * imageURL = [NSURL URLWithString:[[postDict objectAtIndex:0] objectForKey:@"url"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    
    
    [albumArtwork setImage:[UIImage imageWithData:imageData]];
    
    
}
#pragma mark - Customize the Audio Plot
-(void)viewDidLoad {
    
    [super viewDidLoad];
    //songChosen = [[NSString alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    songChosen = [prefs stringForKey:@"song"];
    
    NSLog(@"Song Chosen: %@",songChosen);
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"LAHacks.mp3"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    //Initialize audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //Override record to mix with other app audio, background audio not silenced on record
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(UInt32), &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryPlayAndRecord" error:nil];
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        //NSLog(@"error: %@", [error localizedDescription]);
    } else
    {
        [audioRecorder prepareToRecord];
    }
    
    keys = [[NSMutableArray alloc] init];
    bandArray = [[NSMutableArray alloc] init];
    albumArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];
    
    self.audioPlot.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
    self.audioPlot.color           = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.audioPlot.plotType        = EZPlotTypeRolling;
    self.audioPlot.shouldFill      = YES;
    self.audioPlot.shouldMirror    = YES;
    
    ////NSLog(@"File written to application sandbox's documents directory: %@",[self testFilePathURL]);
    
    [self.view addSubview:_playButton];
    
    
    
    NSLog(@"Preparing..");
    [self loadResults:songChosen];
    [self performSelector:@selector(uploadAudio) withObject:nil];
    [self performSelector:@selector(accessLyric) withObject:nil];

    NSLog(@"Complete.");
}
-(void)downloadContent
{
    NSString *url = [NSString stringWithFormat:@"http://107.170.193.94/song/%@",songChosen];
    
    NSLog(@"URL: %@",url);
    NSURL* checkURL = [NSURL URLWithString:url];
    
    NSData* checkData = [[NSData alloc] initWithContentsOfURL:checkURL];
    
    NSString* HTMLFromURL = [[NSString alloc] initWithData:checkData encoding:NSASCIIStringEncoding];
    
    NSArray* HTMLStole = [HTMLFromURL componentsSeparatedByString: @","];
    
    NSLog(@"HTMLStole %@",[HTMLStole objectAtIndex:0]);
    
    NSString* day = [HTMLStole objectAtIndex: 0];
    NSString* songName = [NSString alloc];
    
    songName = [day substringWithRange:NSMakeRange(9, [day length] - 10)];
    
    NSLog(@"Song Name: %@", songName);
    
    NSString *updatedUrl = [NSString stringWithFormat:@"http://107.170.193.94/%@",songName];
    
    NSLog(@"Processed URL: %@", updatedUrl);
    
    NSURL *urlDownload = [NSURL URLWithString:updatedUrl];
                  
                  
    playerItem = [AVPlayerItem playerItemWithURL:urlDownload];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    
    self.player = [AVPlayer playerWithURL:urlDownload];
    [player play];
                  
    
    //Song name now contains the file that everyone contains
    
}
/*
 * Make sure to sort by most popular
 * Double listings
 */
-(void)loadResults:(NSString *)songName
{

    NSString * format = [[NSString alloc] initWithFormat:@"http://developer.echonest.com/api/v4/song/search?api_key=ZAIMFQ6WMS5EZUABI&format=json&results=2&title=%@&bucket=id:rdio-US&bucket=tracks&limit=true",songName];
    format = [format stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *idURL = [NSURL URLWithString:format];
    NSURLRequest *request = [NSURLRequest requestWithURL:idURL];
    
    NSLog(@"URL Request: %@", request);
    
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:& error];

    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];

    
    NSDictionary *postData = [rawData objectForKey:@"response"];
    NSArray *postDict = [postData objectForKey:@"songs"];
    
    ////NSLog(@"raw: %@",postDict);
    if([postDict count]>1)
    {
        NSDictionary *postDict2 = [postDict objectAtIndex:0];

        for(id post in postDict)
        {
            //NSLog(@"%@",[post objectForKey:@"artist_id"]);
            [bandArray addObject:[post objectForKey:@"artist_name"]];
            [albumArray addObject:[post objectForKey:@"artist_id"]];
            [titleArray addObject:[post objectForKey:@"title"]];
            
        }
        
        [self grabImage];
        
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
        
        NSLog(@"Artist name: %@", artistName);
    }
    
    else
    {
        //NSLog(@"There were no results!");
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    [self stop];
}

#pragma mark - EZMicrophoneDelegate
-(IBAction)recordAudio:(id)sender
{
}

-(void)upload:(NSString *)song comment:(NSString *)comment
{
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    
    NSString * post = [[NSString alloc] initWithFormat:@"%@?comment=%@&time%@",song, comment,resultString];
    //NSLog(@"%@",post);
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString * postLength = [NSString stringWithFormat:@"%d",[postData length]];
    
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.193.94/comment/%@",post]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"%@",conn);
    
    if (conn) NSLog(@"Connection Successful");
    
    
}

-(IBAction)stop
{
    if (audioRecorder.recording)
    {
        //NSLog(@"Stopping recording");
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
            [audioPlayer stop];
    }
    
    //Add code here to upload
    
    
}


-(void) playAudio
{
    if (!audioRecorder.recording)
    {
        NSError *error;

        audioPlayer = [[AVAudioPlayer alloc] 
        initWithContentsOfURL:audioRecorder.url                                    
        error:&error];

        audioPlayer.delegate = self;

        if (error)
              //NSLog(@"Error: %@");
              [error localizedDescription];
        else
              [audioPlayer play];
   }
}
-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player 
error:(NSError *)error
{
        //NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder 
successfully:(BOOL)flag
{
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder 
error:(NSError *)error
{
        //NSLog(@"Encode Error occurred");
}

-(void)microphone:(EZMicrophone *)microphone
 hasAudioReceived:(float **)buffer
   withBufferSize:(UInt32)bufferSize
withNumberOfChannels:(UInt32)numberOfChannels {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.audioPlot updateBuffer:buffer[0] withBufferSize:bufferSize];
  });
}

#pragma mark - Utility
-(NSArray*)applicationDocuments
{
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
