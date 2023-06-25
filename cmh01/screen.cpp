//screen.cpp
            
#include "screen.h"

CScreen::CScreen()
{
    m_Current_page=0;
    m_Color=0;
    
    SetMode(18);
    SetSplitScreen(335);
    SetStartAddr(0x2d);   
}

CScreen::~CScreen()
{
    SetMode(3);
}

void CScreen::Swap()
{   
    if(m_Current_page)
    {    
    	m_Current_page=0;
        SetStartAddr(0x2d);
        Fill(0x9600,0x6900,0);
        return;
    }
    else
    {   
    	m_Current_page=1;
        SetStartAddr(0x96); 
        Fill(0x2d00,0x6900,0);
        return;
    }
}

void CScreen::DrawLine(short x1,short y1,short x2,short y2,short color)
{         
	if(m_Current_page)
    {
        Line(x1,y1+144,x2,y2+144,color);
        return;   
    }
    else
    {
        Line(x1,y1+480,x2,y2+480,color);
        return;
    }
}

void CScreen::DrawCircle(short xcenter,short ycenter,short radius,short color)
{
    if(m_Current_page)
    {  
        Circle(xcenter,ycenter+144,radius,color);
        return; 
    } 
    else
    { 
        Circle(xcenter,ycenter+480,radius,color);
        return;
    }
}

void CScreen::DrawEllipse(short xcenter,short ycenter,short xrad,short yrad,short color)
{
    if(m_Current_page)
    { 
        Ellipse(xcenter,ycenter+144,xrad,yrad,color);
        return;  
    } 
    else
    {  
        Ellipse(xcenter,ycenter+480,xrad,yrad,color);
        return;
    }
}

void CScreen::DrawPixel(short x,short y,short color)
{
    if(m_Current_page)
    {
        Pixel(x,y+144,color);
        return;   
    } 
    else
    {
        Pixel(x,y+480,color); 
        return;
    }
}

void CScreen::DrawPutChar(short x,short y,short character,short color)
{
    if(m_Current_page)
    {                    
        PutChar(x,y+144,character,color);
        return;    
    } 
    else
    {                       
        PutChar(x,y+480,character,color); 
        return;  
    }
}

void CScreen::FillSplitScreen(short color)
{
  
    Fill(0,0x2d00,color);
}  

void CScreen::FillPage0(short color)
{   
 
    Fill(0x2d00,0x6900,color);
}

void CScreen::FillPage1(short color)
{   
  
    Fill(0x9600,0x6900,color);
} 

void CScreen::FillAll(short color)
{
 
    Fill(0,0xffff,color);
}

void CScreen::DrawTriangle(short x1,short y1,short x2,short y2,short x3,short y3,short color)
{  
	//void Fpoly(short color,short count,short* line_list_ptr);  
	//Fpoly proc far c public,color:byte,count:word,line_list_ptr:dword,
	//		vertex:vararg
	short* pline_list=new short[3000];
	if(m_Current_page)  
	{
		Fpoly(color,3,pline_list,x1,y1+144,x2,y2+144,x3,y3+144);   
		delete pline_list;
		return;
	}     
	else  
	{ 
	    Fpoly(color,3,pline_list,x1,y1+480,x2,y2+480,x3,y3+480);  
	    delete pline_list;
	    return;
	}
}    

void CScreen::SetColor(short color)
{
	m_Color=color;
}   
