/// @description animeditor_mouseover_handle()
function animeditor_mouseover_handle() {

	if edtAnimHandleBuffer < 0{exit;}

	var size = edtAnimHandleSurfSize;
	var mx = size * clamp((mouseX mod editWidth) / editWidth, 0, 1);
	var my = size * clamp((mouseY mod editHeight) / editHeight, 0, 1);

	var p, r, g, b, m;
	p = (floor(mx) + floor(my) * size) * 4;
	r = buffer_peek(edtAnimHandleBuffer, p, buffer_u8);
	g = buffer_peek(edtAnimHandleBuffer, p+1, buffer_u8);
	b = buffer_peek(edtAnimHandleBuffer, p+2, buffer_u8);

	if is_undefined(r) || is_undefined(g) || is_undefined(b){exit;}

	m = max(r, g, b);
	if m = 0{edtAnimMouseoverHandle = -1;}
	else if r == 255{edtAnimMouseoverHandle = 0;}
	else if g == 255{edtAnimMouseoverHandle = 2;}
	else if b == 255{edtAnimMouseoverHandle = 1;}


}
