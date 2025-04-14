from eth_keys import KeyAPI
keys = KeyAPI()
print(keys.ecdsa_sign(0xbf4a1ffa0bc450fad791e6631a412d46acbb2a447717c8a53037ef952981631e.to_bytes(32, byteorder='big'), KeyAPI.PrivateKey(0x1337.to_bytes(32, byteorder='big'))))