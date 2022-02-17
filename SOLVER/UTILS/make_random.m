function make_random(rmin, rmax, corr_length, maxval)
<<<<<<< HEAD
=======
% function make_random(rmin, rmax, corr_length, maxval)
% 
% Creates a random velocity model for use in AxiSEM.
% The velocity random field follows an exponential distribution
% in the k-domain with correlation length corr_length
% The perturbations are scaled to the maximum value maxval.
% Please note that AxiSEM treats this as a value in percent
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57

dx = corr_length / 2;
[x, y] = meshgrid((1:dx:rmax), (-rmax:dx:rmax));
r = sqrt(x.^2 + y.^2);
<<<<<<< HEAD

rand_ac = exp(-(x.^2 + y.^2)/corr_length^2);


rand_ft = fft2(rand_ac);
rand_field_ft = rand(size(rand_ft))*2 - 1;
% figure;
% imagesc(rand_ac);
% figure
rand_field = real(ifft2(rand_ft .* exp(2*pi*1i*rand_field_ft)));
% imagesc(rand_field)
% imagesc(r)

rand_field((r<rmin) | (r>rmax)) = 0.0;
rand_field = rand_field / max(max(rand_field)) * maxval;
figure;
imagesc(rand_field)


theta = atan2(y,x) * 180 / pi + 90;

% figure;
% imagesc(theta)

=======
theta = atan2(y,x) * 180 / pi + 90;

%% Create random field
rand_ac = exp(-(x.^2 + y.^2)/corr_length^2);
rand_ft = fft2(rand_ac);
rand_field_ft = rand(size(rand_ft))*2 - 1;
rand_field = real(ifft2(rand_ft .* exp(2*pi*1i*rand_field_ft)));

%% Normalize random field
rand_field((r<rmin) | (r>rmax)) = 0.0;
rand_field = rand_field / max(max(rand_field)) * maxval;

%% Write model to disk
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
fid = fopen('random.het', 'w');
fprintf(fid, '%d\n', length(find((r>rmin-10) & (r<rmax+10))));
for ix = 1:size(rand_field, 1)
    for iy = 1:size(rand_field, 2)
        if (r(ix, iy) > rmin-10 && r(ix, iy) < rmax+10)
            fprintf(fid, '%f %f %f %f %f\n', r(ix, iy), theta(ix, iy), ...
                    rand_field(ix, iy), rand_field(ix, iy), rand_field(ix, iy));
        end 
    end 
end
<<<<<<< HEAD
        
fclose(fid);

end 
=======
fclose(fid);

%% plot to screen
figure;
imagesc(rand_field)



% figure;
% imagesc(theta)

end 
>>>>>>> 572e2fc237182c0cc262ce1c5d2b10214c1f3b57
