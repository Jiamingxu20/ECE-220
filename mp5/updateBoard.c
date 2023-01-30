/*
 * intro paragraph: in this week's mp, i created three functions
 * countLiveNeighbor, updateBoard, and aliveStable. Together with other
 * code, they implement the Game of Life, a cellular automaton.
 */


/*
 * countLiveNeighbor
 * Inputs:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * row: the row of the cell that needs to count alive neighbors.
 * col: the col of the cell that needs to count alive neighbors.
 * Output:
 * return the number of alive neighbors. There are at most eight neighbors.
 * Pay attention for the edge and corner cells, they have less neighbors.
 */

int countLiveNeighbor(int* board, int boardRowSize, int boardColSize, int row, int col){
  /*
     A B C 
     D * E
     F G H 
  
  A = board[row * boardColSize + col - 1 - boardColSize]; 
  B = board[row * boardColSize + col - boardColSize];
  C = board[row * boardColSize + col + 1 - boardColSize]; 
  D = board[row * boardColSize + col - 1]; 
  E = board[row * boardColSize + col + 1]; 
  F = board[row * boardColSize + col - 1 + boardColSize]; 	
  G = board[row * boardColSize + col + boardColSize]; 
  H = board[row * boardColSize + col + 1 + boardColSize];
  */	
  
  int count = 0;
	
  // at the right, bottom corner 
  if (row == boardRowSize - 1 && col == boardColSize - 1) {
  // count = A + B + D;
      count += board[row * boardColSize + col - 1 - boardColSize]; 
      count += board[row * boardColSize + col - boardColSize];
      count += board[row * boardColSize + col - 1]; 
      return count;
  }
  // at the right, high corner 
  if (row == 0 && col == boardColSize - 1) {
      count += board[row * boardColSize + col - 1]; 
      count += board[row * boardColSize + col - 1 + boardColSize];
      count += board[row * boardColSize + col + boardColSize];
      return count;
  }
  // at the left, high corner 
  if (row == 0 && col == 0) {
  //  count = E + G + H; 
      count += board[row * boardColSize + col + 1]; 
      count += board[row * boardColSize + col + boardColSize]; 
      count += board[row * boardColSize + col + 1 + boardColSize];
      return count; 	
  }
  // at the left, lower corner 
  if (row == boardRowSize - 1 && col == 0) {
  //  count = B + C + E;
      count += board[row * boardColSize + col - boardColSize];
      count += board[row * boardColSize + col + 1 - boardColSize]; 
      count += board[row * boardColSize + col + 1];
      return count; 
  }
  // at top wall
  if (row == 0) {
      //count = D + E + F + G + H;
      count += board[row * boardColSize + col - 1];
      count += board[row * boardColSize + col + 1]; 
      count += board[row * boardColSize + col - 1 + boardColSize]; 
      count += board[row * boardColSize + col + boardColSize]; 
      count += board[row * boardColSize + col + 1 + boardColSize];
      return count; 
  }
  // at bottom wall
  if (row == boardRowSize - 1) {
      //count = A + B + C + D + E;
      count += board[row * boardColSize + col - 1 - boardColSize]; 
      count += board[row * boardColSize + col - boardColSize];
      count += board[row * boardColSize + col + 1 - boardColSize]; 
      count += board[row * boardColSize + col - 1]; 
      count += board[row * boardColSize + col + 1]; 
      return count; 
  }
  // at left wall
  if (col == 0) {
      //count = B + C + E + G + H;
      count += board[row * boardColSize + col - boardColSize];
      count += board[row * boardColSize + col + 1 - boardColSize]; 
      count += board[row * boardColSize + col + 1];
      count += board[row * boardColSize + col + boardColSize]; 
      count += board[row * boardColSize + col + 1 + boardColSize];
      return count; 
  }
  // at right wall
  if (col == boardColSize - 1) {
      //count = A + B + D + F + G;
      count += board[row * boardColSize + col - 1 - boardColSize]; 
      count += board[row * boardColSize + col - boardColSize];
      count += board[row * boardColSize + col - 1]; 
      count += board[row * boardColSize + col - 1 + boardColSize]; 
      count += board[row * boardColSize + col + boardColSize]; 
      return count; 
  }
  // at the middle 
  //count = A + B + C + D + E + F + G + H;
  count += board[row * boardColSize + col - 1 - boardColSize]; 
  count += board[row * boardColSize + col - boardColSize];
  count += board[row * boardColSize + col + 1 - boardColSize]; 
  count += board[row * boardColSize + col - 1]; 
  count += board[row * boardColSize + col + 1]; 
  count += board[row * boardColSize + col - 1 + boardColSize]; 	
  count += board[row * boardColSize + col + boardColSize]; 
  count += board[row * boardColSize + col + 1 + boardColSize];
  return count; 
}



/*
 * Update the game board to the next step.
 * Input: 
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: board is updated with new values for next step.
 */
void updateBoard(int* board, int boardRowSize, int boardColSize) {
  int r, c, a;
  int size = boardRowSize * boardColSize;
  int copy[size];
  for(a = 0; a < size; a++){
    copy[a] = board[a];
  }
  for(r = 0; r < boardRowSize; r++){
      for(c = 0; c < boardColSize; c++){
          int count = 0;
          count = countLiveNeighbor(copy, boardRowSize, boardColSize, r, c);
          if (board[r * boardColSize + c] == 1) {
              if (count != 2 && count != 3) {
                  board[r * boardColSize + c] = 0;
              } 
          } else if (board[r * boardColSize + c] == 0) {
              if (count == 3) {
                  board[r * boardColSize + c] = 1;
              } 
          }
      } 
  }
}



/*
 * aliveStable
 * Checks if the alive cells stay the same for next step
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: return 1 if the alive cells for next step is exactly the same with 
 * current step or there is no alive cells at all.
 * return 0 if the alive cells change for the next step.
 */ 
int aliveStable(int* board, int boardRowSize, int boardColSize){
  int i, j;
  int size = boardRowSize * boardColSize;
  int copy[size];
  for(j = 0; j < size; j++){
    copy[j] = board[j];
  }
  updateBoard(copy, boardRowSize, boardColSize);
  for(i = 0; i < size; i++){
      if (board[i] != copy[i]) {
          return 0;
      }
   }
  return 1; 
}

				
				
			

