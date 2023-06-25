//triangle.cpp
             
#include "triangle.h"
#include <math.h> 

CTriangle::CTriangle(double x1,double y1,double x2,double y2,
					 double x3,double y3,short color,CScreen* pscreen)
{
	m_xx1=m_xxx1=x1;
	m_yy1=m_yyy1=y1; 
	m_xx2=m_xxx2=x2;
	m_yy2=m_yyy2=y2; 
	m_xx3=m_xxx3=x3;
	m_yy3=m_yyy3=y3;
	
	m_x1=int(x1);
	m_y1=int(y1); 
	m_x2=int(x2);
	m_y2=int(y2);
	m_x3=int(x3);
	m_y3=int(y3);
	
	m_Color=color;
	
	m_pScreen=pscreen;
} 
	
void CTriangle::Show()
{       
	m_pScreen->SetColor(m_Color);
	m_pScreen->DrawTriangle(m_x1,m_y1,m_x2,m_y2,m_x3,m_y3);		
}
	
void CTriangle::Move(short x,short y)
{      
	m_x1+=x;
	m_y1+=y;
	m_x2+=x;
	m_y2+=y;
	m_x3+=x;
	m_y3+=y;
	m_xx1+=x;
	m_yy1+=y;
	m_xx2+=x;
	m_yy2+=y;
	m_xx3+=x;
	m_yy3+=y;
	m_xxx1+=x;
	m_yyy1+=y;
	m_xxx2+=x;
	m_yyy2+=y;
	m_xxx3+=x;
	m_yyy3+=y;
}
	
void CTriangle::Rotate(short xr,short yr,double degrees)
{                                           
		degrees*=3.14159/180;
		
	    m_xxx1 = xr + (m_xx1-xr)*cos(degrees) - (m_yy1-yr)*sin(degrees);
		m_yyy1 = yr + (m_xx1-xr)*sin(degrees) + (m_yy1-yr)*cos(degrees);  
		m_xxx2 = xr + (m_xx2-xr)*cos(degrees) - (m_yy2-yr)*sin(degrees);
		m_yyy2 = yr + (m_xx2-xr)*sin(degrees) + (m_yy2-yr)*cos(degrees);
		m_xxx3 = xr + (m_xx3-xr)*cos(degrees) - (m_yy3-yr)*sin(degrees);
		m_yyy3 = yr + (m_xx3-xr)*sin(degrees) + (m_yy3-yr)*cos(degrees);
		
		m_xx1=m_xxx1;
		m_yy1=m_yyy1;  
		m_xx2=m_xxx2;
		m_yy2=m_yyy2;
		m_xx3=m_xxx3;
		m_yy3=m_yyy3; 
		
		m_x1=int(m_xx1);
		m_y1=int(m_yy1);
		m_x2=int(m_xx2);
		m_y2=int(m_yy2);
		m_x3=int(m_xx3);
		m_y3=int(m_yy3);
}

