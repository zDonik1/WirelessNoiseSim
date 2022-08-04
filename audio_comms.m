# variables
input_filename = "dayum_son.wav";
output_filename = "output";
snr_array = 0:2:10;

# reading audio from file
[samples, rate] = audioread(input_filename);
samples = samples(:,1); # taking only first channel to reduce processing time
shape = size(samples);

# making an array of bytes from samples
# NOTE: we are pretty much assuming that bitrate was 16 bits per sample
tx_data = typecast(cast(reshape(samples, 1, []) * 32767, 'int16'), 'uint8');

# samples = double, range = -1.0 ... 1.0
# bit rate = bits per sample, 16 bits, 32 bits
# 16 bits - type int16 - range = -32768 ... 32767

# -1.0 ... 1.0 -> -32767.0 ... 32767.0
# -32767.0 ... 32767.0 -> -32767 ... 32767

# casting - double -> int = 1.1 -> 1
# typecasting - double 8 bytes -> int16 2 bytes = 100101010100101 -> 1001 0101 1000 1001

# simulating multiple audio transfers with different SNR
ber_array = [];
for snr = snr_array
  # simulating wireless communication
  printf("=== starting simulation for SNR %d dB...\n", snr)
  rx_data = simulate_wireless(tx_data, snr);
  disp("=== finished simulation")

  # reconstructing audio from array of bytes
  received_audio = reshape(cast(typecast(rx_data, 'int16'), 'double') / 32768, shape);

  # calculating error
  [err_count, ber] = symerr(tx_data, rx_data)
  ber_array(end + 1) = ber;

  # writing audio to file
  audiowrite(sprintf("%s_snr%d.wav", output_filename, snr), received_audio, rate)
  disp("- wrote output audio\n")
endfor

# plotting graph
plot(snr_array, ber_array, '-o')
xlabel("SNR (dB)")
ylabel("BER")
