module Hooky
  module Openvpn
  	CONFIG_DEFAULTS = {
      auth:     {type: :string, default: 'none', from: ['none', 'MD5', 'RSA-MD5', 'SHA', 'RSA-SHA', 'SHA1', 'RSA-SHA1', 'DSA-SHA', 'DSA-SHA1-old', 'DSA-SHA1', 'RSA-SHA1-2', 'DSA', 'RIPEMD160', 'RSA-RIPEMD160', 'MD4', 'RSA-MD4', 'ecdsa-with-SHA1', 'RSA-SHA256', 'RSA-SHA384', 'RSA-SHA512', 'RSA-SHA224', 'SHA256', 'SHA384', 'SHA512', 'SHA224', 'whirlpool']},
      cipher:   {type: :string, default: 'none', from: ['none', 'DES-CFB', 'DES-CBC', 'RC2-CBC', 'RC2-CFB', 'RC2-OFB', 'DES-EDE-CBC', 'DES-EDE3-CBC', 'DES-OFB', 'DES-EDE-CFB', 'DES-EDE3-CFB', 'DES-EDE-OFB', 'DES-EDE3-OFB', 'DESX-CBC', 'BF-CBC', 'BF-CFB', 'BF-OFB', 'RC2-40-CBC', 'CAST5-CBC', 'CAST5-CFB', 'CAST5-OFB', 'RC2-64-CBC', 'AES-128-CBC', 'AES-128-OFB', 'AES-128-CFB', 'AES-192-CBC', 'AES-192-OFB', 'AES-192-CFB', 'AES-256-CBC', 'AES-256-OFB', 'AES-256-CFB', 'AES-128-CFB1', 'AES-192-CFB1', 'AES-256-CFB1', 'AES-128-CFB8', 'AES-192-CFB8', 'AES-256-CFB8', 'DES-CFB1', 'DES-CFB8', 'DES-EDE3-CFB1', 'DES-EDE3-CFB8', 'CAMELLIA-128-CBC', 'CAMELLIA-192-CBC', 'CAMELLIA-256-CBC', 'CAMELLIA-128-CFB', 'CAMELLIA-192-CFB', 'CAMELLIA-256-CFB', 'CAMELLIA-128-CFB1', 'CAMELLIA-192-CFB1', 'CAMELLIA-256-CFB1', 'CAMELLIA-128-CFB8', 'CAMELLIA-192-CFB8', 'CAMELLIA-256-CFB8', 'CAMELLIA-128-OFB', 'CAMELLIA-192-OFB', 'CAMELLIA-256-OFB', 'SEED-CBC', 'SEED-OFB', 'SEED-CFB']},
      comp_lzo: {type: :on_off, default: false},
      port:     {type: :integer, default: 1194},
      proto:    {type: :string, default: 'udp', from: ['udp', 'tcp']},
      ips:      {type: :integer, default: 1}
  	}
  end
end
