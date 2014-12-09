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
    [self.textField becomeFirstResponder];
    userOutput.text= textField.text;
    game = [gameControler alloc];
    //if(![[NSUserDefaults standardUserDefaults] boolForKey:@"runningGame"]){// doensnt work
    game = [game init]; //initialize new game if this has not been done yet (ubfi)
    //}
    self.outputGuesses.text = [NSString stringWithFormat:@"%d" , [game remainingGuesses]];
    self.userOutput.text= [NSString stringWithFormat:@"%@" , [self makeStringOutput:[game guessedWord]]];
    self.userGuesedLetters.text = [NSString stringWithFormat:@"%@" , @""];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. Geen idee wat ik hier zou moeten doen
}


// Deze functie wordt elke keer aangeroepen als de gebruiker een toets indrukt.
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([game validInput:string] == YES) { //kijkt of de input goed is
        [game input:string ]; // handeld verder met de input //er is een nieuwe woordenlijst
        if([game gameWon]){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"WHAT?"
                                                              message:@"This is inpossible, the Human has WON!"
                                                             delegate:self
                                                    cancelButtonTitle:@"VICTORY"
                                                    otherButtonTitles:nil];
            [message show];
            
        }
        if([game gameLost]){
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"HAHA!"
                                                              message:@"The Human has lost."
                                                             delegate:self
                                                    cancelButtonTitle:@"I ACCEPT DEFEAT"
                                                    otherButtonTitles:nil];
            
            [message show];
        }
        
        self.userOutput.text= [NSString stringWithFormat:@"%@" , [self makeStringOutput:[game guessedWord]]];
        self.outputGuesses.text = [NSString stringWithFormat:@"%d" , [game remainingGuesses]];
        self.userGuesedLetters.text = [NSString stringWithFormat:@"%@" , [self sortArray:[game guessedLetters]]];
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
-(IBAction)newGame:(id)sender{
    game = [gameControler alloc];
    game = [game init]; 
    self.outputGuesses.text = [NSString stringWithFormat:@"%d" , [game remainingGuesses]];
    self.userOutput.text= [NSString stringWithFormat:@"%@" , [self makeStringOutput:[game guessedWord]]];
    self.userGuesedLetters.text = [NSString stringWithFormat:@"%@" , @""];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

        if (buttonIndex == 0) {// 1st Other Button
            [self newGame:nil];
        }
    }


@end
