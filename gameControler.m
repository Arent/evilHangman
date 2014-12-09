//
//  gameControler.m
//  evilHangman
//
//  Created by Arent Stienstra on 29-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "gameControler.h"

@implementation gameControler


//@synthesize gameRunning;
@synthesize guessedWord =_guessedWord;
@synthesize guessedLetters =_guessedLetters;
@synthesize remainingGuesses =_remainingGuesses;

-(id) init{
    //load plist
    NSMutableDictionary *myDic = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    // load defaults from plist
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    _remainingGuesses = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfGuesses"];
    _wordLength = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
    words= [[myDic valueForKey:@"words"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length == %d",_wordLength]]; //filtert op woordlengte
    remainingLetters = [NSMutableCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    //[self setGameRunning:YES];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"runningGame"]; dit werkt allemaal niet, even vragen
    //[[NSUserDefaults standardUserDefaults] synchronize];
    _guessedWord= [[NSMutableArray alloc]init];
    _guessedLetters=[[NSMutableArray alloc]init];

    for(int i = 0;i <_wordLength;i++){
        [_guessedWord addObject:@""];
    }

    return self;
}


- (Boolean)gameWon{

    for( id element in _guessedWord){
        
        if([element isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
            
}


- (Boolean)gameLost{
    if(_remainingGuesses > 0){
        return NO;
    }
    else{
        return YES;
    }
}


- (Boolean)validInput: (NSString *) input{
    // checks if user input is valid  (as in any letter from the) alphabet
    // check if input is backspace!
    if(!input.length){
        return NO;
    }
    
    input = [input lowercaseString]; //forces lowercase
    NSCharacterSet *s = [remainingLetters invertedSet];
    NSRange r = [input rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return NO;
    }
    [remainingLetters removeCharactersInString:input];
    return YES;
}


- (void)input: (NSString *) input{
    // handels the input,
    input = [input lowercaseString]; //forces lowercase
    [self setRemainingGuesses:[self remainingGuesses]-1];
    [_guessedLetters addObject:input];
    [self chooseWordSubset:input]; //NSPredicate
    //update words
}


- (void)chooseWordSubset: (NSString *)input{
    NSMutableDictionary *results = [[ NSMutableDictionary alloc] init];
    
    NSUInteger totalLength = [words count];
    int end = pow(2,(_wordLength))-1;
    int max = -1;
    int bestCode =0;

    for( int i = 0 ; i <= end ;i++ ){
        
        if([self validCode:i]){
    
            NSMutableDictionary *result = [[ NSMutableDictionary alloc] init];
            NSPredicate *predicate = [self makePredicateIndices:[self makeIndices:i] andInput:input];
            NSArray *resultWords = [words filteredArrayUsingPredicate:predicate];
            NSUInteger resultLen = [resultWords count];
            if((int)resultLen > max){
                max = (int)resultLen;
                bestCode = i;
                [result setObject:resultWords forKey:@"words"];
                [results setObject:result forKey:[NSNumber numberWithInt:i]];
                if(max > totalLength/2){
                    break;
                }
            }
        }
    }
    //
    words = [[results objectForKey:[NSNumber numberWithInt:bestCode]] objectForKey:@"words"];
    NSLog(@"The wordlist is: %@",words);
    [self updateGuessedWordWithCode:bestCode andInput:input];

}

- (NSPredicate *)makePredicateIndices:(NSMutableArray *)indices andInput:(NSString *)input{

    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings){
        
        for(int i=0; i<_wordLength;i++){
            if([evaluatedObject characterAtIndex:i] == [input characterAtIndex:0]){
                if( [[indices objectAtIndex:i] integerValue] == 0){
                    return NO;
                }
            }
            if([evaluatedObject characterAtIndex:i] != [input characterAtIndex:0]){
                if( [[indices objectAtIndex:i] integerValue] == 1){
                    return NO;
                }
            }
        }
        return YES;
    }];
    
    return predicate;
}

-(NSMutableArray *)makeIndices:(int)code{
    
    //code to range with indecis that will be the input letter
    NSMutableArray *indices = [NSMutableArray array];
    
        for( double i =_wordLength-1; i >= 0; i--){
            if(code - pow(2,i) >=0 ){
                code = code -pow(2,i);
                [indices setObject:[NSNumber numberWithInt:1] atIndexedSubscript:_wordLength-i-1];
            }
            else{
                [indices setObject:[NSNumber numberWithInt:0] atIndexedSubscript:_wordLength-i-1];
            }
        }
    return indices;
}

-(Boolean)validCode:(int)code{
    NSMutableArray *indices =[self makeIndices:code];
    for(int i = 0;i<_wordLength;i++)
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1] && ![[_guessedWord objectAtIndex:i] isEqualToString:@""]){
            return NO;
        }
    
    
    return YES;
}

- (void)updateGuessedWordWithCode:(int)code andInput:(NSString *)input{
    NSMutableArray *indices =[self makeIndices:code];
    for(int i = 0;i<_wordLength;i++)
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1]){
            [_guessedWord setObject:input atIndexedSubscript:i];
        }

}
@end

