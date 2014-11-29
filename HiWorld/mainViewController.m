//
//  ViewController.m
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "mainViewController.h"

@interface mainViewController () <UITextFieldDelegate>{
    
    int guesses;
    int wordLength;
    NSUserDefaults *userDefaults ;
}

@end

@implementation mainViewController



@synthesize textField;
@synthesize userOutput;
@synthesize outputGuesses;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    //init new game
        //load plist
    NSMutableDictionary *myDic = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
        // load defaults from plist
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
        //prep view
    self.textField.delegate=self;
    self.textField.hidden = YES;
    [self.textField becomeFirstResponder];
    userOutput.text= textField.text;
    
    // resume game
    guesses = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfGuesses"]; //waarschijnlijk niet de goede plek!
    wordLength = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"]; //waarschijnlijk niet de goede plek!
    self.outputGuesses.text = [NSString stringWithFormat:@"%d" , guesses]; // moet naar een init game plaats
    
   // int y = 130;
    //for (NSString *tf in [myDic valueForKey:@"words"]){
     //   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30,y,300,20)] ;
      //  label.text = tf;
       // [self.view addSubview:label];
       // y=y+30;
   // }
    //i
    //NSArray * words= [[myDic valueForKey:@"words"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > %d",wordLength]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userOutput.text= [NSString stringWithFormat:@"%@%@" , self.userOutput.text, string];
    
    guesses = (int)[userDefaults integerForKey:@"numberOfGuesses"] -1;
    self.outputGuesses.text = [NSString stringWithFormat:@"%d" , guesses];
    [userDefaults setInteger:guesses forKey:@"numberOfGuesses"];
    [userDefaults synchronize];
    return YES;
}
@end
