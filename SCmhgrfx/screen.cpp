//screen.cpp
            
#include "screen.h"

CScreen::CScreen()
{
    m_Current_page=0;
    m_Color=0;
    
    SetMode(0x103);
    SetStartAddr(0);   
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
        SetStartAddr(0);
        Fill(0,600,0);
        return;
    }
    else
    {   
    	m_Current_page=1;
        SetStartAddr(600); 
        Fill(0,0,0);
        return;
    }
}

void CScreen::DrawLine(short x1,short y1,short x2,short y2)
{         
	if(m_Current_page)
    {
        Line(x1,y1,x2,y2,m_Color);
        return;   
    }
    else
    {
        Line(x1,y1+600,x2,y2+600,m_Color);
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

void CScreen::DrawTriangle(short x1,short y1,short x2,short y2,short x3,short y3)
{
	if(m_Current_page)  
	{
		Triangle(x1,y1,x2,y2,x3,y3,m_Color);
		return;
	}     
	else  
	{ 
	    Triangle(x1,y1+600,x2,y2+600,x3,y3+600,m_Color);
	    return;
	}
}    

void CScreen::SetColor(short color)
{
	m_Color=color;
}   
