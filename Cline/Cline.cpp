//Cline.cpp
//implementation of CLine class

#include "Cline.h"

CLine::CLine(short x1,short y1,short x2,short y2,short color)
{
    m_x1=x1;
    m_y1=y1;
    m_x2=x2;
    m_y2=y2;
    m_color=color;
}

void CLine::Draw()
{
    Line(m_x1,m_y1,m_x2,m_y2,m_color);
}   

void CLine::Sweep(short ysweepfactor,short xsweepfactor)
{
    for(short y=ysweepfactor;y>0;y--)
    {  
        m_y2++;
        Draw();
    }
    for(short x=xsweepfactor;x>0;x--)
    {   
        m_x2--;
        Draw();
    }
}