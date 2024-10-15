import secrets
import hashlib
from eth_keys import keys

private_key = secrets.randbits(256)
private_key_hex = f'{private_key:064x}'
private_key_bytes = bytes.fromhex(private_key_hex)
public_key = keys.PrivateKey(private_key_bytes).public_key
public_key_bytes = public_key.to_bytes()
keccak_hash = hashlib.new("sha3_256")
keccak_hash.update(public_key_bytes)
keccak_digest = keccak_hash.hexdigest()
public_address = public_key.to_address()
print(private_key_hex, public_address)
