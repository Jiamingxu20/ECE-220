/* Intro: the program is a small code-breaking game.
 * It composed of three parts: set_seed, start_game, and make_guess.
 * set_seed: this function sets the value for pseudorandom and check for invalid input.
 * start_game: this function creates solutions for the game.
 * make_guess: this function takes and checks user's guess and provide feedback
 * concerning perfect matches and misplaced matches.
 */

#include <stdio.h>
#include <stdlib.h>

#include "prog5.h"



static int guess_number;
static int solution1;
static int solution2;
static int solution3;
static int solution4;


/*
 * set_seed -- This function sets the seed value for pseudorandom
 * number generation based on the number the user types.
 * The input entered by the user is already stored in the string seed_str by the code in main.c.
 * This function should use the function sscanf to find the integer seed value from the 
 * string seed_str, then initialize the random number generator by calling srand with the integer
 * seed value. To be valid, exactly one integer must be entered by the user, anything else is invalid. 
 * INPUTS: seed_str -- a string (array of characters) entered by the user, containing the random seed
 * OUTPUTS: none
 * RETURN VALUE: 0 if the given string is invalid (string contains anything
 *               other than a single integer), or 1 if string is valid (contains one integer)
 * SIDE EFFECTS: initializes pseudo-random number generation using the function srand. Prints "set_seed: invalid seed\n"
 *               if string is invalid. Prints nothing if it is valid.
 */

int set_seed (const char seed_str[]){
    int seed;
    char post[2];
    int valid = sscanf (seed_str, "%d%1s", &seed, post);
    if (valid == 1) {
      srand(seed);
        return 1;
    } else {
      printf("set_seed: invalid seed\n");
        return 0; 
    }
}


/*
 * start_game -- This function is called by main.c after set_seed but before the user makes guesses.
 *               This function creates the four solution numbers using the approach
 *               described in the wiki specification (using rand())
 *               The four solution numbers should be stored in the static variables defined above. 
 *               The values at the pointers should also be set to the solution numbers.
 *               The guess_number should be initialized to 1 (to indicate the first guess)
 * INPUTS: none
 * OUTPUTS: *one -- the first solution value (between 1 and 8)
 *          *two -- the second solution value (between 1 and 8)
 *          *three -- the third solution value (between 1 and 8)
 *          *four -- the fourth solution value (between 1 and 8)
 * RETURN VALUE: none
 * SIDE EFFECTS: records the solution in the static solution variables for use by make_guess, set guess_number
 */


void start_game (int* one, int* two, int* three, int* four){
    guess_number = 1;
    solution1 = rand()%8+1;
    solution2 = rand()%8+1;
    solution3 = rand()%8+1;
    solution4 = rand()%8+1;
    *one = solution1;
    *two = solution2;
    *three = solution3;
    *four = solution4;
}


/*
 * make_guess -- This function is called by main.c after the user types in a guess.
 *               The guess is stored in the string guess_str. 
 *               The function must calculate the number of perfect and misplaced matches
 *               for a guess, given the solution recorded earlier by start_game
 *               The guess must be valid (contain only 4 integers, within the range 1-8). If it is valid
 *               the number of correct and incorrect matches should be printed, using the following format
 *               "With guess %d, you got %d perfect matches and %d misplaced matches.\n"
 *               If valid, the guess_number should be incremented.
 *               If invalid, the error message "make_guess: invalid guess\n" should be printed and 0 returned.
 *               For an invalid guess, the guess_number is not incremented.
 * INPUTS: guess_str -- a string consisting of the guess typed by the user
 * OUTPUTS: the following are only valid if the function returns 1 (A valid guess)
 *          *one -- the first guess value (between 1 and 8)
 *          *two -- the second guess value (between 1 and 8)
 *          *three -- the third guess value (between 1 and 8)
 *          *four -- the fourth color value (between 1 and 8)
 * RETURN VALUE: 1 if the guess string is valid (the guess contains exactly four
 *               numbers between 1 and 8), or 0 if it is invalid
 * SIDE EFFECTS: prints (using printf) the number of matches found and increments guess_number(valid guess) 
 *               or an error message (invalid guess)
 *               (NOTE: the output format MUST MATCH EXACTLY, check the wiki writeup)
 */


int make_guess (const char guess_str[], int* one, int* two, 
	    int* three, int* four){
    int w, x, y, z;
    char post[2];
    int good = sscanf (guess_str, "%d%d%d%d%1s", &w, &x, &y, &z, post);
    if (w < 1 || w > 8 || x < 1 || x > 8 || y < 1 || y > 8 || z < 1 || z > 8 || good != 4) {
        printf("make_guess: invalid guess\n");
        return 0;
    }
    
// Store values of guesses.
    *one = w;
    *two = x;
    *three = y;
    *four = z;
    
//  Create Guess array and Solution array.
    int guessarray[4];
    int solutionarray[4];
    
//  Calculate the number of Perfect Match.
    int perfectmatch = 0;
    int counter = -1;
    
    if (w == solution1) {
        perfectmatch++;
    } else {
        counter++;
        guessarray[counter] = w;
        solutionarray[counter] = solution1;
    }
    
    if (x == solution2) {
        perfectmatch++;
    } else {
        counter++;
        guessarray[counter] = x;
        solutionarray[counter] = solution2;
    }
    
    if (y == solution3) {
        perfectmatch++;
    } else {
        counter++;
        guessarray[counter] = y;
        solutionarray[counter] = solution3;
    }
    
    
    if (z == solution4) {
        perfectmatch++;
    } else {
        counter++;
        guessarray[counter] = z;
        solutionarray[counter] = solution4;
    }
    

// Calculate the number of Misplaced Match. 
    int misplacedmatch = 0;
    counter++; 
    for (int i = 0; i < counter; i++) {
        for (int j = 0; j < counter; j++) {
            if (guessarray[i] == solutionarray[j]) {
                misplacedmatch++;
                guessarray[i] = 0;
                solutionarray[j] = 0;
		break;
            }
        }
    }
    printf("With guess %d, you got %d perfect matches and %d misplaced matches.\n",
 guess_number, perfectmatch, misplacedmatch);
    guess_number++;
    return 1;
}


