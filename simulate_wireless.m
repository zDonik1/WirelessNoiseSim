# @param tx_data must be an array of type uint8 signifying an array of bytes to
#   simulate sending
# @param snr the signal to noise ratio in dB
# @return rx_data the data that has been received after simulation. The format
#   is a array of type uint8
function rx_data = simulate_wireless(tx_data, snr)
  # making an array of binary data
  bin_seq = reshape(transpose(dec2bin(tx_data, 8) - '0'), 1, []);
  disp("- converted data to sequence of bits")

  # 3 -> '00000011'
  # [ 0 0 0 0 0 0 1 1 ]
  # [ '0' '0' ... = [ 48 48 ... 49 49 ] -> [ 0 0 ... 1 1 ]

  # binary phase shift keying modulation and adding white gaussian noise
  # NOTE: only real part can be taken since it is BPSK
  modulated = real(pskmod(bin_seq, 2)); # 0 -> 1 + 0i, 1 -> -1 + 0i
  signal = awgn(modulated, snr);
  disp("- applied bpsk modulation and awgn")

  # demodulating received signal
  received_data = pskdemod(signal, 2);
  disp("- demodulated received signal")

  # reconstructing data
  reshaped_data = reshape(received_data, 8, [])';
  num_bytes = rows(reshaped_data);
  rx_data = zeros(1, num_bytes, 'uint8');
  tic
  disp("- reconstructing data...")
  for i = 1:num_bytes
    rx_data(i) = sum(pow2(find(flip(reshaped_data(i,:))) - 1));
  endfor
  disp("- reconstructed data")
  toc
endfunction

##1 1 0 0 1 1 0 0
##1 0 1 0 0 1 0 1
##...
##
##[ 204 160 ... ]

# flip
## 1 1 0 0 1 1 0 0 -> 0 0 1 1 0 0 1 1

# find
# 0 0 1 1 0 0 1 1 -> [ 3 4 7 8 ]

# -1
# [ 3 4 7 8 ] -> [ 2 3 6 7 ]

# pow2
# [ 2 3 6 7 ] -> [ 4 9 36 49 ]

# sum
# [ 4 9 36 49 ] -> 98

# rx_data
# [ 98 103 100 ... ]

# uint8 range = 0 ... 255
