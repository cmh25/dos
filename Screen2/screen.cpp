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

void CScreen::DrawLine(short x1,short y1,short x2,short y2)
{         
	if(m_Current_page)
    {
        Line(x1,y1+144,x2,y2+144,m_Color);
        return;   
    }
    else
    {
        Line(x1,y1+480,x2,y2+480,m_Color);
        return;
    }
}

void CScreen::DrawCircle(short xcenter,short ycenter,short radius)
{
    if(m_Current_page)
    {  
        Circle(xcenter,ycenter+144,radius,m_Color);
        return; 
    } 
    else
    { 
        Circle(xcenter,ycenter+480,radius,m_Color);
        return;
    }
}

void CScreen::DrawEllipse(short xcenter,short ycenter,short xrad,short yrad)
{
    if(m_Current_page)
    { 
        Ellipse(xcenter,ycenter+144,xrad,yrad,m_Color);
        return;  
    } 
    else
    {  
        Ellipse(xcenter,ycenter+480,xrad,yrad,m_Color);
        return;
    }
}

void CScreen::DrawPixel(short x,short y)
{
    if(m_Current_page)
    {
        Pixel(x,y+144,m_Color);
        return;   
    } 
    else
    {
        Pixel(x,y+480,m_Color); 
        return;
    }
}

void CScreen::DrawPutChar(short x,short y,short character)
{
    if(m_Current_page)
    {                    
        PutChar(x,y+144,character,m_Color);
        return;    
    } 
    else
    {                       
        PutChar(x,y+480,character,m_Color); 
        return;  
    }
}

void CScreen::FillSplitScreen()
{
  
    Fill(0,0x2d00,m_Color);
}  

void CScreen::FillPage0()
{   
 
    Fill(0x2d00,0x6900,m_Color);
}

void CScreen::FillPage1()
{   
  
    Fill(0x9600,0x6900,m_Color);
} 

void CScreen::FillAll()
{
 
    Fill(0,0xffff,m_Color);
}

void CScreen::DrawTriangle(short x1,short y1,short x2,short y2,short x3,short y3)
{  
	//void Fpoly(short color,short count,short* line_list_ptr);  
	//Fpoly proc far c public,color:byte,count:word,line_list_ptr:dword,
	//		vertex:vararg
	short* pline_list=new short[3000];
	if(m_Current_page)  
	{
		Fpoly(m_Color,3,pline_list,x1,y1+144,x2,y2+144,x3,y3+144);   
		delete pline_list;
		return;
	}     
	else  
	{ 
	    Fpoly(m_Color,3,pline_list,x1,y1+480,x2,y2+480,x3,y3+480);  
	    delete pline_list;
	    return;
	}
}    

void CScreen::SetColor(short color)
{
	m_Color=color;
}   
