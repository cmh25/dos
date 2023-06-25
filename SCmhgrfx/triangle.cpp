////////////////////////////////////////////////////////////////////////////
//                          triangle.cpp
//                            12-8-99
//
//	Triangle(x1,y1,x2,y2,x3,y3,color) - draws a filled triangle in color.
//                                      works for svga mode 103h 800x600
//                                      256 color.
/////////////////////////////////////////////////////////////////////////////

#include <math.h>
#include "scmhgrfx.h"  
#include <stdio.h>

void scanrightedge(short* pedgelist,short x1,short y1,short x2,short y2);
void scanrightedge(short* pedgelist,short x1,short y1,short x2,short y2,short x3,short y3); 
void scanleftedge(short* pedgelist,short x1,short y1,short x2,short y2);
void scanleftedge(short* pedgelist,short x1,short y1,short x2,short y2,short x3,short y3);
void drawhlinelist(short* pleftedge,short* prightedge,short color,short hlinecount);

void Triangle(short x1,short y1,short x2,short y2,short x3,short y3,short color)
{
	//check for pixel,hline,or vline
	if((y1==y2&&y2==y3)||(x1==x2&&x2==x3))return;
	
	short rightedge[1200];
	short leftedge[1200];
	short* prightedge=rightedge;
	short* pleftedge=leftedge;   
	short topy=0;
	short botty=0; 
	short hlinecount=0; 
	
	float xx1=x1;
	float yy1=y1;
	float xx2=x2;
	float yy2=y2;
	float xx3=x3;
	float yy3=y3;
	         
	//find topy, botty, and hlinecount
	topy=y1;
	botty=y1;
    if(y2<y1)
   	{         
   		topy=y2;
   		if(y3<y2)topy=y3;
   	}  
   	else if(y3<y1)
   	{
   		topy=y3;
   		if(y2<y3)topy=y2;
   	}  
   	
   	if(y2>y1)
   	{         
   		botty=y2;
   		if(y3>y2)botty=y3;
   	}  
   	else if(y3>y1)
   	{
   		botty=y3;
   		if(y2>y3)botty=y2;
   	}
	hlinecount=botty-topy+1;
      
    //find out what kind of triangle we are drawing
    //triangle is not drawn if vertices are listed 
    //in clockwise order because this indicates the
    //triangle has rotated around until it's back is
    //facing us
    if(y1<y2) 
    {
    	if(y1<y3) 
    	{
    		if(y2<y3)//1 2 3 
    		{
    			if((x1<x3&&x1<x2)||(x1>x3&&x1>x2)) 
    			{
    				//slope test 
    				if((yy1-yy3)/(xx1-xx3)>=(yy1-yy2)/(xx1-xx2))return;   
    				if((yy1-yy3)/(xx1-xx3)<(yy1-yy2)/(xx1-xx2))
    				{
    					scanleftedge(pleftedge,x1,y1,x2,y2,x3,y3);
    					scanrightedge(prightedge,x1,y1,x3,y3);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    					return;
    				}
    			}
    			if(x1==x3) 
    			{
    				if(x2<x3)
    				{
    					scanleftedge(pleftedge,x1,y1,x2,y2,x3,y3);
    					scanrightedge(prightedge,x1,y1,x3,y3);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount);
    					return;
    				}
    				if(x2>x3)return;
    			}
    		}
    		if(y2>y3)//1 3 2 
    		{ 
    			if((x1<x2&&x1<x3)||(x1>x2&&x1>x3))
    			{ 
    				//slope test
    				if((yy1-yy3)/(xx1-xx3)>=(yy1-yy2)/(xx1-xx2))return;     
    				if((yy1-yy3)/(xx1-xx3)<(yy1-yy2)/(xx1-xx2))
    				{
    					scanleftedge(pleftedge,x1,y1,x2,y2);
    					scanrightedge(prightedge,x1,y1,x3,y3,x2,y2);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    					return;
    				}
    			}
    			if(x1==x2)	 
    			{
    				if(x3>x2)
    				{
    					scanleftedge(pleftedge,x1,y1,x2,y2);
    					scanrightedge(prightedge,x1,y1,x3,y3,x2,y2);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount);
    					return;
    				}  
    				if(x3<x2)return;
    			}
    		}
    		if(y2==y3)//1 2==3
    		{ 
    			if(x2<x3)
    			{  
    				scanleftedge(pleftedge,x1,y1,x2,y2);
    				scanrightedge(prightedge,x1,y1,x3,y3);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount);
    				return;
    			}
    			if(x3<x2)return;
    		}	
    	}
    	if(y1>y3)//3 1 2
    	{  
    		if((x3<x2&&x3<x1)||(x3>x2&&x3>x1))
    		{  
    			//slope test
    			if((yy3-yy2)/(xx3-xx2)>=(yy3-yy1)/(xx3-xx1))return;   
    			if((yy3-yy2)/(xx3-xx2)<(yy3-yy1)/(xx3-xx1))
    			{
    				scanleftedge(pleftedge,x3,y3,x1,y1,x2,y2);
    				scanrightedge(prightedge,x3,y3,x2,y2);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount);
    				return;
    			}
    		}
    		if(x3==x2)
    		{   
    			if(x1>x3)return;      
    			if(x1<x3)
    			{
    				scanleftedge(pleftedge,x3,y3,x1,y1,x2,y2);
    				scanrightedge(prightedge,x3,y3,x2,y2);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    				return;
    			}
    		}
    	}
    	if(y1==y3)//1==3 2 
    	{  
    		if(x1>x3)return;     
    		if(x1<x3)
    		{
    			scanleftedge(pleftedge,x1,y1,x2,y2);
    			scanrightedge(prightedge,x3,y3,x2,y2);
    			drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    			return;
    		}
    	}
    }
    if(y1>y2) 
    { 
    	if(y1<y3)//2 1 3
    	{  
    		if((x2<x3&&x2<x1)||(x2>x3&&x2>x1))
    		{  
    			//slope test
    			if((yy2-yy3)/(xx2-xx3)<=(yy2-yy1)/(xx2-xx1))return;
    			if((yy2-yy3)/(xx2-xx3)>(yy2-yy1)/(xx2-xx1))
    			{
    				scanleftedge(pleftedge,x2,y2,x3,y3);
    				scanrightedge(prightedge,x2,y2,x1,y1,x3,y3);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    				return;
    			}        
    			
    		}
    		if(x2==x3)
    		{       
    			if(x1<x2)return;       
    			if(x1>x2)
    			{
    				scanleftedge(pleftedge,x2,y2,x3,y3);
    				scanrightedge(prightedge,x2,y2,x1,y1,x3,y3);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount);
    				return;
    			}
    		}
    	}
    	if(y1>y3)
    	{ 
    		if(y2<y3)//2 3 1
    		{ 
    			if((x2<x1&&x2<x3)||(x2>x1&&x2>x3))
    			{   
    				//slope test
    				if((yy2-yy3)/(xx2-xx3)<=(yy2-yy1)/(xx2-xx1))return;
    				if((yy2-yy3)/(xx2-xx3)>(yy2-yy1)/(xx2-xx1)) 
    				{
    					scanleftedge(pleftedge,x2,y2,x3,y3,x1,y1);
    					scanrightedge(prightedge,x2,y2,x1,y1);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount);  
    					return;
    				}
    			}
    			if(x2==x1)
    			{     
    				if(x2<x3)return;        
    				if(x2>x3)
    				{
    					scanleftedge(pleftedge,x2,y2,x3,y3,x1,y1);
    					scanrightedge(prightedge,x2,y2,x1,y1);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount); 
    					return;
    				}
    			}  
    	    }
    		if(y2>y3)//3 2 1
    		{   
    			if((x3<x2&&x3<x1)||(x3>x2&&x3>x1))
    			{ 
    				//slope test
    				if((yy3-yy1)/(xx3-xx1)<=(yy3-yy2)/(xx3-xx2))return;
    				if((yy3-yy1)/(xx3-xx1)>(yy3-yy2)/(xx3-xx2))
    				{
    					scanleftedge(pleftedge,x3,y3,x1,y1);
    					scanrightedge(prightedge,x3,y3,x2,y2,x1,y1);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount);   
    					return;
    				}
    			}
    			if(x3==x1)
    			{       
    				if(x2<x3)return;
    				if(x2>x3)
    				{     
    					scanleftedge(pleftedge,x3,y3,x1,y1);
    					scanrightedge(prightedge,x3,y3,x2,y2,x1,y1);
    					drawhlinelist(pleftedge,prightedge,color,hlinecount);
    					return;
    				}
    			}
    		}
    		if(y2==y3)//2==3 1
    		{   
    			if(x2<x3)return;
    			if(x2>x3)
    			{
    				scanleftedge(pleftedge,x3,y3,x1,y1);
    				scanrightedge(prightedge,x2,y2,x1,y1);
    				drawhlinelist(pleftedge,prightedge,color,hlinecount);
    				return;
    			}
    		}
    	}
    	if(y1==y3)//2 1==3
    	{  
    		if(x1<x3)return;
    		if(x1>x3)
    		{    
    			scanleftedge(pleftedge,x2,y2,x3,y3);
    			scanrightedge(prightedge,x2,y2,x1,y1);
    			drawhlinelist(pleftedge,prightedge,color,hlinecount);
    			return;
    		}
    	}
    }
    if(y1==y2)  
    { 
    	if(y1<y3)//1==2 3
    	{ 
    		if(x1<x2)return;
    		if(x1>x2)
    		{    
    			scanleftedge(pleftedge,x2,y2,x3,y3);
    			scanrightedge(prightedge,x1,y1,x3,y3);
    			drawhlinelist(pleftedge,prightedge,color,hlinecount);
    			return;
    		}
    	}
    	if(y1>y3)//3 1==2
    	{   
    		if(x2<x1)return;
    		if(x2>x1)
    		{   
    			scanleftedge(pleftedge,x3,y3,x1,y1);
    			scanrightedge(prightedge,x3,y3,x2,y2);
    			drawhlinelist(pleftedge,prightedge,color,hlinecount);
    			return;
    		}
    	}
    }       
}   
     
