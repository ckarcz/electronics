// input values
panelU = 4;
panelHp = 6;
panelThickness = 4;
railEdgeHeight = 1.7;
railTotalHeight = 10;
holeCount = 4;
holeWidth = 6;
holeDiameter = 3.2;
ignoreMountHoles = false;

// reference values
hp = 5.08;
u = 44.45;

// calculated values
panelUHeight = panelU * u;
totalRailEdgeHeight = railEdgeHeight * 2;
panelActualHeight = panelUHeight - totalRailEdgeHeight;
panelActualWidth = panelHp * hp;
pcbMaxHeight = panelActualHeight - railTotalHeight;
mountHoleRad = holeDiameter / 2;
holeWidthCubeWidth = holeWidth - holeDiameter;
offsetToMountHoleCenterY = (railTotalHeight / 2) - railEdgeHeight;
offsetToMountHoleCenterX = hp - holeWidthCubeWidth / 2;

echo("-------------------------------");

echo("INPUTS:");
echo("panelU", panelU);
echo("panelHp", panelHp);
echo("panelThickness", panelThickness);
echo("railEdgeHeight", railEdgeHeight);
echo("railTotalHeight", railTotalHeight);
if (!ignoreMountHoles)
{
    echo("holeCount", holeCount);
    echo("holeWidth", holeWidth);
    echo("holeDiameter", holeDiameter);
}

echo("-------------------------------");

echo("REFERENCE:");
echo("hp", hp);
echo("u", u);


echo("-------------------------------");

echo("CALCULATED:");
echo("panelUHeight", panelUHeight);
echo("panelActualHeight", panelActualHeight);
echo("panelActualWidth", panelActualWidth);
echo("pcbMaxHeight", pcbMaxHeight);


echo("-------------------------------");

module eurorackPanel()
{
    difference()
    {
        cube([panelActualWidth, panelActualHeight, panelThickness]);
        
        if(!ignoreMountHoles)
        {
            eurorackMountHoles(holeCount, holeWidth);
        }
    }
}

module eurorackMountHoles(holes, holeWidth)
{
    holes = holes - holes % 2;
    eurorackMountHolesTopRow(holeWidth, holes / 2);
    eurorackMountHolesBottomRow(holeWidth, holes / 2);
}

module eurorackMountHolesTopRow(holeWidth, holes)
{
    
    translate([hp, panelActualHeight - offsetToMountHoleCenterY, 0])
    {
        eurorackMountHole(holeWidth);
    }
    if(holes > 1)
    {
        translate([panelActualWidth - holeWidthCubeWidth - hp, panelActualHeight - offsetToMountHoleCenterY, 0])
        {
            eurorackMountHole(holeWidth);
        }
    }
    if(holes > 2)
    {
        holeDivs = panelActualWidth / (holes - 1);
        for (i = [1 : holes - 2])
        {
            translate([holeDivs * i, panelActualHeight - offsetToMountHoleCenterY , 0])
            {
                eurorackMountHole(holeWidth);
            }
        }
    }
}

module eurorackMountHolesBottomRow(holeWidth, holes)
{
    
    translate([panelActualWidth - holeWidthCubeWidth - hp, offsetToMountHoleCenterY, 0])
    {
        eurorackMountHole(holeWidth);
    }
    if(holes > 1)
    {
        translate([hp, offsetToMountHoleCenterY, 0])
        {
            eurorackMountHole(holeWidth);
        }
    }
    if(holes > 2)
    {
        holeDivs = panelActualWidth / (holes - 1);
        for (i = [1 : holes - 2])
        {
            translate([holeDivs * i, offsetToMountHoleCenterY, 0])
            {
                eurorackMountHole(holeWidth);
            }
        }
    }
}

module eurorackMountHole(holeWidth)
{
    mountHoleDepth = panelThickness + 2;
    
    if(holeWidthCubeWidth < 0)
    {
        holeWidthCubeWidth = 0;
    }
    translate([0, 0, -1])
    {
        union()
        {
            cylinder(r = mountHoleRad, h = mountHoleDepth, $fn = 20);
            translate([0, -mountHoleRad, 0])
            {
                cube([holeWidthCubeWidth, holeDiameter, mountHoleDepth]);
            }
            translate([holeWidthCubeWidth, 0, 0])
            {
                cylinder(r = mountHoleRad, h = mountHoleDepth, $fn = 20);
            }
        }
    }
}

eurorackPanel();