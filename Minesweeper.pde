import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER,CENTER);
  
  // make the manager
  Interactive.make( this );
  
  //your code to initialize buttons goes here
  for(int i = 0; i < NUM_ROWS; i++){
    for(int j = 0; j < NUM_COLS; j++){
      buttons[i][j] = new MSButton(i, j);
    }
  }
}
public void setMines(int n, int r, int c)
{
  if(n == 0 || mines.size() == NUM_ROWS*NUM_COLS) return;
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  MSButton mine = buttons[row][col];
  if((row == r && col == c) || mines.contains(mine)){
    setMines(n, r, c);
  }
  else{
    mines.add(mine);
    setMines(n-1, r, c);
  }
}

public void draw ()
{
  background( 0 );
  if(isWon() == true){
    displayWinningMessage();
  }
}
public boolean isWon()
{
  if(mines.size() == 0) return false;
  for(int i = 0; i < mines.size(); i++){
    if(!mines.get(i).isFlagged()){
      return false;
    }
  }
  return true;
}
public void displayLosingMessage()
{
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("Lose");
}
public void displayWinningMessage()
{
  buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("Win");
}
public boolean isValid(int r, int c)
{
  return r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int i = -1; i <= 1; i++){
    for(int j = -1; j <= 1; j++){
      if((i != 0 || j != 0) && isValid(row+i, col+j)){
        if(mines.contains(buttons[row+i][col+j])){
          numMines++;
        }
      }
    }
  }
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x,y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  
  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  
  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if(mines.size() == 0){
      setMines(NUM_ROWS*NUM_COLS/8, myRow, myCol);
    }
    if(mouseButton == RIGHT){
      flagged = (flagged)? false:true;
      if(flagged) clicked = false;
    }
    else if(mines.contains(this)){
      displayLosingMessage();
    }
    else if(countMines(myRow, myCol) > 0){
      setLabel(countMines(myRow, myCol));
    }
    else{
      for(int i = -1; i <= 1; i++){
        for(int j = -1; j <= 1; j++){
          if((i != 0 || j != 0) && isValid(myRow+i, myCol+j)){
            if(!buttons[myRow+i][myCol+j].isClicked()){
              buttons[myRow+i][myCol+j].mousePressed();
            }
          }
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if( clicked && mines.contains(this) ) 
      fill(255,0,0);
    else if(clicked)
      fill( 200 );
    else 
      fill( 100 );
  
    rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  }
}
