//
//  ViewControler2.m
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "settingsViewController.h"
#import "mainViewController.h"
@implementation settingsViewController

-(IBAction)slidetheslider:(id)sender{
    //updates label after the user has moved the slider
    labelSliderGuesses.text =  [NSString stringWithFormat:@"%1.0f", sliderGuesses.value *9 +1 ];
    labelSliderWords.text =  [NSString stringWithFormat:@"%1.0f", sliderWords.value *23 +1 ];
    //updates NSUserDefaults for guesses and wordlength
    [[NSUserDefaults standardUserDefaults] setInteger:sliderGuesses.value*9+1  forKey:@"numberOfGuesses"]; //hier gaat iets fout met afronden!
    [[NSUserDefaults standardUserDefaults] setInteger:sliderWords.value *23 +1 forKey:@"wordLength"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //updates label after the user has opened the settingspage
    sliderGuesses.value = ((double)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfGuesses"] -1)/9;
    sliderWords.value = ((double)[[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"] -1)/23;
    labelSliderGuesses.text =  [NSString stringWithFormat:@"%1.0f", sliderGuesses.value *9 +1 ];
    labelSliderWords.text =  [NSString stringWithFormat:@"%1.0f", sliderWords.value *23 +1 ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recrented.
}


@end

