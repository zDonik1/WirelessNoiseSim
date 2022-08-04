base_image = cast(cat(3, reshape(1:9, [3,3])', reshape(11:19, [3,3])', reshape(21:29, [3,3])'), 'uint8');

tx_data = reshape(base_image, 1, []);
disp("starting simulation...")
rx_data = simulate_wireless(tx_data, 6);
disp("finished simulation")

received_image = reshape(rx_data, [3,3,3])

[err_count, BER] = symerr(cast(base_image, 'double'), cast(received_image, 'double'))

