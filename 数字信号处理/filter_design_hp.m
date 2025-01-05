fs = 20000; 
fp = 5000;
fst = 3000;
Rp = 3;
As = 30;

wp = 2 * pi * fp / fs;
wst = 2 * pi * fst / fs;
% omega_p = tan(wp / 2);
% omega_st = tan(wst / 2);

omega_p = cot(wp / 2);
omega_st = cot(wst / 2);

omega_p, omega_st

% bar_omega_st = omega_p / omega_st;

N = ceil(log10((10^(0.1 * As) - 1) / (10^(0.1 * Rp) - 1)) / (2 * log10(omega_st / omega_p)));
Omegac = omega_p / ((10^(0.1 * Rp) - 1)^(1 / (2 * N)));


[b_a, a_a] = butter(N, Omegac, 's');
% s 变为 omega_p / s
% [b_a, a_a] = lp2hp(b_a, a_a, omega_p);

syms s z
% s_to_z = (1 - z^(-2)) / (1 - 2 * z^(-1) * cos(omega_0) + z^(-2));
% s_to_z = (1 - z^(-1)) / (1 + z^(-1));
s_to_z = (1 + z^(-1)) / (1 - z^(-1));
H_a_s = poly2sym(b_a, s) / poly2sym(a_a, s);
H_bs_z = subs(H_a_s, s, s_to_z);

[b_d_sym, a_d_sym] = numden(H_bs_z);
b_d = sym2poly(b_d_sym);
a_d = sym2poly(a_d_sym);

[H, W] = freqz(b_d, a_d, 1024);

% Plot the magnitude response
figure;
plot(W / pi, 20*log10(abs(H)));
grid on;
title('Magnitude Response of the Butterworth Highpass Filter (Direct Transform)');
xlabel('Normalized Frequency (\omega / \pi)');
ylabel('Magnitude (dB)');
ylim([-100, 5]);
hold on;

% Mark specific frequencies and their gains
frequencies = [wp, wst] / pi;
gains = 20 * log10(abs(freqz(b_d, a_d, frequencies * pi)));

plot(frequencies, gains, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
for i = 1:length(frequencies)
    text(frequencies(i), gains(i), sprintf('(%.2fπ, %.2f dB)', frequencies(i), gains(i)), 'VerticalAlignment', 'bottom');
end
