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

topX = 30;

topBotZ = magnetRecessZ + 2*perimeterWidth;

extZ = intZ + 2*topBotZ;

extDia = 10;
extCZ = topBotZ - perimeterWidth;
ed2 = extDia/2;

c1 = [     ed2, intY/2+ed2, 0];
c2 = [intX+ed2, intY/2+ed2, 0];
c3 = [topX+ed2, intY/2+ed2, 0];

module itemModule()
{
	difference()
	{
		union()
		{
			// Long sides:
			doubleY() hull()
			{
				corner(c1);
				corner(c2);
			}

			// Closed edn:
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
						corner(c2);
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
						corner(c3);
					}
				}
				tcu([-10, -200, -400 + extZ - topBotZ], 400);
			}
		}

		// Magnet recesses:
		// Closed end:
		tcy([extDia+magnetRecessDia/2+5, 0, -10+topBotZ-perimeterWidth], d=magnetRecessDia, h=10);
		// Open end:
		for(x=[50, 70, 90])
		{
			tcy([x, 0, topBotZ - magnetRecessZ], d=magnetRecessDia, h=10);
		}
	}
}

module corner(center)
{
	translate(center) rotate([0,0,22.5]) simpleChamferedCylinderDoubleEnded(d=extDia, h=extZ, cz=extCZ, $fn=8);
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	rotate([0,-90,0]) itemModule();
}