//scan an edge with two vertices
void scanleftedge(short* pedgelist,short x1,short y1,short x2,short y2)
{  
	int dx=x2-x1;
	int dy=y2-y1;
	int steps;
	int k;
	float xIncrement;
	float yIncrement;
	float x=x1;
	float y=y1;
	short oldy=y1;
	short oldx=x1;
	
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 

	*pedgelist=x1;
	*(pedgelist+1)=y1;  

	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement;
		if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)<oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}
}
  
//scan an edge with three vertices
void scanleftedge(short* pedgelist,short x1,short y1,short x2,short y2,short x3,short y3)
{ 
	int dx=x2-x1;
	int dy=y2-y1;
	int steps;
	int k;
	float xIncrement;
	float yIncrement;
	float x=x1;
	float y=y1;  
	short oldy=y1; 
	short oldx=x1;
	
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 
	
	*pedgelist=x1;
	*(pedgelist+1)=y1; 
	
	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement;
		if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)<oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}
	
	dx=x3-x2;
	dy=y3-y2;
	x=x2;
	y=y2;
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 
	oldy=y2;
	oldx=x2;
	
	*pedgelist=x2;
	*(pedgelist+1)=y2;  
	
	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement; 
		if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)<oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}	
}   

//scan an edge with two vertices
void scanrightedge(short* pedgelist,short x1,short y1,short x2,short y2)
{  
	int dx=x2-x1;
	int dy=y2-y1;
	int steps;
	int k;
	float xIncrement;
	float yIncrement;
	float x=x1;
	float y=y1;
	short oldy=y1;  
	short oldx=x1;
	
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 

	*pedgelist=x1;
	*(pedgelist+1)=y1;  

	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement;
		if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)>oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}
}
  
