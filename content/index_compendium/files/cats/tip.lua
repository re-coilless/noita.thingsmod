return function( info, tid, pic_x, pic_y, pic_z, is_simple )
    print("cat test")
    
	local xD = index.D
	if( not( pen.vld( info.pic ))) then return end
	if( not( pen.vld( info.name ))) then return end
	
	local pic_scale = 1.5
	local icon_w, icon_h = pen.get_pic_dims( info.pic )
	icon_w, icon_h = pic_scale*icon_w, pic_scale*icon_h

	local title_w, title_h = pen.get_text_dims( info.name, true )
	local desc_w, desc_h = unpack( not( pen.vld( info.desc )) and { 0, 0 }
		or pen.get_tip_dims( info.desc, math.max( title_w + 2, 100 ), -1, -2 ))
	local size_x, size_y = math.max( title_w + 2, desc_w ) + icon_w + 6, math.max( title_h + desc_h + 3, icon_h )

	return xD.tip_func( "", {
		tid = tid, info = info,
		is_active = true, allow_hover = true,
		is_left = info.in_world, do_corrections = true,
		pic_z = pic_z, pos = { pic_x, pic_y }, dims = { size_x, size_y },
	}, function( t, d )
		local info = d.info
		local size_x, size_y = unpack( d.dims )
		local pic_x, pic_y, pic_z = unpack( d.pos )
		
		local is_sampo = xD.sampo == info.id
		local inter_alpha = pen.animate( 1, d.t, { ease_out = "exp", frames = d.frames })
		pen.new_shadowed_text( pic_x + d.edging, pic_y + d.edging - 2, pic_z, info.name, {
			dims = { size_x - icon_w - 3, size_y }, fully_featured = true, alpha = inter_alpha,
			color = pen.PALETTE.VNL[( do_runes or is_sampo ) and "RUNIC" or "YELLOW" ]})
		
		if( pen.vld( info.desc )) then
			local runic_state = do_runes and pen.magic_storage( info.id, "index_runic_cypher", "value_float", nil, true ) or 1
			if( runic_state ~= 1 ) then
				pen.new_shadowed_text( pic_x + d.edging + 2, pic_y + d.edging + title_h, pic_z,
					"{>runic>{"..info.desc.."}<runic<}", { dims = { desc_w + 2, size_y },
					fully_featured = true, color = pen.PALETTE.VNL.RUNIC, alpha = inter_alpha*( 1 - runic_state ), line_offset = -2 })
				pen.magic_storage( info.id, "index_runic_cypher", "value_float", pen.estimate( "index_runic"..info.id, { 1, 0 }, "exp500" ))
			end
			if( runic_state > 0 ) then
				pen.new_shadowed_text( pic_x + d.edging + 2, pic_y + d.edging + title_h, pic_z + 0.001, info.desc, {
					dims = { desc_w + 2, size_y }, fully_featured = true, alpha = inter_alpha*runic_state, line_offset = -2 })
			end
		end
		
		local inter_size = 15*( 1 - pen.animate( 1, d.t, { ease_out = "wav1.5", frames = d.frames }))
		local pos_x, pos_y = pic_x + 0.5*inter_size, pic_y + 0.5*inter_size
		local scale_x, scale_y = size_x - inter_size, size_y - inter_size
		
		local gui, uid = pen.gui_builder()
		GuiOptionsAddForNextWidget( gui, 2 ) --NonInteractive
		GuiZSetForNextWidget( gui, pic_z + 0.01 )
		local tip_bg = "data/ui_gfx/decorations/9piece0"..( is_sampo and "" or "_gray" )..".png"
		GuiImageNinePiece( gui, uid, pos_x, pos_y, scale_x, scale_y, 1.15*math.max( 1 - inter_alpha/6, 0.1 ), tip_bg )
		
		local icon_x, icon_y = pos_x + scale_x - ( d.edging + icon_w ), pos_y + ( scale_y - icon_h )/2
		pen.new_image( icon_x, icon_y, pic_z, info.pic, { s_x = pic_scale, s_y = pic_scale, alpha = inter_alpha })
	end)
end