# variables
input_filename = "200iq.jpg";
output_filename = "output";
snr_array = 0:2:10;

# getting image from file
base_image = imread(input_filename);
shape = size(base_image);
disp("- acquired image\n")

# deconstructing image into array of bytes
tx_data = reshape(base_image, 1, []);

# simulating multiple image transfers with different SNR
ber_array = [];
for snr = snr_array
  # simulating wireless communication
  printf("=== starting simulation for SNR %d dB...\n", snr)
  rx_data = simulate_wireless(tx_data, snr);
  disp("=== finished simulation")

  # reconstructing image from array of bytes
  received_image = reshape(rx_data, shape);

  # calculating error
  [err_count, ber] = symerr(cast(base_image, 'double'), cast(received_image, 'double'))
  ber_array(end + 1) = ber;

  # writing image to file
  imwrite(received_image, sprintf("%s_snr%d.jpg", output_filename, snr))
  disp("- wrote output image\n")
endfor

# plotting graph
plot(snr_array, ber_array, '-o')
xlabel("SNR (dB)")
ylabel("BER")
