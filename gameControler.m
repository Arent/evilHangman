//
//  gameControler.m
//  evilHangman
//
//  Created by Arent Stienstra on 29-11-14.
//  Copyright (c) 2014 Arent Stienstra. All rights reserved.
//

#import "gameControler.h"
#import "mainViewController.h"

@implementation gameControler{
    mainViewController *view;
}


//@synthesize gameRunning;
@synthesize guessedWord =_guessedWord;
@synthesize guessedLetters =_guessedLetters;
@synthesize remainingGuesses =_remainingGuesses;
@synthesize aRandomCorrectWord=_aRandomCorrectWord;

-(id) init{
    //load plist
    NSMutableDictionary *myDic = [[NSMutableDictionary alloc] initWithContentsOfFile:
                                  [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"]];
    // load defaults from plist
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    //initialize game variabels
    _remainingGuesses = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"numberOfGuesses"];
    _wordLength = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"wordLength"];
    words= [[myDic valueForKey:@"words"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length == %d",_wordLength]]; //filtert op woordlengte
    remainingLetters = [NSMutableCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    _guessedWord= [[NSMutableArray alloc]init];
    _guessedLetters=[[NSMutableArray alloc]init];
    for(int i = 0;i <_wordLength;i++){
        [_guessedWord addObject:@""];
    }
    return self;
}

- (void)gameflow:(NSString *)input{
    if([self validInput:input]){
        input = [input uppercaseString]; //forces uppercase
        [_guessedLetters addObject:input]; //To show the user wich letters he already guessed
        [self chooseWordSubset:input];//Updates the word list used in the game algoritem
       
    }
    
}

// checks if user input is valid  (as in any letter from the) alphabet
- (Boolean)validInput: (NSString *) input{
    
    // check if input is backspace!
    if(!input.length){
        return NO;
    }
    input = [input uppercaseString]; //forces uppercase
    
    //Checks if the guessed letter has not been guessed before!
    NSCharacterSet *s = [remainingLetters invertedSet];
    NSRange r = [input rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound) {
        return NO;
    }
    [remainingLetters removeCharactersInString:input];
    return YES;
}

// Chooses the new wordset with the evil algorithem
- (void)chooseWordSubset: (NSString *)input{
    
    int totalLength = (int)[words count];
     NSMutableDictionary *equivalanceClasses = [[ NSMutableDictionary alloc] init];
    
    // loops over every word and sorts them in different equivalance classes
    for(int i = 0; i<totalLength;i++){
        NSString *word = [words objectAtIndex:i]; //current word
        int code = [self indicesToCode:[self wordToIndices:word andInput:input]]; //code is the equivalance class (Check indices to co for an explanation)
        NSMutableArray *wordlist = [NSMutableArray array];
        
        
        if( [equivalanceClasses objectForKey:[NSNumber numberWithInt:code]] ){ // checks if the equivalance class alreaddy exist
            wordlist = [equivalanceClasses objectForKey:[NSNumber numberWithInt:code]]; // if so, add
            [wordlist addObject:word];
            [equivalanceClasses setObject:wordlist forKey:[NSNumber numberWithInt:code]];
        }
        else{
            [wordlist addObject:word];
            [equivalanceClasses setObject:wordlist forKey:[NSNumber numberWithInt:code]]; // else create new wordlist
        }
    }
    
    // Determane the largest equivalance class
    int maxLength =0;
    int optimalCode =0;
    int iLength =0;
    for(id element in equivalanceClasses){
        iLength = (int)[[equivalanceClasses objectForKey:element] count];
        if( iLength > maxLength){
            maxLength = iLength ;
            optimalCode = (int)[element integerValue];
        }
    }
    //updates wordlist
    words = [equivalanceClasses objectForKey:[NSNumber numberWithInt:optimalCode]];
    
    // picks a random correct word as the 'awnser' (to show when de user has defeated)
    totalLength = (int)[words count];
    int randomIndex;
    if(totalLength>1){
        randomIndex = arc4random() % (totalLength-1);
    }
    else{
        randomIndex = 0;
    }
    _aRandomCorrectWord = [words objectAtIndex:randomIndex];

    //Update the letters that has been guessed correctly (for the output)
    [self updateGuessedWordWithCode:optimalCode andInput:input];
    if(optimalCode == 0){
        [self setRemainingGuesses:[self remainingGuesses]-1];
    }
    
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

// transfers a range of indices to a number using binairy numbers. i.e [0,1,1,0,0] = (0*1 + 0*2 + 1*4 + 1*8 +0*16 = 12) each code represents an equivalance class
- (int)indicesToCode:(NSMutableArray *)indices{
    int code=0;
    for(int i = 0; i<_wordLength;i++){
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1]){
            code = code + pow(2,_wordLength-i-1);
        }
    }
    return code;
}

// transfers a word and a inputletter to a range of indices. The index will be 0 if the word has a different letter than the inputletter and 1 if the letters are the same. (i.e.  word: CALL and letter L -> [0,0,1,1]
- (NSMutableArray *)wordToIndices: (NSString *)word andInput:(NSString *)input{
    NSMutableArray *indices = [NSMutableArray array];
    for(int i =0; i<_wordLength;i++){
        if([word characterAtIndex:i] == [input characterAtIndex:0]){
            [indices setObject:[NSNumber numberWithInt:1] atIndexedSubscript:i];
        }
        else{
            [indices setObject:[NSNumber numberWithInt:0] atIndexedSubscript:i];
        }
        
    }
    
    return indices;
    
}


//Updates the correctly guessed letters
- (void)updateGuessedWordWithCode:(int)code andInput:(NSString *)input{
    NSMutableArray *indices =[self makeIndices:code];
    for(int i = 0;i<_wordLength;i++)
        if([indices objectAtIndex:i] == [NSNumber numberWithInt:1]){
            [_guessedWord setObject:input atIndexedSubscript:i];
        }
}

// Checks if the game is won
- (Boolean)gameWon{
    
    for( id element in _guessedWord){
        if([element isEqualToString:@""]){
            return NO;
        }
    }
    return YES;
}

// Checks if the game is lost
- (Boolean)gameLost{
    if(_remainingGuesses > 0){
        return NO;
    }
    else{
        return YES;
    }
}


@end

