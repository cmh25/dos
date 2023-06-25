//triangle.h  

#ifndef TRIANGLE_H
#define TRIANGLE_H

#include "screen.h"

class CTriangle
{
	public:
		CTriangle(double x1,double y1,double x2,double y2,
				  double x3,double y3,short color,CScreen* pscreen);
		
	private:
		short m_x1;
		short m_y1;
		short m_x2;
		short m_y2;
		short m_x3;
		short m_y3; 
		
		double m_xx1;
		double m_yy1;
		double m_xx2;
		double m_yy2;
		double m_xx3;
		double m_yy3;
		
		double m_xxx1;
		double m_yyy1;
		double m_xxx2;
		double m_yyy2;
		double m_xxx3;
		double m_yyy3;
		
		short m_Color;
		
		CScreen* m_pScreen;
		
	public:
		void Show();
		void Move(short x,short y);
		void Rotate(short x,short y,double degrees);
};

#endif;