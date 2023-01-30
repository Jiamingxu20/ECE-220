#include <stdio.h>
#include <stdlib.h>

/* Intro: this program will take a counter and an adder to 
   compute a row of a Pascal's triangle through a while loop */


int main(void)
{
  int row;

  printf("Enter a row index: ");
  scanf("%d",&row);

  /* copy value of row into x */
  long int x = row;

  /* initate counter as row + 1 */
  long int counter = row + 1;
 
  /* initate num and adder */
  long int num = 1;
  long int adder = 1;

  /* this while loop will print each number and and space */

  while(counter>0){
      printf("%ld",num);
      printf(" ");
      num = num*x;
      num = num/adder;
      adder++;
      counter--;
      x--;
  }
 
 
  return 0;
}
