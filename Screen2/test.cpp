//test.cpp

#include "triangle.h" 
//#include "screen.h"
#include <stdio.h> 
#include <conio.h> 
#include <math.h>   

CScreen* pscreen=new CScreen;
                                  
int main()
{ 
	pscreen->SetColor(4);        
	//pscreen->FillSplitScreen();
	
	short xr[15];
	short yr[15]; 
	int j=0;    
	
	CTriangle* pbtri[15];
	CTriangle* pgtri[15]; 
	CTriangle* prtri[15];
	
	for(int y=100;y<=300;y+=100)
	{
		for(int x=100;x<=500;x+=100)
		{  
			xr[j]=x;
			yr[j]=y-30;
			pbtri[j]=new CTriangle(x,y-30,x-30,y+27,x+30,y+27,1,pscreen);
			pgtri[j]=new CTriangle(x,y-30,x-30,y+27,x+30,y+27,2,pscreen);       
			prtri[j]=new CTriangle(x,y-30,x-30,y+27,x+30,y+27,4,pscreen);
			j++;	
		}
	}
                  
	getchar();                  
                  
	while(!kbhit())
	{
		for(j=0;j<15;j++)
		{
			pbtri[j]->Show();
			pbtri[j]->Rotate(xr[j],yr[j],3);
			pgtri[j]->Show();
			pgtri[j]->Rotate(xr[j],yr[j],2);
			prtri[j]->Show();
			prtri[j]->Rotate(xr[j],yr[j],1);	
		}	
		pscreen->Swap();
	}
	
	getchar();
	delete pscreen;
	return 0;
}