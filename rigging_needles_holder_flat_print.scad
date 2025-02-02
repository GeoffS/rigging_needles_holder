include <..\OpenSCAD_Lib\MakeInclude.scad>
include <..\OpenSCAD_Lib\chamferedCylinders.scad>

firstLayerHeight = 0.3;
layerHeight = 0.2;
perimeterWidth = 0.42;

magnetRecessDia = 10 + 0.3;
magnetRecessZ = 2 + 0.1;

intX = 90;
intY = magnetRecessDia;
intZ = 5;

topX = 35;

slopeEndX = topX + 10;
slopEndX = slopeEndX + 20;

extraZlip = 4*layerHeight;

topBotZ = magnetRecessZ + extraZlip;

extDia = 6;
extCZ = 2; //topBotZ - extraZlip;
ed2 = extDia/2;

extZ = intZ + 2*topBotZ;
extZlow = 2*extCZ + extraZlip + 4*layerHeight;

c1  = [           ed2, intY/2+ed2, 0];
c2  = [slopeEndX+ed2, intY/2+ed2, 0];
c2a = [  slopEndX+ed2, intY/2+ed2, 0];
c3  = [      intX+ed2, intY/2+ed2, 0];
c4  = [      topX-ed2, intY/2+ed2, 0];

module itemModule()
{
	difference()
	{
		union()
		{
			// Long sides, full-height:
			doubleY() hull()
			{
				corner(c1);
				corner(c2);
			}
            
            // Long sides tapering:
			doubleY() hull()
			{
				corner(c2);
				corner(c2a, z=extZlow);
			}
            
            // Long sides tapering:
			doubleY() hull()
			{
				corner(c2a, z=extZlow);
                corner(c3, z=extZlow);
			}

			// Closed end:
			hull()
			{
				doubleY() corner(c1);
			}

			// Bottom:
			difference()
			{
				hull()
				{
					doubleY()
					{
						corner(c1);
						corner(c3);
					}
				}
				tcu([-10, -200, topBotZ], 400);
			}

			// Top::
			difference()
			{
				hull()
				{
					doubleY()
					{
						corner(c1);
						corner(c4);
					}
				}
				tcu([-10, -200, -400 + extZ - topBotZ], 400);
			}
		}

		// Magnet recesses:
		// Closed end:
		tcy([extDia+magnetRecessDia/2+5, 0, -10+topBotZ-2*layerHeight], d=magnetRecessDia, h=10);

		// Open end:
        recess1X = c4.x + extDia/2 + magnetRecessDia/2;
        recessDX = 24;
		for(x=[recess1X, recess1X+recessDX, recess1X+2*recessDX])
		{
			tcy([x, 0, topBotZ - magnetRecessZ], d=magnetRecessDia, h=10);
		}

        // Interior extension at closed end:
        tcu([4, -intY/2, topBotZ], [intX, intY, intZ]);
	}

    // Interior chamfers:
    doubleY() difference()
    {
        x0 = extCZ;
        x = topX - x0;
        yz = 5;
        translate([x0, intY/2, intZ+topBotZ]) rotate([45,0,0]) tcu([0, -yz/2, -yz/2], [x, yz, yz]);
        tcu([-10, -200, intZ+topBotZ], 400);
    }
}

module corner(center, z=extZ)
{
	translate(center) simpleChamferedCylinderDoubleEnded(d=extDia, h=z, cz=extCZ);
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
