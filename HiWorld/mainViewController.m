//
//  ViewController.m
//  HiWorld
//
//  Created by Arent Stienstra on 07-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "mainViewController.h"
#import "gameControler.h"


@interface mainViewController () <UITextFieldDelegate>{
    
    gameControler *game;
}
@end
@implementation mainViewController

@synthesize textField;
@synthesize userOutput;
@synthesize outputGuesses;
@synthesize userGuesedLetters;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
        //prep view
    self.textField.delegate=self;
    self.textField.hidden = YES;
    userOutput.text= textField.text;
    [self newGame:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.pnms
}


// Deze functie wordt elke keer aangeroepen als de gebruiker een toets indrukt.
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        [game gameflow:string]; // gives control to input function
        self.userOutput.text= [NSString stringWithFormat:@"%@" , [self makeStringOutput:[game guessedWord]]];
        self.outputGuesses.text = [NSString stringWithFormat:@"%d" , [game remainingGuesses]];
        self.userGuesedLetters.text = [NSString stringWithFormat:@"%@" , [self sortArray:[game guessedLetters]]];
    if([game gameWon]){
        [self.textField resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What the F _ CK?"
                                                        message:@"You have won. This is weird. Please close the app. Now."
                                                       delegate:self
                                              cancelButtonTitle:@"Victory!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    if([game gameLost]){
        [self.textField resignFirstResponder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HA! "
                                                        message:[NSString stringWithFormat:@"You have lost. Accept it. The correct word was %@ !" , [game aRandomCorrectWord]]
                                                       delegate:self
                                              cancelButtonTitle:@"Victory"
                                              otherButtonTitles:nil];
        [alert show];
    }
    return YES;
}
-(NSString *)sortArray: (NSMutableArray*)array{
    NSMutableArray *array_sorted = [[NSMutableArray alloc]init];
    NSString *string= @"";
    [array_sorted  addObjectsFromArray: [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    for(int i=0;i<[array_sorted count];i++){
        
        string= [NSString stringWithFormat:@"%@%@%@",string, [array_sorted objectAtIndex:i],@" "];
    }
    
    return string;
}

-(NSString *)makeStringOutput: (NSMutableArray*)array{
    NSString *output =@"";
    for( id element in array){
        if([element isEqualToString:@""]){
            output= [NSString stringWithFormat:@"%@%@%@",output, @"_",@" "];
        }
        else{
            output= [NSString stringWithFormat:@"%@%@%@",output, element,@" "];
        }
    }
    
    
    return output;
}


// initializes game controller and resets the game output 
-(IBAction)newGame:(id)sender{
    [self.textField becomeFirstResponder];
    game = [gameControler alloc];
    game = [game init]; 
    self.outputGuesses.text = [NSString stringWithFormat:@"%d" , [game remainingGuesses]];
    self.userOutput.text= [NSString stringWithFormat:@"%@" , [self makeStringOutput:[game guessedWord]]];
    self.userGuesedLetters.text = [NSString stringWithFormat:@"%@" , @""];
}

// Initializes new game if the game/lost alertview has been dismissed.
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self newGame:nil];
    
}


@end
