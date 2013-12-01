module( "draw", package.seeall )

--[[---------------------------------------------------------
Name: draw.NewTicker( x, y, delay )
Desc: Creates a new ticker element. Draw using draw.TickerText
Warning!  Do not call this every frame!  This is for draw.TickerText management.
-----------------------------------------------------------]]
function NewTicker( x, y, delay )
	return {
		dir = 1,
		delay = CurTime() + ( delay or 0 ),
		origin = x or 4,
		x = x or 4,
		y = y or 2
	}
end

--[[---------------------------------------------------------
Name: draw.TickerText( text, font, color, ticker, width, speed, delay )
Desc: Draws a marquee like text in a specified width.
Usage:
local ticker = draw.NewTicker( 10, 10 )
draw.TickerText( "ticker!", "font", color_white, ticker, 150, 10, 2 )
-----------------------------------------------------------]]
function TickerText( text, font, color, ticker, width, speed, delay )
	color = color or Color( 255, 255, 255, 255 )

	surface.SetFont( font )
	surface.SetTextColor( color.r, color.g, color.b, color.a )

	local w, h = surface.GetTextSize( text )

	if w > width then
		if ticker.delay < CurTime() then
			if ticker.dir == 1 then //Right
				local pos = width - w - 2

				if ticker.x ~= pos then
					ticker.x = math.Approach( ticker.x, pos, FrameTime() * ( speed or 10 ) )
				else
					ticker.dir = 0
					ticker.delay = CurTime() + delay
				end
			else //Left
				local pos = ticker.origin

				if ticker.x ~= pos then
					ticker.x = math.Approach( ticker.x, pos, FrameTime() * ( speed or 10 ) )
				else
					ticker.dir = 1
					ticker.delay = CurTime() + delay
				end
			end
		end
	end

	surface.SetTextPos( ticker.x, ticker.y )
	surface.DrawText( text )

	return ticker
end