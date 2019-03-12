function plot_result(y, t, y_d, y_d_r, uff)
if exist('uff', 'var')
    subplot(4, 1, 1);
    plot(t, [y_d, y_d_r]);
    title('Input signal');
    ylabel('Displacement (m)');
    legend('Displacement', 'Velocity', 'Acceleration');
    grid;

    subplot(4, 1, 2);
    plot(t, uff);
    title('u_{ff}');
    ylabel('Voltage (V)');
    grid;

    subplot(4, 1, 3);
    plot(t, y, t, y_d(:, 1));
    title('Output signal');
    legend('Simulation', 'Reference');
    ylabel('Displacement (m)');
    grid;

    e = abs(y_d(:, 1)-y);
    subplot(4, 1, 4);
    plot(t, e);
    title(['Error, max = ', num2str(max(e))]);
    ylabel('Error (m)');
    xlabel('Time (s)');
    grid;
else
    subplot(3, 1, 1);
    plot(t, [y_d, y_d_r]);
    title('Input signal');
    ylabel('Displacement (m)');
    legend('Displacement', 'Velocity', 'Acceleration');
    grid;

    subplot(3, 1, 2);
    plot(t, y, t, y_d(:, 1));
    title('Output signal');
    legend('Simulation', 'Reference');
    ylabel('Displacement (m)');
    grid;

    e = abs(y_d(:, 1)-y);
    subplot(3, 1, 3);
    plot(t, e);
    title(['Error, max = ', num2str(max(e))]);
    ylabel('Error (m)');
    xlabel('Time (s)');
    grid;
end
end