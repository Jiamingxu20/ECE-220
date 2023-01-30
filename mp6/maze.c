#include <stdio.h>
#include <stdlib.h>
#include "maze.h"


/* intro paragraph: this program is a maze solver using recrusion. 
 * this program has 4 functions: createMaze, destroyMaze, printMaze, and solveMazeDFS.
 */



/*
 * createMaze -- Creates and fills a maze structure from the given file
 * INPUTS:       fileName - character array containing the name of the maze file
 * OUTPUTS:      None 
 * RETURN:       A filled maze structure that represents the contents of the input file
 * SIDE EFFECTS: None
 */
maze_t * createMaze(char * fileName)
{   
    FILE *in_file;
    int i, j, r, c;
    maze_t *themaze = (maze_t *)malloc(sizeof(maze_t));
    in_file = fopen(fileName,"r");
	fscanf(in_file, "%d %d", &c, &r);
    fgetc(in_file);

    // record the value of width and height
    themaze->width = c;
    themaze->height = r;

    // create cells
    themaze->cells = (char **)malloc(r*sizeof(char*));
    for(i=0;i<r;i++){
        themaze->cells[i] = (char*)malloc(c*sizeof(char));
    }

    // initiate the value of cells
	for(i=0;i<r;i++){
		for(j=0;j<c;j++){
			fscanf(in_file, "%c", &(themaze->cells[i][j]));
		}
        fgetc(in_file);
	}
    // check and record the location of START and END
    for(i=0;i<r;i++){
		for(j=0;j<c;j++){
			if(themaze->cells[i][j] == START){
                themaze->startRow = i;
                themaze->startColumn = j;
            } else if(themaze->cells[i][j] == END){
                themaze->endRow = i;
                themaze->endColumn = j;
            }
		}
	}
    fclose(in_file);
    return themaze;
}



/*
 * destroyMaze -- Frees all memory associated with the maze structure, including the structure itself
 * INPUTS:        maze -- pointer to maze structure that contains all necessary information 
 * OUTPUTS:       None
 * RETURN:        None
 * SIDE EFFECTS:  All memory that has been allocated for the maze is freed
 */
void destroyMaze(maze_t * maze)
{
    int i;
    // free every array in cells
    for(i=0;i<maze->height;i++){
        free(maze->cells[i]);
    }
    free(maze->cells);

    // free maze
    free(maze);
}

/*
 * printMaze --  Prints out the maze in a human readable format (should look like examples)
 * INPUTS:       maze -- pointer to maze structure that contains all necessary information 
 *               width -- width of the maze
 *               height -- height of the maze
 * OUTPUTS:      None
 * RETURN:       None
 * SIDE EFFECTS: Prints the maze to the console
 */
void printMaze(maze_t * maze)
{
    int i, j;
    // print the maze
    for(i=0;i<maze->height;i++){
        for(j=0;j<maze->width;j++){
            printf("%c", (maze->cells[i][j]));
        }
        printf("\n");
    }
}

/*
 * solveMazeDFS -- recursively solves the maze using depth first search,
 * INPUTS:               maze -- pointer to maze structure with all necessary maze information
 *                       col -- the column of the cell currently beinging visited within the maze
 *                       row -- the row of the cell currently being visited within the maze
 * OUTPUTS:              None
 * RETURNS:              0 if the maze is unsolvable, 1 if it is solved
 * SIDE EFFECTS:         Marks maze cells as visited or part of the solution path
 */ 
int solveMazeDFS(maze_t * maze, int col, int row)
{   
    // check for boundary
    if(col < 0 || row < 0 || col >= maze->width || row >= maze->height){
        return 0;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        } 
    // check for WALL, PATH, and VISITED
    } else if (maze->cells[row][col] == WALL || 
    maze->cells[row][col] == PATH || maze->cells[row][col] == VISITED){
        return 0;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        } 
    // check for END
    } else if (maze->cells[row][col] == END){
        return 1;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        } 
    }
    // set current location as PATH
    maze->cells[row][col] = PATH;
    if (row == maze->startRow && col == maze->startColumn){
        maze->cells[row][col] = START;
    } 

    // check the surroundings 
    if(solveMazeDFS(maze, col+1, row) == 1){
        return 1;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        } 
    }
    if (solveMazeDFS(maze, col, row+1) == 1){
        return 1;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        }  
    }
    if (solveMazeDFS(maze, col-1, row) == 1){
        return 1;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        }  
    }
    if (solveMazeDFS(maze, col, row-1) == 1){
        return 1;
        if (row == maze->startRow && col == maze->startColumn){
            maze->cells[row][col] = START;
        }  
    }
    // mark as VISITED
    maze->cells[row][col] = VISITED;
    if (row == maze->startRow && col == maze->startColumn){
        maze->cells[row][col] = START;
    } 

    return 0;
}
