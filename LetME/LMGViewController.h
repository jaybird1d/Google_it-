//
//  LMGViewController.h
//  LetME
//
//  Created by Lindsay Rosenfeld  on 1/26/13.
//  Copyright (c) 2013 Lindsay Rosenfeld . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface LMGViewController : UIViewController <ADBannerViewDelegate>
{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (nonatomic,assign) BOOL bannerIsVisible;
@property (weak, nonatomic) IBOutlet ADBannerView *bottomAd;


@property (weak, nonatomic) IBOutlet UILabel *tinyurlOutput;
@property (weak, nonatomic) IBOutlet UILabel *basicURL;
@property (weak, nonatomic) IBOutlet UILabel *feedbackMsg;


@end
