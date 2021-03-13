function boat = create_boat(W, H, L, a, b, infill_l1, infill_l2, infill_cutoff, predicate)
	boat = struct("W", W, "H", H, "L", L, "a", a, "b", b, "infill_l1", infill_l1, "infill_l2", infill_l2, "infill_cutoff", infill_cutoff, "predicate", predicate);
end