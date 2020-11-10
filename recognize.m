function recognize()
	points = draw("Draw a Mathematical Character or Symbol:");
	img = rasterize(points, 45);

	figure; imshow(img);

	name = rec_char(img);

	disp(strcat("You drew a: ", name))
end