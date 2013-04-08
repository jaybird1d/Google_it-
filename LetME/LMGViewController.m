//
//  LMGViewController.m
//  LetME
//
//  Created by Lindsay Rosenfeld  on 1/26/13.
//  Copyright (c) 2013 Lindsay Rosenfeld . All rights reserved.
//

#import "LMGViewController.h"
#import "ILBitly.h"
#import "MessageUI.h"


#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

NSString *finalLink;

@interface LMGViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchentry;

@end

@implementation LMGViewController

@synthesize tinyurlOutput = _tinyurlOutput;
@synthesize searchentry = _searchentry;
@synthesize basicURL    = _basicURL;
@synthesize feedbackMsg = _feedbackMsg;
@synthesize bottomAd = _bottomAd;
@synthesize bannerIsVisible = _bannerIsVisible;

- (void)viewDidLoad {
    _bottomAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    _bottomAd.frame = CGRectOffset(_bottomAd.frame, 0, -50);
    _bottomAd.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    
    _bottomAd.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self.view addSubview:_bottomAd];
    _bottomAd.delegate=self;
    self.bannerIsVisible=NO;
    [super viewDidLoad];
}


-(void)hidekeyboard
{
    [self.searchentry resignFirstResponder];
    [self resignFirstResponder];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)enteredsearch:(id)sender {
    NSString *base = @"http://www.lmgtfy.com/?q=";
    NSString *input = _searchentry.text;
    NSString *escapedInput = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)input,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8);
    //NSString *shortened = shortenerBitly:escapedInput;
    NSString *link = [NSString stringWithFormat:@"%@%@", base, escapedInput];
    self.basicURL.text = link;
    //[self runShortener];
    

    ILBitly *bitly = [[ILBitly alloc] initWithLogin:@"jaybird1d" apiKey:@"R_455eab58f9edb8976047bf48c63aa999"];
    [bitly shorten:link result:^(NSString *shortURLString) {
        NSLog(@"SHORTENED LINK: %@", shortURLString);
        finalLink = [[NSString alloc] initWithString:shortURLString];
        self.basicURL.text = shortURLString;
        self.tinyurlOutput.text = @"Link is now copied to your clipboard!";
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.basicURL.text;
    } error:^(NSError *err) {
        NSLog(@"An error occurred %@", err);
    }];
    
}
- (IBAction)editingDidStart:(id)sender {
    self.tinyurlOutput.text = @"Press Return to Generate bit.ly!";
}

- (IBAction)messageaLink:(id)sender {
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.messageComposeDelegate = self;
        controller.body = [[self.searchentry.text stringByAppendingString:@" "]  stringByAppendingString:self.basicURL.text];
        //controller.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
        //controller.messageComposeDelegate = self.tinyurlOutput.text;
        //controller.messageComposeDelegate = [self.searchentry.text stringByAppendingString:(self.tinyurlOutput.text)];
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}


- (IBAction)emailaLink:(id)sender {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController* viewController = [[MFMailComposeViewController alloc] init];
            
           
            viewController.mailComposeDelegate = self;
            NSString *subject = self.basicURL.text;
            [viewController setSubject:_searchentry.text];
            [viewController setMessageBody:subject isHTML:NO];
            if (viewController)
                [self presentViewController:viewController animated:YES completion:nil];
            
            NSLog(@"deniz");
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Your device doesn't support the composer sheet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
    {
        if (result == MFMailComposeResultSent || result == MFMailComposeResultFailed || result == MFMailComposeResultCancelled) {
            NSLog(@"It's away!");
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    _feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            _feedbackMsg.text = @"Result: SMS sending canceled";
            break;
        case MessageComposeResultSent:
            _feedbackMsg.text = @"Result: SMS sent";
            break;
        case MessageComposeResultFailed:
            _feedbackMsg.text = @"Result: SMS sending failed";
            break;
        default:
            _feedbackMsg.text = @"Result: SMS not sent";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end