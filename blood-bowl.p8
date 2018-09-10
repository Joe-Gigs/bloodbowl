pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--draws
function _init()
	cy=0
	cx=0
	piece=make_actor(112, 60)
	piece.sp=2
	piece.w=2
	piece.h=2
	piece.speed=1
	piece.selected = false
	piece.box = {x1=0,y1=0,x2=7,y2=7}

	hand=make_actor(70, 50)
	hand.sp=40
	hand.w=2
	hand.h=2
	hand.speed=16

	overlapped = false

	game_objects={} --non piece 

end

function _draw()
	cls()
	
	map(screenx, screeny, cx, cy, 32, 32)
	spr(piece.sp, piece.x, piece.y, piece.w, piece.h)
	spr(hand.sp, hand.x, hand.y, hand.w, hand.h)
	for g in all(game_objects) do
		spr(g.sp, g.x, g.y, 2, 2)
	end

	print(overlapped, 80, 60, 8)
	print(piece.selected, 80, 50, 8)

end

function make_actor(x, y)
		a={}
		a.x = x
		a.y = y
		a.dx = 0
		a.dy = 0
		a.frame = 0
		a.t = 0
		a.inertia = 0.6
		a.bounce  = 1
		a.frames=2

		a.w = 0.4
		a.h = 0.4

		add(actor,a)

		return a
	end

	--not working for some reason :<
	function draw_debug()
		cpu = "cpu:"..(flr(stat(1)*100)).."%"
		mem = "mem:"..(flr((stat(0)/256)*32)).."k"

		print(cpu,40,5,7)
		print(mem,75,5,7)
	end
-->8
--updates
function _update60()
	move_camera()
	update_hand()
	check_overlap()
	update_piece()

	draw_debug()

end

function update_piece()
	select_piece()

	if piece.selected == true then
		create_cursor(piece.x, piece.y -15, 10)
	end

	for g in all(game_objects) do
		if piece.selected == false then
			del(game_objects, g)
		end
	end
end

function move_camera()
	if hand.x >= 30.8 then
		camera_x = hand.x - 30
	end

	if hand.y >= 30.8 then
		camera_y = hand.y - 30
	end
	
	camera(camera_x, camera_y)
end


function update_hand()
	if btnp(0) then
		hand.x-=hand.speed
	end
	if btnp(1) then
		hand.x+=hand.speed
	end
	if btnp(2) then
		hand.y-=hand.speed
	end
	if btnp(3) then
		hand.y+=hand.speed
	end
end

function check_overlap()
		if hand.x >= piece.x and hand.x <= piece.x + 8 and hand.y >= piece.y and hand.y <= piece.y + 8 then
			overlapped = true
		else
			overlapped = false
		end
	end

function select_piece()
	local lx = hand.x
	local ly = hand.y

	if overlapped == true and btn(4) then
		piece.selected = true
	end

	if piece.selected == true and btn(5) and overlapped == true then
		piece.selected = false
	end

	if piece.selected == true and overlapped == false then
		if btn(4) then
			create_destination_box(lx - 6, ly - 2, 8)
		end
	end
end

function create_cursor(x, y, sp)
	cursor = make_actor(x,y)
	cursor.sp = sp

	add(game_objects, cursor)
end

function create_destination_box(x, y, sp)
	destination_box = make_actor(x,y)
	destination_box.sp = sp

	add(game_objects, destination_box)
end

-->8
--utility functions(Not sure I need these atm)
		----------------------------------------------------
			--collision
			----------------------------------------------------
	function abs_box(s)
		local box = {}
		box.x1 = s.box.x1 + s.x
		box.y1 = s.box.y1 + s.y
		box.x2 = s.box.x2 + s.x
		box.y2 = s.box.y2 + s.y
		return box
	end

	function coll(a, b)
		local box_a = abs_box(a)
		local box_b = abs_box(b)

		if box_a.x1 > box_b.x2 or
		box_a.y1 > box_b.y2 or
		box_b.x1 > box_a.x2	 or
		box_b.y1 > box_a.y2 then
			return false
		end

		return true
	end

	function cmap(entity)
		local ct=false
		local cb=false

		-- if colliding with map tiles
		if(entity.cm) then
			local x1=entity.x/8
			local y1=entity.y/8
			local x2=(entity.x+7)/8
			local y2=(entity.y+7)/8
			local a=fget(mget(x1,y1),0)
			local b=fget(mget(x1,y2),0)
			local c=fget(mget(x2,y2),0)
			local d=fget(mget(x2,y1),0)
			ct=a or b or c or d
		 end
		 -- if colliding world bounds
		 if(entity.cw) then
			 cb=(entity.x<0 or entity.x+8>w or
						 entity.y<0 or entity.y+8>h)
		 end

		return ct or cb
	end






