function [V, D] = generate_eigenvectors(imgs, num_eigenvalues)
    imgs_cov = cov(imgs);
    [V, D] = eigs(imgs_cov, num_eigenvalues);
end