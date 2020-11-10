function recognize()
	points = draw("Draw a Mathematical Character or Symbol:");
	img = rasterize(points, 45, 45);
	name = rec_char(img);

	disp(strcat("You drew a: ", name))
end