//scan an edge with three vertices
void scanrightedge(short* pedgelist,short x1,short y1,short x2,short y2,short x3,short y3)
{ 
	int dx=x2-x1;
	int dy=y2-y1;
	int steps;
	int k;
	float xIncrement;
	float yIncrement;
	float x=x1;
	float y=y1;  
	short oldy=y1;
	short oldx=x1;
	
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 
	
	*pedgelist=x1;
	*(pedgelist+1)=y1; 
	
	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement;
	    if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)>oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}
	
	dx=x3-x2;
	dy=y3-y2;
	x=x2;
	y=y2;
	if(abs(dx)>abs(dy))steps=abs(dx);
	else steps=abs(dy);
	xIncrement=dx/float(steps);
	yIncrement=dy/float(steps); 
	oldy=y2;
	oldx=x2;
	
	*pedgelist=x2;
	*(pedgelist+1)=y2;  
	
	for(k=0;k<steps;k++)
	{ 
		x+=xIncrement;
		y+=yIncrement;
		if(oldy!=int(y+.5))
		{
			pedgelist+=2; 
			oldy=int(y+.5); 
			*pedgelist=(int(x+.5)); 
			*(pedgelist+1)=(int(y+.5));
		}
		if(int(x+.5)>oldx)
		{
			oldx=int(x+.5);
			*pedgelist=(int(x+.5));
		}
	}	
}

//draw hline list
void drawhlinelist(short* pleftedge,short* prightedge,short color,short hlinecount)
{ 
	for(short i=hlinecount;i>0;i--)
	{ 
		Line(*pleftedge,*(pleftedge+1),*prightedge,*(prightedge+1),color); 
		pleftedge+=2;
		prightedge+=2;
	}	
}