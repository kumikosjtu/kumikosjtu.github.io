s = tf('s');
K=45/4;
bode(K/(s+1)/(0.5*s+1)/(2*s+1))
% G0 = 10 / ((s/2 + 1) * (s/15 + 1));
% a = 1.0700;
% T = 1000;
% Gc = (a * T * s + 1) / (T * s + 1);
% G = G0 * Gc;
% bode(G0, Gc, G);
% legend('G0', 'Gc', 'G');
% grid on;