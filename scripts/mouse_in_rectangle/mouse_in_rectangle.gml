function mouse_in_rectangle(tx, ty, width, height){
    return point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
        tx, ty,
        tx + width, ty + height);
}
