%setup

disp("Setup Done")

rboat = create_rendered_boat(boat, 0)

deckHeight = H;

N_y = 5;

X1 = rboat.P(1, :)';
Z1 = rboat.P(2, :)';

X2 = [X1; X1];
Z2 = [Z1; Z1];
Y2 = [ones(1, length(X1)) * 0, ones(1, length(X1)) * L]';

size(X2)
size(Z2)
size(Y2)

makeLoftedMesh(X2, Y2, deckHeight, Z2, Z2, true)