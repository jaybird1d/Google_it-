//
//  LMGViewController.h
//  LetME
//
//  Created by Lindsay Rosenfeld  on 1/26/13.
//  Copyright (c) 2013 Lindsay Rosenfeld . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMGViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tinyurlOutput;
@property (weak, nonatomic) IBOutlet UILabel *basicURL;
@property (weak, nonatomic) IBOutlet UILabel *feedbackMsg;


@end
