function cast_ray_plane(px, py, pz, nx, ny, nz, x1, y1, z1, x2, y2, z2) 
{
	/*
		Finds the intersection between a line segment going from [x1, y1, z1] to [x2, y2, z2], and a plane at (px, py, pz) with normal (nx, ny, nz).

		Returns the intersection as an array of the following format:
		[x, y, z, nx, ny, nz, intersection (true or false)]

		Script made by TheSnidr

		www.thesnidr.com
	*/
	var vx = x2 - x1;
	var vy = y2 - y1;
	var vz = z2 - z1;
	var dn = dot_product_3d(vx, vy, vz, nx, ny, nz);
	if (dn == 0)
	{
		return [x2, y2, z2, 0, 0, 0, false];
	}
	var dp = dot_product_3d(x1 - px, y1 - py, z1 - pz, nx, ny, nz);
	var t = - dp / dn; 
	var s = sign(dp);
	
	static ret = array_create(6);
	ret[0] = x1 + t * vx;
	ret[1] = y1 + t * vy;
	ret[2] = z1 + t * vz;
	ret[3] = s * nx;
	ret[4] = s * ny;
	ret[5] = s * nz;
	ret[6]= true;
	return ret;
}