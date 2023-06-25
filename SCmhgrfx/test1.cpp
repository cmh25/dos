//test1.cpp  

#include "scmhgrfx.h" 
#include <conio.h>

int main()
{            
	SetMode(0x103); 
	SetStartAddr(600);
	getch();
	///////////////////////////////////////////////
	Line(0,600,799,600,4);
	getch();
  	Fill(0,600,1); 
	getch();
  	Line(0,0,799,1199,4);  
	getch();
  	SetStartAddr(1000);
	getch();
  	SetStartAddr(0); 
  	Fill(0,0,4);   
  	SetStartAddr(600);                                           
	///////////////////////////////////////////////	                                               
	getch();
	SetMode(3);
	return 0;
}