__gfx__
000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbcccccccccccccccc000000000000000000000000000000000000000000000000
0000000000000000000cccccccccc0000000cccccccc0000bbbbbbbbbbbbbbbbc00000000000000c000000000000000000000000000000000000000000000000
007007000000000000ccccccccccc0000000ccccccccc000bbbbbbbbbbbbbbbbc00000000000000c000000000000000000000000000000000000000000000000
000770000000000000cccccccccccc00000cccccccccc000bbbbbbbbbbbbbbbbc00000000000000c000000000000000000000000000000000000000000000000
00077000000000000cccccccccccccc0000ccccccccccc00bbbbbbbbbbbbbbbbc00000000000000c000007700000000000000000000000000000000000000000
00700700000000000cccccffffccccc000cccccccccccc00bbbbbbbbbbbbbbbbc00000000000000c000007776000000000000000000000000000000000000000
00000000000000000cffffffffffffc00cccccccccccccc0bbbbbbbbbbbbbbbbc00000000000000c000007777760000000000000000000000000000000000000
00000000000000000cffffffffffffc00cccccccccccccc0bbbbbbbbbbbbbbbbc00000000000000c000007777776000000000777777000000000000000000000
000000000000000000ccffffffffcc0000ccffffffffcc00bbbbbbbbbbbbbbbbc00000000000000c000007777777500000000777777000000000000000000000
00000000000000000000cffffffc0000000ccffffffcc000bbbbbbbbbbbbbbbbc00000000000000c000007777777000000000777777000000000000000000000
000000000000000000ccccccccccc00000ccfccccccfcc00bbbbbbbbbbbbbbbbc00000000000000c000007777650000000000000000000000000000000000000
00000000000000000cffcccccccffc000cffccccccccffc0bbbbbbbbbbbbbbbbc00000000000000c000007776000000000000000000000000000000000000000
00000000000000000cffcccccccffc000cffccccccccffc0bbbbbbbbbbbbbbbbc00000000000000c000007700000000000000000000000000000000000000000
000000000000000000ccccccccccc00000cccccccccccc00bbbbbbbbbbbbbbbbc00000000000000c000000000000000000000000000000000000000000000000
0000000000000000000cffcccccc0000000cccccccccc000bbbbbbbbbbbbbbbbc00000000000000c000000000000000000000000000000000000000000000000
00000000000000000000ccc0000000000000ccc00ccc0000bbbbbbbbbbbbbbbbcccccccccccccccc000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000033333333333333330000000000000000000000000000000000000000000000000000000000000000
000000000000000000000cccccccc000000000000000000033333333333333330770000067700000000888888888800000008888888800000000088888888000
00000000000000000000ccccccccccc0000000000000000033333333333333330777006706770000008888888888800000008888888880000000888888888880
0000000000000000000ccccccccccc00000000000000000033333333333333330677770677770000008888888888880000088888888880000008888888888800
0000000000000000000ccccccccccc00000000000000000033333333333333330067777777577000088888888888888000088888888888000008888888888800
0000000000000000000cccccccffcc00050044544444005033333333333333330006777757757000088888ffff88888000888888888888000008888888ff8800
0000000000000000000cccccccffff0000544444445445003333333333333333000067777577700008ffffffffffff8008888888888888800008888888ffff00
0000000000000000000cccccccffff0000454444444444003333333333333333000556777777700008ffffffffffff8008888888888888800008888888ffff00
0000000000000000000cccccccffff000044467676744400333333333333333300056677777707700088ffffffff88000088ffffffff88000008888888ffff00
0000000000000000000cccffccffff0000444444444544003333333333333333000066777776777000008ffffff8000000088ffffff88000000888ff88ffff00
000000000000000000000ccfffffc00000544444444445003333333333333333000006666607760000888888888880000088f888888f88000000088fffff8000
0000000000000000000000cccccc000005004544444400503333333333333333000000000067600008ff8888888ff80008ff88888888ff800000008888880000
000000000000000000000cffccc0000000000000000000003333333333333333000000000566000008ff8888888ff80008ff88888888ff80000008ff88800000
00000000000000000000ccffcccc000000000000000000003333333333333333000000000550000000888888888880000088888888888800000088ff88880000
00000000000000000000cfcccccc00000000000000000000333333333333333300000000000000000008ff8888880000000888888888800000008f8888880000
000000000000000000000cc00cc00000000000000000000033333333333333330000000000000000000088800000000000008880088800000000088008800000
__map__
9e010101010101010101010101010101010101010101018d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8e8d8e01010101010101010101010101010101010101019d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9e9d9e01010101010101010101010101010101010101018d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e8d8e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8e8d8e01010101010101010101010101010101010101019d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e9d9e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9e9d9e0101010101060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
018d8e0101010101161736371617363716173637161736371617363706063637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
019d9e0101010101262706072627060726270607262706072627060726370607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101363716173637161736371617363716173637161726261617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000060726270607262706072627060726270607262706072627060726270607000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000161736371617363716173637161736371617363716173637161736371617000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000262706072627060726270607262706072627060726270607262706072627000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000363716173637161736371617363716173637161736371617363716173637000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
