function [V, D] = char_rec(imgs, num_eigenvalues)
    imgs_cov = cov(imgs);
    [V, D] = eigs(imgs_cov, num_eigenvalues);
end